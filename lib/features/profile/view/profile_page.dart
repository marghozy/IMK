import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/section_label.dart';
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
                  const SectionLabel(icon: Icons.emoji_events_rounded, text: 'PENCAPAIAN'),
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
                  const SectionLabel(icon: Icons.settings_rounded, text: 'PENGATURAN'),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleRow(
                    icon: Icons.notifications_rounded,
                    title: 'Notifikasi',
                    subtitle: 'Ingatkan waktu belajar',
                    value: user.notificationsEnabled,
                    onChanged: (v) {
                      if (v) {
                        context.push('/coming-soon', extra: 'Notifikasi');
                        return;
                      }
                      ref.read(userProvider.notifier).toggleNotifications(v);
                    },
                  ),
                  _ToggleRow(
                    icon: Icons.dark_mode_rounded,
                    title: 'Mode Gelap',
                    subtitle: 'Hemat baterai',
                    value: user.darkModeEnabled,
                    onChanged: (v) => ref.read(userProvider.notifier).toggleDarkMode(v),
                  ),
                  _LinkRow(icon: Icons.language_rounded, title: 'Bahasa', onTap: () => context.push('/settings/language')),
                  _LinkRow(icon: Icons.lock_rounded, title: 'Ubah Kata Sandi', onTap: () => context.push('/settings/password')),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionLabel(icon: Icons.graphic_eq_rounded, text: 'SUARA'),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleRow(
                    icon: Icons.music_note_rounded,
                    title: 'Musik Latar',
                    value: user.musicEnabled,
                    onChanged: (v) {
                      if (v) {
                        context.push('/coming-soon', extra: 'Musik Latar');
                        return;
                      }
                      ref.read(userProvider.notifier).toggleMusic(v);
                    },
                  ),
                  _ToggleRow(
                    icon: Icons.volume_up_rounded,
                    title: 'Efek Suara',
                    value: user.sfxEnabled,
                    onChanged: (v) {
                      if (v) {
                        context.push('/coming-soon', extra: 'Efek Suara');
                        return;
                      }
                      ref.read(userProvider.notifier).toggleSfx(v);
                    },
                  ),
                  _LinkRow(icon: Icons.volume_down_rounded, title: 'Volume', onTap: () => context.push('/coming-soon', extra: 'Volume')),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionLabel(icon: Icons.info_rounded, text: 'TENTANG'),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(icon: Icons.email_rounded, title: 'Email', subtitle: user.email),
                  _InfoRow(icon: Icons.phone_android_rounded, title: 'Versi Aplikasi', subtitle: '1.2.0'),
                  _LinkRow(icon: Icons.description_rounded, title: 'Syarat & Privasi', onTap: () => context.push('/legal/terms')),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Keluar Akun',
                    variant: AppButtonVariant.danger,
                    icon: Icons.logout_rounded,
                    onPressed: () => _confirmLogout(context, user.streakDays),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, int streakDays) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.62),
      builder: (ctx) => _LogoutDialog(
        streakDays: streakDays,
        onCancel: () => Navigator.pop(ctx),
        onLogout: () {
          Navigator.pop(ctx);
          context.go('/');
        },
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  final int streakDays;
  final VoidCallback onCancel;
  final VoidCallback onLogout;

  const _LogoutDialog({required this.streakDays, required this.onCancel, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 284),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/modal_logout.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Keluar dari akun?',
                  style: AppTextStyles.h2.copyWith(fontSize: 17, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: 'Kamu harus masuk lagi untuk melanjutkan\n',
                    children: [
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(Icons.local_fire_department_rounded,
                            size: 14, color: AppColors.accentOrange),
                      ),
                      TextSpan(
                        text: ' $streakDays hari',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accentOrange,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const TextSpan(text: ' belajar. Streak tetap aman, kok.'),
                    ],
                  ),
                  style: AppTextStyles.caption.copyWith(height: 1.35),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _LogoutDialogButton(
                        label: 'BATAL',
                        foregroundColor: AppColors.ink,
                        backgroundColor: AppColors.surface,
                        shadowColor: AppColors.border,
                        borderColor: AppColors.border,
                        onPressed: onCancel,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LogoutDialogButton(
                        label: 'KELUAR',
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFFF4B4B),
                        shadowColor: AppColors.dangerDark,
                        onPressed: onLogout,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutDialogButton extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color shadowColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _LogoutDialogButton({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.shadowColor,
    required this.onPressed,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: shadowColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              elevation: 0,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor ?? backgroundColor, width: 1.5),
              ),
              textStyle: AppTextStyles.button.copyWith(fontSize: 13, fontWeight: FontWeight.w800),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(label),
          ),
        ),
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
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h2.copyWith(color: color ?? onSurface)),
            Text(label, style: AppTextStyles.caption.copyWith(color: onSurface.withValues(alpha: 0.6))),
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
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Opacity(
      opacity: badge.locked ? 0.45 : 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(badge.icon, size: 28, color: AppColors.accentOrange),
              const SizedBox(height: AppSpacing.xs),
              Text(badge.title,
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: onSurface),
                  textAlign: TextAlign.center),
              Text(badge.earnedOn, style: AppTextStyles.caption.copyWith(color: onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({required this.icon, required this.title, this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(icon, size: 22, color: onSurface.withValues(alpha: 0.6)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: onSurface)),
                    if (subtitle != null)
                      Text(subtitle!, style: AppTextStyles.caption.copyWith(color: onSurface.withValues(alpha: 0.6))),
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
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LinkRow({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
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
                Icon(icon, size: 22, color: onSurface.withValues(alpha: 0.6)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                    child: Text(title,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: onSurface))),
                Icon(Icons.chevron_right_rounded, color: onSurface.withValues(alpha: 0.6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Row(
            children: [
              Icon(icon, size: 22, color: onSurface.withValues(alpha: 0.6)),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: onSurface)),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: onSurface.withValues(alpha: 0.6))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
