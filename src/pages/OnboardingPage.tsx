import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Pagination } from '@/components/ui/Pagination';
import { OnboardingLayout } from '@/layouts/OnboardingLayout';
import { ROUTES } from '@/constants/routes';

export default function OnboardingPage() {
  const navigate = useNavigate();

  return (
    <OnboardingLayout onSkip={() => navigate(ROUTES.login)}>
      <div className="flex flex-1 flex-col items-center justify-center gap-6 text-center">
        <div className="relative w-full rounded-lg bg-primary-50 p-8">
          <Badge label="Baru!" color="primary" />
          <p className="my-6 text-5xl text-primary-600">ꦤꦺꦴ</p>
          <span className="absolute bottom-4 right-4">
            <Badge label="🔥 7 hari" color="orange" />
          </span>
        </div>
        <div>
          <h1 className="text-h1">Belajar Aksara Jawa jadi menyenangkan</h1>
          <p className="mt-2 text-body text-ink-500">
            Mulai dari Nglegena, Sandhangan, hingga Pasangan dengan kartu, kuis, dan reward harian.
          </p>
        </div>
      </div>
      <div className="space-y-4 pt-4">
        <Pagination total={3} current={0} />
        <Button onClick={() => navigate(ROUTES.howItWorks)}>Lanjut</Button>
      </div>
    </OnboardingLayout>
  );
}
