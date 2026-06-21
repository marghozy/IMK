import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const _tabs = [
    (path: '/home', icon: Icons.home_rounded, label: 'Home'),
    (path: '/learn', icon: Icons.menu_book_rounded, label: 'Belajar'),
    (path: '/quiz', icon: Icons.bolt_rounded, label: 'Quiz'),
    (path: '/progress', icon: Icons.bar_chart_rounded, label: 'Progress'),
    (path: '/profile', icon: Icons.person_rounded, label: 'Profil'),
  ];

  int _currentIndex(String location) {
    final i = _tabs.indexWhere((t) => location.startsWith(t.path));
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (i) {
              final tab = _tabs[i];
              final active = i == currentIndex;
              final color = active ? AppColors.primary : AppColors.inkMuted;
              return InkWell(
                onTap: () => context.go(tab.path),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tab.icon, color: color, size: 24),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
