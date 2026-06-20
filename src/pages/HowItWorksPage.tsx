import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Pagination } from '@/components/ui/Pagination';
import { OnboardingLayout } from '@/layouts/OnboardingLayout';
import { ROUTES } from '@/constants/routes';

const STEPS = [
  { step: 'LANGKAH 1', title: 'Pelajari Karakter', desc: 'Kartu interaktif untuk tiap aksara dengan audio.', icon: '📗', color: 'primary' as const },
  { step: 'LANGKAH 2', title: 'Latihan Menulis', desc: 'Telusuri urutan goresan langsung di layar.', icon: '✏️', color: 'blue' as const },
  { step: 'LANGKAH 3', title: 'Quiz & Reward', desc: 'Uji ingatanmu dan kumpulkan XP setiap hari.', icon: '⚡', color: 'orange' as const },
];

export default function HowItWorksPage() {
  const navigate = useNavigate();

  return (
    <OnboardingLayout onSkip={() => navigate(ROUTES.login)}>
      <div className="flex-1">
        <h1 className="text-h1">Cara belajar di JawaLingo</h1>
        <p className="mt-1 text-body text-ink-500">Tiga langkah sederhana untuk fasih membaca.</p>

        <div className="mt-6 space-y-3">
          {STEPS.map((s) => (
            <div key={s.title} className="flex items-start gap-3 rounded-md bg-white p-4 shadow-card">
              <span className="flex size-10 items-center justify-center rounded-md bg-surface-muted text-xl" aria-hidden>
                {s.icon}
              </span>
              <div>
                <Badge label={s.step} color={s.color} />
                <p className="mt-1 text-body font-bold text-ink-900">{s.title}</p>
                <p className="text-caption text-ink-500">{s.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
      <div className="space-y-4 pt-4">
        <Pagination total={3} current={1} />
        <Button onClick={() => navigate(ROUTES.chooseGoal)}>Lanjut</Button>
      </div>
    </OnboardingLayout>
  );
}
