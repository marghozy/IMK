import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Pagination } from '@/components/ui/Pagination';
import { OnboardingLayout } from '@/layouts/OnboardingLayout';
import { ROUTES } from '@/constants/routes';

const GOALS = [
  { id: 'santai', title: 'Santai', desc: '5 menit / hari', xp: 50 },
  { id: 'reguler', title: 'Reguler', desc: '10 menit / hari', xp: 100 },
  { id: 'serius', title: 'Serius', desc: '20 menit / hari', xp: 200 },
  { id: 'intensif', title: 'Intensif', desc: '30 menit / hari', xp: 300 },
];

export default function ChooseGoalPage() {
  const navigate = useNavigate();
  const [selected, setSelected] = useState('reguler');

  return (
    <OnboardingLayout>
      <div className="flex-1">
        <h1 className="text-h1">Pilih tujuan harianmu</h1>
        <p className="mt-1 text-body text-ink-500">Kami akan menyesuaikan rekomendasi pelajaran.</p>

        <div className="mt-6 space-y-3">
          {GOALS.map((goal) => {
            const isSelected = goal.id === selected;
            return (
              <button
                key={goal.id}
                onClick={() => setSelected(goal.id)}
                className={`flex w-full items-center gap-3 rounded-md border-2 p-4 text-left transition ${
                  isSelected ? 'border-primary-500 bg-primary-50' : 'border-surface-border bg-white'
                }`}
              >
                <span
                  className={`flex size-6 shrink-0 items-center justify-center rounded-full border-2 ${
                    isSelected ? 'border-primary-500 bg-primary-500 text-white' : 'border-surface-border'
                  }`}
                >
                  {isSelected && '✓'}
                </span>
                <span className="flex-1">
                  <span className="block text-body font-bold text-ink-900">{goal.title}</span>
                  <span className="block text-caption text-ink-500">{goal.desc}</span>
                </span>
                <Badge label={`${goal.xp} XP`} color="orange" />
              </button>
            );
          })}
        </div>
      </div>
      <div className="space-y-4 pt-4">
        <Pagination total={3} current={2} />
        <Button onClick={() => navigate(ROUTES.register)}>Mulai Belajar</Button>
      </div>
    </OnboardingLayout>
  );
}
