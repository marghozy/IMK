import '../models/user.dart';

/// Thrown by [AuthRepository] implementations on auth failures
/// (invalid credentials, email already registered, etc).
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Backend-agnostic auth contract. Swap [LocalAuthRepository] for a
/// Firebase-backed implementation (`firebase_auth` + `cloud_firestore`)
/// once a Firebase project is configured — UI only depends on this
/// interface via [authRepositoryProvider].
abstract class AuthRepository {
  Future<AppUser> register({required String name, required String email, required String password});
  Future<AppUser> login({required String email, required String password});
  Future<void> logout();
  Future<AppUser?> restoreSession();
}
