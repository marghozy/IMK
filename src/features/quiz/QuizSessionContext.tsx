import { createContext, ReactNode, useContext, useReducer } from 'react';
import { QUIZ_CONFIG } from '@/constants/quizConfig';
import type { QuizAnswerResult, QuizLevelId, QuizQuestion } from '@/types';

interface QuizSessionState {
  levelId: QuizLevelId | null;
  questions: QuizQuestion[];
  currentIndex: number;
  lives: number;
  answers: QuizAnswerResult[];
  correctStreak: number;
  startedAt: number | null;
}

type QuizSessionAction =
  | { type: 'START'; levelId: QuizLevelId; questions: QuizQuestion[] }
  | { type: 'ANSWER'; result: QuizAnswerResult }
  | { type: 'NEXT' }
  | { type: 'RESET' };

const initialState: QuizSessionState = {
  levelId: null,
  questions: [],
  currentIndex: 0,
  lives: QUIZ_CONFIG.defaultLives,
  answers: [],
  correctStreak: 0,
  startedAt: null,
};

function reducer(state: QuizSessionState, action: QuizSessionAction): QuizSessionState {
  switch (action.type) {
    case 'START':
      return {
        ...initialState,
        levelId: action.levelId,
        questions: action.questions,
        startedAt: Date.now(),
      };
    case 'ANSWER':
      return {
        ...state,
        answers: [...state.answers, action.result],
        lives: action.result.isCorrect ? state.lives : Math.max(0, state.lives - 1),
        correctStreak: action.result.isCorrect ? state.correctStreak + 1 : 0,
      };
    case 'NEXT':
      return { ...state, currentIndex: state.currentIndex + 1 };
    case 'RESET':
      return initialState;
    default:
      return state;
  }
}

interface QuizSessionContextValue extends QuizSessionState {
  startSession: (levelId: QuizLevelId, questions: QuizQuestion[]) => void;
  submitAnswer: (result: QuizAnswerResult) => void;
  goToNextQuestion: () => void;
  resetSession: () => void;
}

const QuizSessionContext = createContext<QuizSessionContextValue | undefined>(undefined);

export function QuizSessionProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(reducer, initialState);

  const value: QuizSessionContextValue = {
    ...state,
    startSession: (levelId, questions) => dispatch({ type: 'START', levelId, questions }),
    submitAnswer: (result) => dispatch({ type: 'ANSWER', result }),
    goToNextQuestion: () => dispatch({ type: 'NEXT' }),
    resetSession: () => dispatch({ type: 'RESET' }),
  };

  return <QuizSessionContext.Provider value={value}>{children}</QuizSessionContext.Provider>;
}

export function useQuizSession() {
  const ctx = useContext(QuizSessionContext);
  if (!ctx) throw new Error('useQuizSession must be used within QuizSessionProvider');
  return ctx;
}
