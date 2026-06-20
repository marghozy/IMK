type AnswerState = 'default' | 'selected' | 'correct' | 'incorrect';

interface AnswerOptionProps {
  label: string;
  state?: AnswerState;
  onSelect?: () => void;
}

const STATE_CLASSES: Record<AnswerState, string> = {
  default: 'border-surface-border bg-white text-ink-900',
  selected: 'border-primary-400 bg-primary-50 text-primary-700',
  correct: 'border-primary-500 bg-primary-50 text-primary-700',
  incorrect: 'border-danger-300 bg-danger-50 text-danger-500',
};

export function AnswerOption({ label, state = 'default', onSelect }: AnswerOptionProps) {
  return (
    <button
      type="button"
      onClick={onSelect}
      className={`w-full rounded-md border-2 px-4 py-3 text-left text-body font-bold transition active:scale-[0.99] ${STATE_CLASSES[state]}`}
    >
      {label}
    </button>
  );
}
