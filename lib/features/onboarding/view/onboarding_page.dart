import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';

class _Slide {
  final String? badge;
  final String aksara;
  final String? pillText;
  final String title;
  final String subtitle;

  const _Slide({this.badge, required this.aksara, this.pillText, required this.title, required this.subtitle});
}

const _slides = [
  _Slide(
    badge: '✨ Baru!',
    aksara: 'ꦤꦒꦫ',
    pillText: '🔥 7 hari',
    title: 'Belajar Aksara Jawa\njadi menyenangkan',
    subtitle: 'Mulai dari Nglegena, Sandhangan, hingga Pasangan dengan kartu, kuis, dan reward harian.',
  ),
  _Slide(
    aksara: '📖',
    title: 'Pelajari Karakter',
    subtitle: 'Kartu interaktif untuk tiap aksara dengan audio.',
  ),
  _Slide(
    aksara: '✏️',
    title: 'Latihan Menulis',
    subtitle: 'Telusuri urutan goresan langsung di layar.',
  ),
  _Slide(
    aksara: '⚡',
    title: 'Quiz & Reward',
    subtitle: 'Uji ingatanmu dan kumpulkan XP setiap hari.',
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index < _slides.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      context.go('/onboarding/pilih-tujuan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/onboarding/pilih-tujuan'),
                  child: Text('Lewati', style: AppTextStyles.bodyMuted),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'LANJUT', onPressed: _next),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Stack(
            children: [
              if (slide.badge != null)
                Positioned(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Text(slide.badge!, style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                  ),
                ),
              Center(
                child: slide.aksara.length <= 2 && !RegExp(r'[\u{A980}-\u{A9DF}]', unicode: true).hasMatch(slide.aksara)
                    ? Text(slide.aksara, style: const TextStyle(fontSize: 64))
                    : Text(slide.aksara, style: AppTextStyles.aksara(size: 64, color: AppColors.primaryDark)),
              ),
              if (slide.pillText != null)
                Positioned(
                  bottom: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.accentYellow, borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Text(slide.pillText!, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(slide.title, style: AppTextStyles.h1, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        Text(slide.subtitle, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
      ],
    );
  }
}
