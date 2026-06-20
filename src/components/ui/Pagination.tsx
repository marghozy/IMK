interface PaginationProps {
  total: number;
  current: number;
}

export function Pagination({ total, current }: PaginationProps) {
  return (
    <div className="flex items-center justify-center gap-2" role="tablist" aria-label="Pagination">
      {Array.from({ length: total }).map((_, i) => (
        <span
          key={i}
          className={[
            'h-2 rounded-full transition-all',
            i === current ? 'w-6 bg-primary-500' : 'w-2 bg-surface-border',
          ].join(' ')}
        />
      ))}
    </div>
  );
}
