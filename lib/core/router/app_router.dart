import 'package:go_router/go_router.dart';
import '../widgets/app_shell.dart';
import '../widgets/coming_soon_page.dart';
import '../../features/splash/view/splash_page.dart';
import '../../features/onboarding/view/onboarding_page.dart';
import '../../features/goal_selection/view/choose_goal_page.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/register_page.dart';
import '../../features/home/view/home_page.dart';
import '../../features/learn/view/learn_list_page.dart';
import '../../features/learn/view/lesson_card_page.dart';
import '../../features/learn/view/writing_practice_page.dart';
import '../../features/quiz/view/quiz_level_page.dart';
import '../../features/quiz/view/quiz_countdown_page.dart';
import '../../features/quiz/view/quiz_question_page.dart';
import '../../features/quiz/view/quiz_feedback_page.dart';
import '../../features/quiz/view/quiz_result_page.dart';
import '../../features/progress/view/progress_page.dart';
import '../../features/profile/view/profile_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),
    GoRoute(path: '/onboarding/pilih-tujuan', builder: (context, state) => const ChooseGoalPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    GoRoute(path: '/forgot-password', builder: (context, state) => const ComingSoonPage(title: 'Lupa Kata Sandi')),
    GoRoute(path: '/legal/terms', builder: (context, state) => const ComingSoonPage(title: 'Syarat & Ketentuan')),
    GoRoute(path: '/legal/privacy', builder: (context, state) => const ComingSoonPage(title: 'Kebijakan Privasi')),
    GoRoute(path: '/settings/language', builder: (context, state) => const ComingSoonPage(title: 'Bahasa')),
    GoRoute(path: '/settings/password', builder: (context, state) => const ComingSoonPage(title: 'Ubah Kata Sandi')),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/learn',
          builder: (context, state) => const LearnListPage(),
          routes: [
            GoRoute(
              path: ':moduleId',
              builder: (context, state) => LessonCardPage(moduleId: state.pathParameters['moduleId']!),
            ),
            GoRoute(
              path: ':moduleId/:cardId',
              builder: (context, state) => LessonCardPage(
                moduleId: state.pathParameters['moduleId']!,
                cardId: state.pathParameters['cardId'],
              ),
            ),
            GoRoute(
              path: ':moduleId/write/:cardId',
              builder: (context, state) => WritingPracticePage(
                moduleId: state.pathParameters['moduleId']!,
                cardId: state.pathParameters['cardId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/quiz',
          builder: (context, state) => const QuizLevelPage(),
          routes: [
            GoRoute(
              path: ':levelId/start',
              builder: (context, state) => QuizCountdownPage(levelId: state.pathParameters['levelId']!),
            ),
            GoRoute(
              path: ':levelId/question/:questionId',
              builder: (context, state) => QuizQuestionPage(
                levelId: state.pathParameters['levelId']!,
                questionId: state.pathParameters['questionId']!,
              ),
            ),
            GoRoute(
              path: ':levelId/question/:questionId/feedback',
              builder: (context, state) => QuizFeedbackPage(
                levelId: state.pathParameters['levelId']!,
                questionId: state.pathParameters['questionId']!,
              ),
            ),
            GoRoute(
              path: ':levelId/result',
              builder: (context, state) => QuizResultPage(levelId: state.pathParameters['levelId']!),
            ),
          ],
        ),
        GoRoute(path: '/progress', builder: (context, state) => const ProgressPage()),
        GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
      ],
    ),
  ],
);
