interface AvatarProps {
  name: string;
  src?: string;
  size?: number;
  badge?: number;
}

export function Avatar({ name, src, size = 48, badge }: AvatarProps) {
  const initials = name
    .split(' ')
    .map((part) => part[0])
    .slice(0, 2)
    .join('')
    .toUpperCase();

  return (
    <span className="relative inline-flex shrink-0" style={{ width: size, height: size }}>
      {src ? (
        <img src={src} alt={name} className="size-full rounded-full object-cover" />
      ) : (
        <span
          className="flex size-full items-center justify-center rounded-full bg-white text-primary-700 font-bold"
          style={{ fontSize: size * 0.4 }}
        >
          {initials}
        </span>
      )}
      {badge !== undefined && (
        <span className="absolute -bottom-1 -right-1 flex size-5 items-center justify-center rounded-full bg-accent-orange text-[10px] font-bold text-white ring-2 ring-white">
          {badge}
        </span>
      )}
    </span>
  );
}
