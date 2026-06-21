import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Placeholder for Tim B scope screens (e.g. Forgot Password, alternate
/// login/register variants) so navigation never dead-ends or crashes.
class ComingSoonPage extends StatelessWidget {
  final String title;

  const ComingSoonPage({super.key, this.title = 'Segera Hadir'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.construction_rounded, size: 56, color: AppColors.accentOrange),
              const SizedBox(height: AppSpacing.lg),
              Text('Fitur ini sedang dikembangkan', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Tunggu update selanjutnya!',
                style: AppTextStyles.bodyMuted,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
