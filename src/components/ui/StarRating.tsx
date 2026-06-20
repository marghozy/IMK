interface StarRatingProps {
  value: number;
  max?: number;
}

export function StarRating({ value, max = 3 }: StarRatingProps) {
  return (
    <span className="inline-flex gap-0.5" aria-label={`${value} dari ${max} bintang`}>
      {Array.from({ length: max }).map((_, i) => (
        <span key={i} className={i < value ? 'text-accent-yellow' : 'text-surface-border'}>
          ★
        </span>
      ))}
    </span>
  );
}
