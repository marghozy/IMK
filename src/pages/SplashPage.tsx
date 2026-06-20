import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { ROUTES } from '@/constants/routes';

export default function SplashPage() {
  const navigate = useNavigate();

  return (
    <div className="app-shell gradient-primary flex flex-col items-center justify-between px-6 py-10 text-center text-white">
      <div className="flex items-center gap-2 self-start rounded-full bg-white/90 px-3 py-1.5">
        <span className="text-base">𑆅</span>
        <span className="text-caption font-extrabold tracking-wide text-primary-700">JAWALINGO</span>
      </div>

      <div className="flex flex-1 flex-col items-center justify-center gap-6">
        <div className="flex size-32 items-center justify-center rounded-full bg-white/20 text-6xl">
          🙂
        </div>
        <div>
          <h1 className="text-display">
            Halo, <span className="text-accent-yellow">aku Caraka!</span>
          </h1>
          <p className="mt-2 text-body text-white/90">Ayo belajar Aksara Jawa bareng gratis &amp; menyenangkan!</p>
        </div>
      </div>

      <div className="w-full space-y-3">
        <Button variant="primary" className="bg-white text-primary-700" onClick={() => navigate(ROUTES.onboarding)}>
          Mulai — Aku Pemula
        </Button>
        <Button variant="outline" className="border-white bg-transparent text-white" onClick={() => navigate(ROUTES.login)}>
          Sudah Punya Akun
        </Button>
        <p className="text-caption text-white/70">Dengan melanjutkan, kamu setuju dengan Syarat &amp; Privasi</p>
      </div>
    </div>
  );
}
