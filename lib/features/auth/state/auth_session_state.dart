import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_auth_repository.dart';
import '../../shared/state/user_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => LocalAuthRepository());

/// Holds the authenticated user (or null if signed out). Register/login
/// errors surface via [AsyncValue.error] so pages can show them inline.
class AuthSessionNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() => ref.read(authRepositoryProvider).restoreSession();

  Future<void> register({required String name, required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).register(name: name, email: email, password: password);
      ref.read(userProvider.notifier).setUser(user);
      return user;
    });
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email: email, password: password);
      ref.read(userProvider.notifier).setUser(user);
      return user;
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

final authSessionProvider = AsyncNotifierProvider<AuthSessionNotifier, AppUser?>(AuthSessionNotifier.new);
