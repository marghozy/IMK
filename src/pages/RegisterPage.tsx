import { FormEvent, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Checkbox } from '@/components/ui/Checkbox';
import { AuthLayout } from '@/layouts/AuthLayout';
import { ROUTES } from '@/constants/routes';
import { authService } from '@/services/authService';

export default function RegisterPage() {
  const navigate = useNavigate();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [agreed, setAgreed] = useState(false);
  const [loading, setLoading] = useState(false);

  const canSubmit = agreed && name && email && password && password === confirmPassword;

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!canSubmit) return;
    setLoading(true);
    try {
      await authService.register({ name, email, password });
      navigate(ROUTES.home);
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout>
      <h1 className="text-h1">Buat Akun Baru</h1>
      <p className="mt-1 text-body text-ink-500">Mulai perjalananmu belajar Aksara Jawa.</p>

      <form onSubmit={handleSubmit} className="mt-6 space-y-4">
        <Input
          label="Nama Lengkap"
          leadingIcon="👤"
          placeholder="Thariq Habibi"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <Input
          label="Email"
          type="email"
          leadingIcon="📧"
          placeholder="thariq@example.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
        <Input
          label="Kata Sandi"
          type="password"
          leadingIcon="🔒"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
        <Input
          label="Konfirmasi"
          type="password"
          leadingIcon="🔒"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          required
        />

        <Checkbox
          checked={agreed}
          onChange={setAgreed}
          label={
            <>
              Saya setuju dengan <span className="font-bold text-primary-600">Syarat &amp; Ketentuan</span> serta{' '}
              <span className="font-bold text-primary-600">Kebijakan Privasi</span> JawaLingo.
            </>
          }
        />

        <Button type="submit" disabled={!canSubmit} loading={loading}>
          Daftar Sekarang
        </Button>
      </form>

      <p className="mt-4 text-center text-caption text-ink-500">
        Sudah punya akun?{' '}
        <button onClick={() => navigate(ROUTES.login)} className="font-bold text-primary-600">
          Masuk
        </button>
      </p>
    </AuthLayout>
  );
}
