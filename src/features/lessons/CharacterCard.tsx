interface CharacterCardProps {
  aksara: string;
  formula?: string;
  size?: 'learn' | 'quiz';
}

export function CharacterCard({ aksara, formula, size = 'learn' }: CharacterCardProps) {
  const height = size === 'learn' ? 'h-[140px]' : 'h-[110px]';

  return (
    <div className={`flex flex-col items-center justify-center rounded-md bg-white shadow-card ${height}`}>
      {formula && <p className="mb-2 text-h2 text-ink-300">{formula}</p>}
      <p className="font-aksara text-5xl text-ink-900">{aksara}</p>
    </div>
  );
}
