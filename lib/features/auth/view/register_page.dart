import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../goal_selection/state/goal_selection_state.dart';
import '../../shared/state/user_providers.dart';
import '../state/auth_session_state.dart';
import '../state/auth_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_nameController.text.trim().isEmpty) return 'Nama tidak boleh kosong.';
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) return 'Format email tidak valid.';
    if (_passwordController.text.length < 6) return 'Kata sandi minimal 6 karakter.';
    if (_passwordController.text != _confirmController.text) return 'Konfirmasi kata sandi tidak sama.';
    return null;
  }

  Future<void> _submit() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }
    setState(() => _errorMessage = null);

    await ref.read(authSessionProvider.notifier).register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

    final result = ref.read(authSessionProvider);
    if (!mounted) return;

    if (result.hasError) {
      final error = result.error;
      setState(() => _errorMessage = error is AuthException ? error.message : 'Gagal mendaftar. Coba lagi.');
      return;
    }

    final goalId = ref.read(selectedGoalProvider);
    if (goalId.isNotEmpty) {
      ref.read(userProvider.notifier).setDailyGoal(goalId);
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final obscurePw = !ref.watch(registerPasswordVisibleProvider);
    final obscureConfirm = !ref.watch(registerConfirmVisibleProvider);
    final termsAccepted = ref.watch(termsAcceptedProvider);
    final isLoading = ref.watch(authSessionProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => context.canPop() ? context.pop() : context.go('/'),
                icon: const Icon(Icons.chevron_left),
                style: IconButton.styleFrom(backgroundColor: AppColors.surface),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Buat Akun Baru', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.xs),
              Text('Mulai perjalananmu belajar Aksara Jawa.', style: AppTextStyles.bodyMuted),
              const SizedBox(height: AppSpacing.xl),
              Text('NAMA LENGKAP', style: AppTextStyles.labelUppercase),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('EMAIL', style: AppTextStyles.labelUppercase),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('KATA SANDI', style: AppTextStyles.labelUppercase),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _passwordController,
                obscureText: obscurePw,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePw ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => ref.read(registerPasswordVisibleProvider.notifier).toggle(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('KONFIRMASI', style: AppTextStyles.labelUppercase),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _confirmController,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => ref.read(registerConfirmVisibleProvider.notifier).toggle(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              GestureDetector(
                onTap: () => ref.read(termsAcceptedProvider.notifier).toggle(),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: termsAccepted ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: termsAccepted,
                        activeColor: AppColors.primary,
                        onChanged: (_) => ref.read(termsAcceptedProvider.notifier).toggle(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodyMuted,
                              children: [
                                const TextSpan(text: 'Saya setuju dengan '),
                                TextSpan(
                                  text: 'Syarat & Ketentuan',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.push('/legal/terms'),
                                ),
                                const TextSpan(text: ' serta '),
                                TextSpan(
                                  text: 'Kebijakan Privasi',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.push('/legal/privacy'),
                                ),
                                const TextSpan(text: ' JawaLingo.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(_errorMessage!, style: AppTextStyles.caption.copyWith(color: AppColors.danger)),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'DAFTAR SEKARANG',
                loading: isLoading,
                onPressed: termsAccepted ? _submit : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Wrap(
                  children: [
                    Text('Sudah punya akun? ', style: AppTextStyles.bodyMuted),
                    GestureDetector(
                      onTap: () => context.push('/login'),
                      child: Text('Masuk', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
