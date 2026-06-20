import { Routes, Route } from 'react-router-dom';
import { QuizSessionProvider } from '@/features/quiz/QuizSessionContext';
import SplashPage from '@/pages/SplashPage';
import OnboardingPage from '@/pages/OnboardingPage';
import HowItWorksPage from '@/pages/HowItWorksPage';
import ChooseGoalPage from '@/pages/ChooseGoalPage';
import LoginPage from '@/pages/LoginPage';
import RegisterPage from '@/pages/RegisterPage';
import ForgotPasswordPage from '@/pages/ForgotPasswordPage';
import HomePage from '@/pages/HomePage';
import LearnListPage from '@/pages/LearnListPage';
import LessonCardPage from '@/pages/LessonCardPage';
import QuizLevelPage from '@/pages/QuizLevelPage';
import QuizCountdownPage from '@/pages/QuizCountdownPage';
import QuizQuestionPage from '@/pages/QuizQuestionPage';
import QuizFeedbackPage from '@/pages/QuizFeedbackPage';
import QuizResultPage from '@/pages/QuizResultPage';
import ProgressPage from '@/pages/ProgressPage';
import ProfilePage from '@/pages/ProfilePage';
import { ROUTES } from '@/constants/routes';

export function AppRoutes() {
  return (
    <Routes>
      <Route path={ROUTES.splash} element={<SplashPage />} />
      <Route path={ROUTES.onboarding} element={<OnboardingPage />} />
      <Route path={ROUTES.howItWorks} element={<HowItWorksPage />} />
      <Route path={ROUTES.chooseGoal} element={<ChooseGoalPage />} />
      <Route path={ROUTES.login} element={<LoginPage />} />
      <Route path={ROUTES.register} element={<RegisterPage />} />
      <Route path={ROUTES.forgotPassword} element={<ForgotPasswordPage />} />

      <Route path={ROUTES.home} element={<HomePage />} />
      <Route path={ROUTES.learn} element={<LearnListPage />} />
      <Route path={ROUTES.lessonCard} element={<LessonCardPage />} />
      <Route path={ROUTES.progress} element={<ProgressPage />} />
      <Route path={ROUTES.profile} element={<ProfilePage />} />

      <Route
        path="/quiz/*"
        element={
          <QuizSessionProvider>
            <Routes>
              <Route path="" element={<QuizLevelPage />} />
              <Route path=":levelId/start" element={<QuizCountdownPage />} />
              <Route path=":levelId/question/:questionId" element={<QuizQuestionPage />} />
              <Route path=":levelId/question/:questionId/feedback" element={<QuizFeedbackPage />} />
              <Route path=":levelId/result" element={<QuizResultPage />} />
            </Routes>
          </QuizSessionProvider>
        }
      />
    </Routes>
  );
}
