import { useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Badge } from '@/components/ui/Badge';
import { useTimer } from '@/hooks/useTimer';
import { useQuizSession } from '@/features/quiz/QuizSessionContext';
import { quizService } from '@/services/quizService';
import { quizQuestionPath } from '@/constants/routes';
import { QUIZ_CONFIG } from '@/constants/quizConfig';
import type { QuizLevelId } from '@/types';

export default function QuizCountdownPage() {
  const { levelId = 'pemula' } = useParams<{ levelId: QuizLevelId }>();
  const navigate = useNavigate();
  const { startSession } = useQuizSession();
  const { secondsLeft } = useTimer(3);

  useEffect(() => {
    if (secondsLeft === 0) {
      quizService.getQuestions(levelId as QuizLevelId).then((questions) => {
        startSession(levelId as QuizLevelId, questions);
        navigate(quizQuestionPath(levelId, questions[0].id), { replace: true });
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [secondsLeft]);

  return (
    <div className="app-shell gradient-primary flex flex-col items-center justify-center px-6 py-10 text-center text-white">
      <p className="text-label uppercase tracking-widest text-white/80">Tantangan Waktu</p>
      <div className="my-8 flex size-32 items-center justify-center rounded-full bg-white">
        <span className="text-h1 text-primary-600">{secondsLeft || '🚀'}</span>
      </div>
      <h1 className="text-h1">Bersiap...</h1>
      <p className="mt-2 text-body text-white/90">
        Kamu punya {QUIZ_CONFIG.timedChallengeDurationSeconds} detik untuk menjawab{' '}
        {QUIZ_CONFIG.timedChallengeQuestionCount} soal. Tetap fokus!
      </p>
      <div className="mt-8 flex gap-2">
        <Badge label={`⏱ ${QUIZ_CONFIG.timedChallengeDurationSeconds}s`} color="neutral" />
        <Badge label={`❤️ ${QUIZ_CONFIG.defaultLives} nyawa`} color="danger" />
        <Badge label="⚡ 2x XP" color="orange" />
      </div>
    </div>
  );
}
