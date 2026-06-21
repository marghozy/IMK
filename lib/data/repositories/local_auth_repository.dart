import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'auth_repository.dart';

/// Local-storage backed [AuthRepository], standing in for a real backend
/// (Firebase Auth + Firestore) until a Firebase project is configured.
/// Accounts and "current session" are persisted via [SharedPreferences] so
/// register/login actually create and restore accounts across app restarts.
class LocalAuthRepository implements AuthRepository {
  static const _accountsKey = 'auth_accounts_v1';
  static const _currentUserIdKey = 'auth_current_user_id_v1';

  // Not a security-grade hash — this is a local mock backend. Swap for
  // real Firebase Auth (which never exposes/stores raw passwords client
  // side) once a Firebase project is configured.
  String _hash(String password) {
    final bytes = utf8.encode(password);
    var hash = 0;
    for (final b in bytes) {
      hash = (hash * 31 + b) & 0x7fffffff;
    }
    return hash.toString();
  }

  Future<Map<String, dynamic>> _loadAccounts(SharedPreferences prefs) async {
    final raw = prefs.getString(_accountsKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> _saveAccounts(SharedPreferences prefs, Map<String, dynamic> accounts) async {
    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  AppUser _userFromAccount(Map<String, dynamic> account) {
    return AppUser(
      id: account['id'] as String,
      name: account['name'] as String,
      email: account['email'] as String,
      level: account['level'] as int? ?? 1,
      totalXp: account['totalXp'] as int? ?? 0,
      streakDays: account['streakDays'] as int? ?? 0,
      dailyGoalId: account['dailyGoalId'] as String? ?? 'reguler',
      badgeIds: List<String>.from(account['badgeIds'] as List? ?? const []),
    );
  }

  @override
  Future<AppUser> register({required String name, required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await _loadAccounts(prefs);
    final normalizedEmail = email.trim().toLowerCase();

    if (accounts.containsKey(normalizedEmail)) {
      throw const AuthException('Email sudah terdaftar. Silakan masuk.');
    }

    final account = {
      'id': 'u-${DateTime.now().millisecondsSinceEpoch}',
      'name': name.trim(),
      'email': normalizedEmail,
      'passwordHash': _hash(password),
      'level': 1,
      'totalXp': 0,
      'streakDays': 0,
      'dailyGoalId': 'reguler',
      'badgeIds': <String>[],
    };
    accounts[normalizedEmail] = account;
    await _saveAccounts(prefs, accounts);
    await prefs.setString(_currentUserIdKey, normalizedEmail);

    return _userFromAccount(account);
  }

  @override
  Future<AppUser> login({required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await _loadAccounts(prefs);
    final normalizedEmail = email.trim().toLowerCase();

    final account = accounts[normalizedEmail] as Map<String, dynamic>?;
    if (account == null || account['passwordHash'] != _hash(password)) {
      throw const AuthException('Email atau kata sandi salah.');
    }

    await prefs.setString(_currentUserIdKey, normalizedEmail);
    return _userFromAccount(account);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
  }

  @override
  Future<AppUser?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString(_currentUserIdKey);
    if (currentEmail == null) return null;
    final accounts = await _loadAccounts(prefs);
    final account = accounts[currentEmail] as Map<String, dynamic>?;
    if (account == null) return null;
    return _userFromAccount(account);
  }
}
