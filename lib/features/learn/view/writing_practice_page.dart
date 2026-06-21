import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/mock/mock_data.dart';
import '../widgets/tracing_canvas.dart';

class WritingPracticePage extends StatefulWidget {
  final String moduleId;
  final String cardId;

  const WritingPracticePage({super.key, required this.moduleId, required this.cardId});

  @override
  State<WritingPracticePage> createState() => _WritingPracticePageState();
}

class _WritingPracticePageState extends State<WritingPracticePage> {
  final _canvasKey = GlobalKey<TracingCanvasState>();

  @override
  Widget build(BuildContext context) {
    final module = MockData.moduleById(widget.moduleId);
    final card = module.cards.firstWhere((c) => c.id == widget.cardId, orElse: () => module.cards.first);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => _confirmExit(context),
        ),
        title: const Text('Latihan Menulis'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Text('Telusuri bentuk aksara "${card.title}"', style: AppTextStyles.bodyMuted),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Opacity(
                          opacity: 0.18,
                          child: Text(card.aksara, style: AppTextStyles.aksara(size: 160)),
                        ),
                      ),
                      TracingCanvas(key: _canvasKey, onStrokeChanged: () => setState(() {})),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Ulangi',
                      variant: AppButtonVariant.outline,
                      icon: Icons.refresh_rounded,
                      onPressed: () => _canvasKey.currentState?.clear(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Selesai',
                      onPressed: (_canvasKey.currentState?.hasStrokes ?? false)
                          ? () => context.go('/learn')
                          : () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Coba tulis dulu sebelum lanjut')),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari latihan?'),
        content: const Text('Goresanmu saat ini tidak akan disimpan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: Text('Keluar', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}
