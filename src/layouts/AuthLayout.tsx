import { ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';

interface AuthLayoutProps {
  children: ReactNode;
  showBack?: boolean;
}

export function AuthLayout({ children, showBack = true }: AuthLayoutProps) {
  const navigate = useNavigate();

  return (
    <div className="app-shell px-6 py-5">
      {showBack && (
        <button
          aria-label="Kembali"
          onClick={() => navigate(-1)}
          className="mb-4 flex size-9 items-center justify-center rounded-full bg-surface-muted text-ink-700"
        >
          ‹
        </button>
      )}
      {children}
    </div>
  );
}
