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
        child: Stack(
          children: [
            const _AksaraBackdrop(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    _LogoHeader(),
                    const Spacer(),
                    _Mascot(),
                    const SizedBox(height: AppSpacing.xl),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.display.copyWith(color: Colors.white),
                        children: [
                          const TextSpan(text: 'Halo,\naku '),
                          TextSpan(
                            text: 'Caraka!',
                            style: TextStyle(color: AppColors.accentYellow),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Ayo belajar Aksara Jawa\nbareng gratis & menyenangkan!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body
                          .copyWith(color: Colors.white.withValues(alpha: 0.9)),
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
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(Icons.menu_book_rounded,
              size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'JAWALINGO',
          style: AppTextStyles.h2.copyWith(color: Colors.white, letterSpacing: 2),
        ),
      ],
    );
  }
}

class _Mascot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo_jawa.png',
      width: 170,
      height: 170,
      fit: BoxFit.contain,
    );
  }
}

/// Decorative Javanese-script glyphs floating behind the splash content.
class _AksaraBackdrop extends StatelessWidget {
  const _AksaraBackdrop();

  // Glyph, alignment, font size, rotation (radians) and optional accent colour.
  static const List<
      ({
        String glyph,
        Alignment align,
        double size,
        double angle,
        Color? color
      })> _glyphs = [
    (glyph: 'ꦩꦤ', align: Alignment(-0.62, -0.8), size: 30, angle: -0.22, color: null),
    (glyph: 'ꦤ', align: Alignment(0.5, -0.62), size: 30, angle: 0.28, color: null),
    (glyph: 'ꦤ', align: Alignment(0.62, -0.34), size: 34, angle: 0.3, color: AppColors.accentYellow),
    (glyph: 'ꦤ', align: Alignment(-0.55, -0.18), size: 30, angle: -0.18, color: null),
    (glyph: 'ꦭ', align: Alignment(-0.92, -0.08), size: 34, angle: 0.2, color: null),
    (glyph: 'ꦟ', align: Alignment(0.82, 0.12), size: 32, angle: -0.32, color: null),
    (glyph: 'ꦤꦏ', align: Alignment(-0.6, 0.46), size: 30, angle: 0.16, color: null),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          for (final g in _glyphs)
            Align(
              alignment: g.align,
              child: Transform.rotate(
                angle: g.angle,
                child: Text(
                  g.glyph,
                  style: AppTextStyles.aksara(
                    size: g.size,
                    color: g.color ?? Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
