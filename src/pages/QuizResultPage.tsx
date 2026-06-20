import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { useQuizSession } from '@/features/quiz/QuizSessionContext';
import { calcAccuracy, formatTime } from '@/utils/format';
import { ROUTES } from '@/constants/routes';

export default function QuizResultPage() {
  const navigate = useNavigate();
  const { answers, resetSession } = useQuizSession();

  const correctCount = answers.filter((a) => a.isCorrect).length;
  const totalCount = answers.length || 1;
  const accuracy = calcAccuracy(correctCount, totalCount);
  const xpEarned = answers.reduce((sum, a) => sum + a.xpEarned, 0);
  const wrongAnswers = answers
    .map((a, i) => ({ ...a, number: i + 1 }))
    .filter((a) => !a.isCorrect);

  const handleBack = () => {
    resetSession();
    navigate(ROUTES.home);
  };

  return (
    <div className="app-shell pb-8">
      <div className="gradient-primary px-6 py-8 text-center text-white">
        <p className="text-4xl">🏆</p>
        <h1 className="mt-2 text-h1">Bagus Sekali!</h1>
        <div className="mt-3 flex justify-center gap-2">
          <span className="rounded-full bg-white/20 px-3 py-1 text-caption font-bold">
            {correctCount}/{totalCount} Benar
          </span>
          <span className="rounded-full bg-white/20 px-3 py-1 text-caption font-bold">
            {formatTime(Math.round((Date.now() % 600000) / 1000))} Waktu
          </span>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-3 px-5 pt-5">
        <StatBox icon="🎯" value={`${accuracy}%`} label="AKURASI" />
        <StatBox icon="⚡" value={`+${xpEarned}`} label="XP DIDAPAT" />
        <StatBox icon="⏱" value="2:45" label="WAKTU TEMPUH" />
        <StatBox icon="🔥" value="7" label="STREAK AKTIF" />
      </div>

      {wrongAnswers.length > 0 && (
        <div className="mx-5 mt-4 rounded-md border border-danger-100 bg-danger-50 p-4">
          <p className="mb-2 text-body font-bold text-danger-500">❌ {wrongAnswers.length} Jawaban Salah</p>
          <div className="space-y-2">
            {wrongAnswers.map((wrong) => (
              <div key={wrong.questionId} className="rounded-sm bg-white p-3 text-caption">
                <span className="font-bold text-ink-900">Soal {wrong.number}: </span>
                <span className="text-ink-700">Jawaban "{wrong.selectedAnswer}" kurang tepat</span>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="mt-6 flex gap-3 px-5">
        <Button variant="outline" onClick={handleBack} icon="🏠">
          Kembali
        </Button>
        <Button icon="📖">Tinjau</Button>
      </div>
    </div>
  );
}

function StatBox({ icon, value, label }: { icon: string; value: string; label: string }) {
  return (
    <div className="rounded-md bg-white p-4 text-center shadow-card">
      <p className="text-xl">{icon}</p>
      <p className="text-h2 text-ink-900">{value}</p>
      <p className="text-caption text-ink-500">{label}</p>
    </div>
  );
}
