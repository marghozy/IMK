export interface User {
  id: string;
  name: string;
  email: string;
  avatarUrl?: string;
  level: number;
  xpTotal: number;
  streakDays: number;
  membership: 'MEMBER' | 'FREE';
}

export interface Lesson {
  id: string;
  title: string;
  category: string;
  description: string;
  icon: string;
  accentColor: 'primary' | 'blue' | 'purple' | 'cream';
  totalCharacters: number;
  progress: number;
  xpReward: number;
  locked: boolean;
}

export interface LessonCard {
  id: string;
  lessonId: string;
  index: number;
  totalCards: number;
  aksara: string;
  formula?: string;
  title: string;
  description: string;
  example?: string;
  phoneme?: string;
  position?: string;
  tip?: string;
  warning?: string;
}

export type QuizLevelId = 'pemula' | 'menengah' | 'tantangan-waktu' | 'master';

export interface QuizLevel {
  id: QuizLevelId;
  title: string;
  description: string;
  icon: string;
  bestScore?: string;
  starRating: number;
  locked: boolean;
}

export interface QuizQuestion {
  id: string;
  aksara: string;
  correctAnswer: string;
  options: string[];
  explanation: string;
}

export interface QuizAnswerResult {
  questionId: string;
  selectedAnswer: string;
  isCorrect: boolean;
  xpEarned: number;
}

export interface QuizSessionResult {
  levelId: QuizLevelId;
  correctCount: number;
  totalCount: number;
  accuracy: number;
  xpEarned: number;
  timeSpentSeconds: number;
  streak: number;
  wrongAnswers: { questionNumber: number; explanation: string }[];
}

export interface Achievement {
  id: string;
  title: string;
  icon: string;
  dateLabel?: string;
  locked: boolean;
}

export interface DailyAccuracy {
  day: string;
  accuracy: number;
}
