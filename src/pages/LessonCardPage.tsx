import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { AuthLayout } from '@/layouts/AuthLayout';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { Alert } from '@/components/ui/Alert';
import { ProgressBar } from '@/components/ui/ProgressBar';
import { CharacterCard } from '@/features/lessons/CharacterCard';
import { lessonService } from '@/services/lessonService';
import { lessonCardPath, ROUTES } from '@/constants/routes';
import type { LessonCard } from '@/types';

export default function LessonCardPage() {
  const { lessonId = '', cardIndex = '0' } = useParams();
  const navigate = useNavigate();
  const [cards, setCards] = useState<LessonCard[]>([]);

  useEffect(() => {
    lessonService.getLessonCards(lessonId).then(setCards);
  }, [lessonId]);

  const index = Number(cardIndex);
  const card = cards[0];
  if (!card) return null;

  const goNext = () => navigate(lessonCardPath(lessonId, index + 1));
  const goPrev = () => navigate(lessonCardPath(lessonId, Math.max(0, index - 1)));

  return (
    <AuthLayout showBack={false}>
      <button
        aria-label="Kembali"
        onClick={() => navigate(ROUTES.learn)}
        className="mb-3 flex size-9 items-center justify-center rounded-full bg-surface-muted text-ink-700"
      >
        ‹
      </button>

      <ProgressBar value={card.index} max={card.totalCards} />

      <div className="my-4 text-center">
        <Badge label={card.title} color="purple" />
      </div>

      <CharacterCard aksara={card.aksara} size="learn" />

      <div className="mt-4 text-center">
        <h2 className="text-h2">{card.title}</h2>
        <p className="mt-1 text-body text-ink-500">{card.description}</p>
      </div>

      {card.example && (
        <div className="mt-4 rounded-md bg-primary-50 p-3 text-center text-body text-primary-700">
          Contoh: {card.example}
        </div>
      )}

      <div className="mt-4 flex flex-wrap justify-center gap-2">
        {card.phoneme && <Badge label={`Fonem: ${card.phoneme}`} color="purple" />}
        {card.position && <Badge label={`Posisi: ${card.position}`} color="blue" />}
        <Badge label="Lanjutan" color="orange" />
      </div>

      {(card.warning || card.tip) && (
        <div className="mt-4">
          <Alert type={card.warning ? 'warning' : 'info'} message={card.warning ?? card.tip} />
        </div>
      )}

      <div className="mt-6 flex gap-3">
        <Button variant="outline" onClick={goPrev} disabled={index === 0}>
          ‹ Sebelumnya
        </Button>
        <Button onClick={goNext}>Selanjutnya ›</Button>
      </div>
    </AuthLayout>
  );
}
