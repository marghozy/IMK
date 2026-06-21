import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/user.dart';
import '../../shared/state/user_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final badges = MockData.badges;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xl),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.lg)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white,
                    child: Text(user.initials, style: AppTextStyles.display.copyWith(color: AppColors.primary)),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(user.name, style: AppTextStyles.h1.copyWith(color: Colors.white)),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 18),
                      const SizedBox(width: 4),
                      Text('Level ${user.level}', style: AppTextStyles.body.copyWith(color: Colors.white)),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(AppRadius.full)),
                        child: const Text('MEMBER', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _StatBox(value: '${(user.totalXp / 1000).toStringAsFixed(1)}K', label: 'XP TOTAL', color: AppColors.primary)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _StatBox(value: '${user.streakDays}', label: 'STREAK')),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _StatBox(value: '${badges.where((b) => !b.locked).length}', label: 'BADGES')),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('🏆 PENCAPAIAN', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.85,
                    children: badges.map((b) => _BadgeCard(badge: b)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('⚙️ PENGATURAN', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleRow(
                    emoji: '🔔',
                    title: 'Notifikasi',
                    subtitle: 'Ingatkan waktu belajar',
                    value: user.notificationsEnabled,
                    onChanged: (v) => ref.read(userProvider.notifier).toggleNotifications(v),
                  ),
                  _ToggleRow(
                    emoji: '🌙',
                    title: 'Mode Gelap',
                    subtitle: 'Hemat baterai',
                    value: user.darkModeEnabled,
                    onChanged: (v) => ref.read(userProvider.notifier).toggleDarkMode(v),
                  ),
                  _LinkRow(emoji: '🌐', title: 'Bahasa', onTap: () => context.push('/settings/language')),
                  _LinkRow(emoji: '🔐', title: 'Ubah Kata Sandi', onTap: () => context.push('/settings/password')),
                  const SizedBox(height: AppSpacing.xl),
                  Text('🎵 SUARA', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleRow(
                    emoji: '🎵',
                    title: 'Musik Latar',
                    value: user.musicEnabled,
                    onChanged: (v) => ref.read(userProvider.notifier).toggleMusic(v),
                  ),
                  _ToggleRow(
                    emoji: '🔊',
                    title: 'Efek Suara',
                    value: user.sfxEnabled,
                    onChanged: (v) => ref.read(userProvider.notifier).toggleSfx(v),
                  ),
                  _LinkRow(emoji: '🔈', title: 'Volume', onTap: () => _showVolumeSheet(context, ref, user)),
                  const SizedBox(height: AppSpacing.xl),
                  Text('ℹ️ TENTANG', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(emoji: '📧', title: 'Email', subtitle: user.email),
                  _InfoRow(emoji: '📱', title: 'Versi Aplikasi', subtitle: '1.2.0'),
                  _LinkRow(emoji: '📜', title: 'Syarat & Privasi', onTap: () => context.push('/legal/terms')),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Keluar Akun',
                    variant: AppButtonVariant.danger,
                    icon: Icons.logout_rounded,
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu masuk lagi untuk melanjutkan belajar.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/');
            },
            child: Text('Keluar', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _showVolumeSheet(BuildContext context, WidgetRef ref, AppUser user) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final current = ref.watch(userProvider).volume;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Volume', style: AppTextStyles.h2),
                Slider(
                  value: current,
                  activeColor: AppColors.primary,
                  onChanged: (v) => ref.read(userProvider.notifier).setVolume(v),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;

  const _StatBox({required this.value, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h2.copyWith(color: color)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final AppBadge badge;
  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.locked ? 0.45 : 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(badge.emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: AppSpacing.xs),
              Text(badge.title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
              Text(badge.earnedOn, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({required this.emoji, required this.title, this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Switch(value: value, activeColor: AppColors.primary, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const _LinkRow({required this.emoji, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700))),
                const Icon(Icons.chevron_right_rounded, color: AppColors.inkMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _InfoRow({required this.emoji, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
