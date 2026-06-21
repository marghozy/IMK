import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/step_dots.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = <Widget>[
    _IntroSlide(),
    _StepsSlide(),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      context.push('/onboarding/pilih-tujuan');
    }
  }

  void _back() {
    if (_index > 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              SizedBox(height: 40, child: _Header(index: _index, onBack: _back)),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => _pages[i],
                ),
              ),
              // The flow has 3 steps total; the goal-selection screen is step 3.
              StepDots(count: 3, activeIndex: _index),
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'LANJUT', onPressed: _next),
            ],
          ),
        ),
      ),
    );
  }
}

/// Top bar: "Lewati" on the first page, a back chevron afterwards.
class _Header extends StatelessWidget {
  final int index;
  final VoidCallback onBack;
  const _Header({required this.index, required this.onBack});

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => context.push('/onboarding/pilih-tujuan'),
          child: Text('Lewati', style: AppTextStyles.bodyMuted),
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onBack,
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(Icons.chevron_left, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}

/// Page 1 — single green card with a sample aksara.
class _IntroSlide extends StatelessWidget {
  const _IntroSlide();

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
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.full)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome,
                          size: 12, color: AppColors.primaryDark),
                      const SizedBox(width: 4),
                      Text('Baru!',
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text('ꦤꦒꦫ',
                    style:
                        AppTextStyles.aksara(size: 72, color: AppColors.primary)),
              ),
              Positioned(
                bottom: AppSpacing.md,
                right: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      borderRadius: BorderRadius.circular(AppRadius.full)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department,
                          size: 13, color: Colors.white),
                      const SizedBox(width: 4),
                      Text('7 hari',
                          style: AppTextStyles.caption.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Belajar Aksara Jawa\njadi menyenangkan',
            style: AppTextStyles.h1, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Mulai dari Nglegena, Sandhangan, hingga Pasangan dengan kartu, kuis, dan reward harian.',
          style: AppTextStyles.bodyMuted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Page 2 — "Cara belajar di JawaLingo" with three numbered steps.
class _StepsSlide extends StatelessWidget {
  const _StepsSlide();

  static const _steps = [
    (
      label: 'LANGKAH 1',
      color: AppColors.primary,
      icon: Icons.auto_stories_rounded,
      title: 'Pelajari Karakter',
      desc: 'Kartu interaktif untuk tiap aksara dengan audio.',
    ),
    (
      label: 'LANGKAH 2',
      color: AppColors.accentBlue,
      icon: Icons.edit_rounded,
      title: 'Latihan Menulis',
      desc: 'Telusuri urutan goresan langsung di layar.',
    ),
    (
      label: 'LANGKAH 3',
      color: AppColors.accentOrange,
      icon: Icons.bolt_rounded,
      title: 'Quiz & Reward',
      desc: 'Uji ingatanmu dan kumpulkan XP setiap hari.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text('Cara belajar di\nJawaLingo', style: AppTextStyles.display),
        const SizedBox(height: AppSpacing.sm),
        Text('Tiga langkah sederhana untuk fasih membaca.',
            style: AppTextStyles.bodyMuted),
        const SizedBox(height: AppSpacing.xl),
        for (final s in _steps) ...[
          _StepCard(
            label: s.label,
            color: s.color,
            icon: s.icon,
            title: s.title,
            desc: s.desc,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final String title;
  final String desc;

  const _StepCard({
    required this.label,
    required this.color,
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(label,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      )),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(title,
                    style: AppTextStyles.h2.copyWith(color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(desc, style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
