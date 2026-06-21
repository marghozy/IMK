import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/shared/state/user_providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: JawaLingoApp()));
}

class JawaLingoApp extends ConsumerWidget {
  const JawaLingoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeEnabled = ref.watch(userProvider.select((u) => u.darkModeEnabled));
    return MaterialApp.router(
      title: 'JawaLingo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
