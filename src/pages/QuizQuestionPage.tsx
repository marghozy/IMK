import { useNavigate, useParams } from 'react-router-dom';
import { Badge } from '@/components/ui/Badge';
import { ProgressBar } from '@/components/ui/ProgressBar';
import { CharacterCard } from '@/features/lessons/CharacterCard';
import { AnswerOption } from '@/features/quiz/AnswerOption';
import { useQuizSession } from '@/features/quiz/QuizSessionContext';
import { quizFeedbackPath } from '@/constants/routes';
import type { QuizLevelId } from '@/types';

export default function QuizQuestionPage() {
  const { levelId = 'pemula' } = useParams<{ levelId: QuizLevelId }>();
  const navigate = useNavigate();
  const { questions, currentIndex, lives, submitAnswer } = useQuizSession();

  const question = questions[currentIndex];
  if (!question) return null;

  const handleSelect = (option: string) => {
    const isCorrect = option === question.correctAnswer;
    submitAnswer({
      questionId: question.id,
      selectedAnswer: option,
      isCorrect,
      xpEarned: isCorrect ? 50 : 0,
    });

    const isLastQuestion = currentIndex >= questions.length - 1;
    navigate(quizFeedbackPath(levelId, question.id), {
      state: { selectedAnswer: option, isLastQuestion },
    });
  };

  return (
    <div className="app-shell px-5 py-5">
      <div className="flex items-center gap-3">
        <span className="flex size-10 items-center justify-center rounded-full border-4 border-primary-200 text-caption font-bold text-primary-700">
          0:45
        </span>
        <div className="flex-1">
          <p className="text-caption font-bold text-ink-500">
            Soal {currentIndex + 1} dari {questions.length}
          </p>
          <ProgressBar value={currentIndex + 1} max={questions.length} />
        </div>
        <Badge label={`❤️ ${lives}`} color="danger" />
      </div>

      <p className="mt-6 text-h2">Aksara ini dibaca apa?</p>

      <div className="mt-3">
        <CharacterCard aksara={question.aksara} size="quiz" />
      </div>

      <p className="mt-6 text-body font-bold text-ink-700">Pilih jawaban yang tepat</p>
      <div className="mt-3 space-y-3">
        {question.options.map((option) => (
          <AnswerOption key={option} label={option} onSelect={() => handleSelect(option)} />
        ))}
      </div>
    </div>
  );
}
