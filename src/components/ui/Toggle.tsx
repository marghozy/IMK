interface ToggleProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  label: string;
  description?: string;
}

export function Toggle({ checked, onChange, label, description }: ToggleProps) {
  return (
    <div className="flex items-center justify-between gap-3 rounded-md bg-white px-4 py-3.5 shadow-card">
      <div>
        <p className="text-body font-bold text-ink-900">{label}</p>
        {description && <p className="text-caption text-ink-500">{description}</p>}
      </div>
      <button
        type="button"
        role="switch"
        aria-checked={checked}
        aria-label={label}
        onClick={() => onChange(!checked)}
        className={[
          'relative h-7 w-12 shrink-0 rounded-full transition',
          checked ? 'bg-primary-500' : 'bg-surface-border',
        ].join(' ')}
      >
        <span
          className={[
            'absolute top-0.5 size-6 rounded-full bg-white shadow transition',
            checked ? 'left-5' : 'left-0.5',
          ].join(' ')}
        />
      </button>
    </div>
  );
}
