import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { useQuizSession } from '@/features/quiz/QuizSessionContext';
import { quizQuestionPath, quizResultPath } from '@/constants/routes';
import type { QuizLevelId } from '@/types';

interface FeedbackLocationState {
  selectedAnswer: string;
  isLastQuestion?: boolean;
}

export default function QuizFeedbackPage() {
  const { levelId = 'pemula' } = useParams<{ levelId: QuizLevelId }>();
  const navigate = useNavigate();
  const location = useLocation();
  const { questions, currentIndex, lives, correctStreak, goToNextQuestion } = useQuizSession();

  const { selectedAnswer, isLastQuestion } = (location.state as FeedbackLocationState) ?? {
    selectedAnswer: '',
  };

  const question = questions[currentIndex];
  if (!question) return null;

  const isCorrect = selectedAnswer === question.correctAnswer;

  const handleContinue = () => {
    if (isLastQuestion) {
      navigate(quizResultPath(levelId), { replace: true });
      return;
    }
    goToNextQuestion();
    navigate(quizQuestionPath(levelId, questions[currentIndex + 1].id), { replace: true });
  };

  return (
    <div className="app-shell px-5 py-5">
      <div className={`rounded-lg p-6 text-center text-white ${isCorrect ? 'gradient-primary' : 'gradient-danger'}`}>
        <div className="mx-auto mb-3 flex size-14 items-center justify-center rounded-full bg-white/20 text-2xl">
          {isCorrect ? '✓' : '✕'}
        </div>
        <h1 className="text-h1">{isCorrect ? 'Benar!' : 'Belum Tepat'}</h1>
        <p className="text-caption text-white/90">
          {isCorrect ? '' : 'Jangan menyerah, coba lagi!'}
        </p>
      </div>

      {isCorrect ? (
        <div className="mx-auto -mt-4 mb-4 w-fit rounded-md border-2 border-primary-200 bg-white px-6 py-3 text-center shadow-card">
          <p className="text-h1 text-primary-600">+50</p>
          <p className="text-caption text-ink-500">XP</p>
        </div>
      ) : (
        <div className="mt-4 flex gap-3">
          <div className="flex-1 rounded-md bg-white p-3 text-center shadow-card">
            <p className="text-caption text-ink-500">JAWABANMU</p>
            <p className="text-h2 text-danger-500">{selectedAnswer}</p>
          </div>
          <div className="flex-1 rounded-md bg-white p-3 text-center shadow-card">
            <p className="text-caption text-ink-500">JAWABAN BENAR</p>
            <p className="text-h2 text-primary-600">{question.correctAnswer}</p>
          </div>
        </div>
      )}

      <div className="mt-4 rounded-md bg-white p-4 shadow-card">
        <p className="mb-2 text-caption font-bold text-ink-500">💡 PENJELASAN</p>
        <p className="text-body text-ink-700">{question.explanation}</p>
      </div>

      <div className="mt-4">
        {isCorrect ? (
          correctStreak > 1 && <Badge label={`🔥 Benar ${correctStreak} Kali Berturut-turut!`} color="orange" />
        ) : (
          <Badge label={`❤️ Sisa nyawa: ${lives} dari 3`} color="danger" />
        )}
      </div>

      <div className="mt-6 space-y-3">
        <Button variant={isCorrect ? 'primary' : 'danger'} onClick={handleContinue}>
          {isCorrect ? 'Lanjut ke Soal Berikutnya' : 'Coba Lagi'}
        </Button>
        {!isCorrect && (
          <Button variant="outline" onClick={handleContinue}>
            Lewati Soal
          </Button>
        )}
      </div>
    </div>
  );
}
