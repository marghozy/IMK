import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/module.dart';
import '../../shared/state/user_providers.dart';

class LessonCardPage extends ConsumerStatefulWidget {
  final String moduleId;
  final String? cardId;

  const LessonCardPage({super.key, required this.moduleId, this.cardId});

  @override
  ConsumerState<LessonCardPage> createState() => _LessonCardPageState();
}

class _LessonCardPageState extends ConsumerState<LessonCardPage> {
  late LearningModule _module;
  late int _index;
  bool _playingAudio = false;

  @override
  void initState() {
    super.initState();
    _module = MockData.moduleById(widget.moduleId);
    _index = widget.cardId == null ? 0 : _module.cards.indexWhere((c) => c.id == widget.cardId).clamp(0, _module.cards.length - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncLastLesson());
  }

  void _syncLastLesson() {
    if (_module.cards.isEmpty) return;
    ref.read(lastLessonProvider.notifier).update(_module.id, _module.cards[_index].id);
  }

  void _playAudio() {
    setState(() => _playingAudio = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _playingAudio = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_module.cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: const Center(child: Text('Belum ada materi untuk modul ini.')),
      );
    }

    final card = _module.cards[_index];
    final progress = (_index + 1) / _module.cards.length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.chevron_left)),
                  Expanded(child: AppProgressBar(value: progress, color: _module.color)),
                  const SizedBox(width: AppSpacing.sm),
                  Text('${_index + 1}/${_module.cards.length}', style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                  decoration: BoxDecoration(color: _module.color.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(AppRadius.full)),
                  child: Text('${_module.title.toUpperCase()} · ${card.title}',
                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        Text(card.aksara, style: AppTextStyles.aksara(size: 72, color: _module.color.withAlpha(255).withValues(alpha: 1)).copyWith(color: AppColors.ink)),
                        const SizedBox(height: AppSpacing.md),
                        Text('— ${card.title}', style: AppTextStyles.h2),
                        const SizedBox(height: AppSpacing.sm),
                        InkWell(
                          onTap: _playAudio,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: _playingAudio ? AppColors.primary : AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.volume_up_rounded, color: _playingAudio ? Colors.white : AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(card.description, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                        const SizedBox(height: AppSpacing.lg),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: _module.color.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.body,
                              children: [
                                const TextSpan(text: 'Contoh: '),
                                TextSpan(text: card.example, style: AppTextStyles.aksara(size: 18)),
                                TextSpan(text: ' = ${card.exampleMeaning}'),
                              ],
                            ),
                          ),
                        ),
                        if (card.attributes.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: card.attributes
                                .map((a) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.full)),
                                      child: Text(a, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                                    ))
                                .toList(),
                          ),
                        ],
                        if (card.tip != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('💡 ', style: TextStyle(fontSize: 16)),
                                Expanded(child: Text(card.tip!, style: AppTextStyles.bodyMuted)),
                              ],
                            ),
                          ),
                        ],
                        if (card.warning != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('⚠️ ', style: TextStyle(fontSize: 16)),
                                Expanded(child: Text(card.warning!, style: AppTextStyles.bodyMuted)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Sebelumnya',
                      variant: AppButtonVariant.outline,
                      onPressed: _index > 0 ? () => setState(() { _index--; _syncLastLesson(); }) : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: _index == _module.cards.length - 1 ? 'Latihan Menulis' : 'Selanjutnya',
                      onPressed: () {
                        if (_index == _module.cards.length - 1) {
                          context.push('/learn/${_module.id}/write/${card.id}');
                        } else {
                          setState(() { _index++; _syncLastLesson(); });
                        }
                      },
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
}
