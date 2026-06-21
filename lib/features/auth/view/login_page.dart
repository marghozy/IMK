import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../state/auth_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'thariq@example.com');
  final _passwordController = TextEditingController(text: 'rahasia123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscure = !ref.watch(loginPasswordVisibleProvider);

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
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.lg)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.auto_stories_rounded, size: 44, color: Colors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: Text('Selamat Datang', style: AppTextStyles.h1, textAlign: TextAlign.center),
              ),
              const SizedBox(height: AppSpacing.xs),
              Center(child: Text('Masuk untuk lanjut belajar Aksara Jawa', style: AppTextStyles.bodyMuted)),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined), hintText: 'Email'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Kata sandi',
                  suffixIcon: IconButton(
                    icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => ref.read(loginPasswordVisibleProvider.notifier).toggle(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: Text('Lupa kata sandi?', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: 'MASUK', onPressed: () => context.go('/home')),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text('ATAU', style: AppTextStyles.caption),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/coming-soon', extra: 'Masuk dengan Google'),
                      child: const Text('Google'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/coming-soon', extra: 'Masuk dengan Apple'),
                      icon: const Icon(Icons.apple, size: 20),
                      label: const Text('Apple'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Wrap(
                  children: [
                    Text('Belum punya akun? ', style: AppTextStyles.bodyMuted),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text('Daftar', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
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
