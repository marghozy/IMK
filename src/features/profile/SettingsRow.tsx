import { ReactNode } from 'react';

interface SettingsRowProps {
  icon: string;
  label: string;
  value?: string;
  onClick?: () => void;
  trailing?: ReactNode;
}

export function SettingsRow({ icon, label, value, onClick, trailing }: SettingsRowProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="flex w-full items-center gap-3 rounded-md bg-white px-4 py-3.5 text-left shadow-card"
    >
      <span className="text-lg" aria-hidden>
        {icon}
      </span>
      <span className="flex-1">
        <span className="block text-body font-bold text-ink-900">{label}</span>
        {value && <span className="block text-caption text-ink-500">{value}</span>}
      </span>
      {trailing ?? <span className="text-ink-300">›</span>}
    </button>
  );
}
