import { ReactNode } from 'react';

interface OnboardingLayoutProps {
  children: ReactNode;
  onSkip?: () => void;
}

export function OnboardingLayout({ children, onSkip }: OnboardingLayoutProps) {
  return (
    <div className="app-shell flex flex-col px-6 py-5">
      <div className="flex justify-end">
        {onSkip && (
          <button onClick={onSkip} className="text-caption font-bold text-ink-500">
            Lewati
          </button>
        )}
      </div>
      <div className="flex flex-1 flex-col">{children}</div>
    </div>
  );
}
