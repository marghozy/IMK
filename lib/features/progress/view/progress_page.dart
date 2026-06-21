import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/section_label.dart';
import '../../../data/models/progress_data.dart';
import '../../shared/state/user_providers.dart';
import '../state/progress_state.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  late DateTime _focusedMonth;
  static const _dayLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final snapshot = ref.watch(progressProvider).valueOrNull ?? ProgressSnapshot.empty();
    final accuracyData = last7DaysAccuracy(snapshot);
    final activeDays = activeDaysInMonth(snapshot, _focusedMonth);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const Icon(Icons.bar_chart_rounded), const SizedBox(width: AppSpacing.sm), Text('Progress', style: AppTextStyles.h1)]),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
              ),
              child: Column(
                children: [
                  Text('${user.totalXp}', style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 40)),
                  Text('Total XP', style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.6,
              children: [
                _StatCard(icon: Icons.local_fire_department_rounded, color: AppColors.accentOrange, value: '${user.streakDays}', label: 'STREAK AKTIF'),
                _StatCard(icon: Icons.gps_fixed_rounded, color: AppColors.primary, value: '${(overallAccuracy(snapshot) * 100).round()}%', label: 'AKURASI'),
                _StatCard(icon: Icons.menu_book_rounded, color: AppColors.accentBlue, value: '${totalLessonsCompleted(snapshot)}', label: 'PELAJARAN'),
                _StatCard(icon: Icons.bolt_rounded, color: AppColors.accentYellow, value: '${totalQuizzesCompleted(snapshot)}', label: 'QUIZ SELESAI'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionLabel(icon: Icons.show_chart_rounded, text: 'AKURASI 7 HARI'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i < 0 || i >= accuracyData.length) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(_dayLabels[accuracyData[i].date.weekday - 1], style: AppTextStyles.caption),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(accuracyData.length, (i) {
                        final entry = accuracyData[i];
                        return BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                            toY: entry.accuracy * 100,
                            color: AppColors.accentBlue,
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ]);
                      }),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionLabel(icon: Icons.calendar_month_rounded, text: 'KALENDER ${_monthLabel(_focusedMonth).toUpperCase()}'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  focusedDay: _focusedMonth,
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: AppTextStyles.caption, weekendStyle: AppTextStyles.caption),
                  calendarFormat: CalendarFormat.month,
                  onPageChanged: (focused) => setState(() => _focusedMonth = focused),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) => _dayCell(day, activeDays),
                    todayBuilder: (context, day, focusedDay) => _dayCell(day, activeDays, isToday: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthLabel(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  Widget _dayCell(DateTime day, Set<int> activeDays, {bool isToday = false}) {
    final active = activeDays.contains(day.day);
    final color = isToday ? AppColors.primaryDark : (active ? AppColors.primary.withValues(alpha: 0.18) : Colors.transparent);
    final textColor = isToday ? Colors.white : AppColors.ink;
    return Center(
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: active && !isToday ? Border.all(color: AppColors.primary) : null,
        ),
        alignment: Alignment.center,
        child: Text('${day.day}', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            Text(value, style: AppTextStyles.h2),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
