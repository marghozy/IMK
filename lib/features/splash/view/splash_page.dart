import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text('JAWALINGO',
                      style: AppTextStyles.h2.copyWith(color: AppColors.primary, letterSpacing: 1)),
                ),
                const Spacer(),
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(color: Color(0xFFFFD9A0), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Text('🙂', style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: AppSpacing.xl),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.display.copyWith(color: Colors.white),
                    children: [
                      const TextSpan(text: 'Halo,\naku '),
                      TextSpan(text: 'Caraka!', style: TextStyle(color: AppColors.accentYellow)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ayo belajar Aksara Jawa\nbareng gratis & menyenangkan!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
                const Spacer(),
                AppButton(
                  label: 'MULAI — AKU PEMULA',
                  variant: AppButtonVariant.primary,
                  onPressed: () => context.go('/onboarding'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: Text('SUDAH PUNYA AKUN',
                      style: AppTextStyles.button.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Dengan melanjutkan, kamu setuju dengan Syarat & Privasi',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
