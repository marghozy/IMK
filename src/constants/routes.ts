export const ROUTES = {
  splash: '/',
  onboarding: '/onboarding',
  howItWorks: '/onboarding/cara-belajar',
  chooseGoal: '/onboarding/pilih-tujuan',
  login: '/login',
  register: '/register',
  forgotPassword: '/forgot-password',
  home: '/home',
  learn: '/learn',
  lessonCard: '/learn/:lessonId/:cardIndex',
  quizLevels: '/quiz',
  quizCountdown: '/quiz/:levelId/start',
  quizQuestion: '/quiz/:levelId/question/:questionId',
  quizFeedback: '/quiz/:levelId/question/:questionId/feedback',
  quizResult: '/quiz/:levelId/result',
  progress: '/progress',
  profile: '/profile',
} as const;

export const lessonCardPath = (lessonId: string, cardIndex: number) =>
  `/learn/${lessonId}/${cardIndex}`;

export const quizCountdownPath = (levelId: string) => `/quiz/${levelId}/start`;

export const quizQuestionPath = (levelId: string, questionId: string) =>
  `/quiz/${levelId}/question/${questionId}`;

export const quizFeedbackPath = (levelId: string, questionId: string) =>
  `/quiz/${levelId}/question/${questionId}/feedback`;

export const quizResultPath = (levelId: string) => `/quiz/${levelId}/result`;
