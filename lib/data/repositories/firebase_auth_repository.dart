import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../models/user.dart';
import 'auth_repository.dart';

/// Firebase-backed [AuthRepository]. Credentials are handled by Firebase
/// Auth; the rest of the profile ([AppUser.level], `totalXp`, `streakDays`,
/// badges, settings) lives in Cloud Firestore at `users/{uid}`.
///
/// This replaces [LocalAuthRepository] now that a Firebase project is
/// configured — see [authRepositoryProvider] in `auth_session_state.dart`.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb_auth.FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? fb_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  AppUser _userFromData(String uid, String email, Map<String, dynamic> data) {
    return AppUser(
      id: uid,
      name: data['name'] as String? ?? '',
      email: email,
      level: data['level'] as int? ?? 1,
      totalXp: data['totalXp'] as int? ?? 0,
      streakDays: data['streakDays'] as int? ?? 0,
      dailyGoalId: data['dailyGoalId'] as String? ?? 'reguler',
      badgeIds: List<String>.from(data['badgeIds'] as List? ?? const []),
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      darkModeEnabled: data['darkModeEnabled'] as bool? ?? false,
      musicEnabled: data['musicEnabled'] as bool? ?? true,
      sfxEnabled: data['sfxEnabled'] as bool? ?? true,
      volume: (data['volume'] as num?)?.toDouble() ?? 0.7,
    );
  }

  /// Maps Firebase's English error codes to user-facing Indonesian messages.
  String _mapAuthError(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan masuk.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah, minimal 6 karakter.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi beberapa saat lagi.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
      default:
        return e.message ?? 'Terjadi kesalahan, coba lagi.';
    }
  }

  @override
  Future<AppUser> register({required String name, required String email, required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(name.trim());

      final profile = <String, dynamic>{
        'name': name.trim(),
        'level': 1,
        'totalXp': 0,
        'streakDays': 0,
        'dailyGoalId': 'reguler',
        'badgeIds': <String>[],
        'notificationsEnabled': true,
        'darkModeEnabled': false,
        'musicEnabled': true,
        'sfxEnabled': true,
        'volume': 0.7,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _userDoc(user.uid).set(profile);

      return _userFromData(user.uid, user.email ?? email.trim(), profile);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  @override
  Future<AppUser> login({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      final snapshot = await _userDoc(user.uid).get();
      final data = snapshot.data() ?? const <String, dynamic>{};
      return _userFromData(user.uid, user.email ?? email.trim(), data);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Future<AppUser?> restoreSession() async {
    final current = _auth.currentUser;
    if (current == null) return null;
    final snapshot = await _userDoc(current.uid).get();
    final data = snapshot.data() ?? const <String, dynamic>{};
    return _userFromData(current.uid, current.email ?? '', data);
  }
}
