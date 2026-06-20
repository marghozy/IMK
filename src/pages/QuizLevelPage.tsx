import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppLayout } from '@/layouts/AppLayout';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { Card } from '@/components/ui/Card';
import { LevelCard } from '@/features/quiz/LevelCard';
import { quizService } from '@/services/quizService';
import { quizCountdownPath } from '@/constants/routes';
import { QUIZ_CONFIG } from '@/constants/quizConfig';
import type { QuizLevel } from '@/types';

export default function QuizLevelPage() {
  const navigate = useNavigate();
  const [levels, setLevels] = useState<QuizLevel[]>([]);

  useEffect(() => {
    quizService.getLevels().then(setLevels);
  }, []);

  return (
    <AppLayout>
      <div className="flex items-center justify-between px-5 pt-5">
        <h1 className="text-h1">⚡ Quiz</h1>
        <Badge label="🔥 7" color="orange" />
      </div>

      <div className="px-5 pt-4">
        <Card className="flex items-center gap-3">
          <span className="flex size-12 items-center justify-center rounded-md bg-primary-50 text-xl">🎯</span>
          <div className="flex-1">
            <p className="text-caption font-bold uppercase text-primary-600">Quiz Harian</p>
            <p className="text-body font-bold text-ink-900">
              {QUIZ_CONFIG.dailyQuizQuestionCount} soal · +{QUIZ_CONFIG.dailyQuizBonusXp} XP bonus
            </p>
          </div>
          <Button fullWidth={false} onClick={() => navigate(quizCountdownPath('pemula'))}>
            Mulai
          </Button>
        </Card>
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">📦 Pilih Level</h2>
        <div className="space-y-3">
          {levels.map((level) => (
            <LevelCard key={level.id} level={level} onClick={() => navigate(quizCountdownPath(level.id))} />
          ))}
        </div>
      </div>
    </AppLayout>
  );
}
