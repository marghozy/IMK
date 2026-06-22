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
                    ElevatedButton(
                      onPressed: () => context.go('/onboarding'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text('MULAI — AKU PEMULA',
                          style: AppTextStyles.button.copyWith(color: AppColors.primary)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton(
                      onPressed: () => context.go('/login'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text('SUDAH PUNYA AKUN',
                          style: AppTextStyles.button.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Dengan melanjutkan, kamu setuju dengan Syarat & Privasi',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white.withValues(alpha: 0.75)),
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
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(Icons.menu_book_rounded, size: 16, color: AppColors.primary),
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
    (glyph: 'ꦩꦤ', align: Alignment(-0.92, -0.92), size: 28, angle: -0.22, color: null),
    (glyph: 'ꦤ', align: Alignment(0.88, -0.94), size: 26, angle: 0.28, color: null),
    (glyph: 'ꦤ', align: Alignment(0.94, -0.7), size: 30, angle: 0.3, color: null),
    (glyph: 'ꦤ', align: Alignment(-0.94, -0.7), size: 26, angle: -0.18, color: null),
    (glyph: 'ꦭ', align: Alignment(-0.97, -0.42), size: 30, angle: 0.2, color: null),
    (glyph: 'ꦟ', align: Alignment(0.95, -0.42), size: 28, angle: -0.32, color: null),
    (glyph: 'ꦤꦏ', align: Alignment(-0.95, -0.14), size: 26, angle: 0.16, color: null),
    (glyph: 'ꦱ', align: Alignment(0.96, -0.14), size: 28, angle: -0.2, color: null),
    (glyph: 'ꦢ', align: Alignment(-0.94, 0.14), size: 26, angle: 0.24, color: null),
    (glyph: 'ꦮ', align: Alignment(0.95, 0.14), size: 30, angle: -0.18, color: null),
    (glyph: 'ꦕ', align: Alignment(-0.92, 0.42), size: 28, angle: -0.16, color: null),
    (glyph: 'ꦫ', align: Alignment(0.92, 0.42), size: 26, angle: 0.22, color: null),
    (glyph: 'ꦏ', align: Alignment(-0.9, 0.9), size: 30, angle: 0.18, color: null),
    (glyph: 'ꦱ', align: Alignment(0.9, 0.9), size: 26, angle: -0.24, color: null),
    (glyph: 'ꦲ', align: Alignment(-0.42, -0.96), size: 24, angle: -0.14, color: null),
    (glyph: 'ꦤ', align: Alignment(0.42, -0.96), size: 24, angle: 0.14, color: null),
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
                    color: g.color ?? Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
