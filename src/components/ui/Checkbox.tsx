import { ReactNode } from 'react';

interface CheckboxProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  label: ReactNode;
}

export function Checkbox({ checked, onChange, label }: CheckboxProps) {
  return (
    <label className="flex cursor-pointer items-start gap-2.5">
      <input
        type="checkbox"
        checked={checked}
        onChange={(e) => onChange(e.target.checked)}
        className="sr-only"
      />
      <span
        className={[
          'mt-0.5 flex size-5 shrink-0 items-center justify-center rounded-[6px] border-2 transition',
          checked ? 'border-primary-500 bg-primary-500 text-white' : 'border-surface-border bg-white',
        ].join(' ')}
        aria-hidden
      >
        {checked && '✓'}
      </span>
      <span className="text-caption text-ink-700">{label}</span>
    </label>
  );
}
