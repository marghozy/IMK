import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../state/auth_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController(text: 'Thariq Habibi');
  final _emailController = TextEditingController(text: 'thariq@example.com');
  final _passwordController = TextEditingController(text: 'rahasia123');
  final _confirmController = TextEditingController(text: 'rahasia123');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscurePw = !ref.watch(registerPasswordVisibleProvider);
    final obscureConfirm = !ref.watch(registerConfirmVisibleProvider);
    final termsAccepted = ref.watch(termsAcceptedProvider);

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
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'DAFTAR SEKARANG',
                onPressed: termsAccepted ? () => context.go('/home') : null,
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
