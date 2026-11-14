/** Le toast global (repris de l'ancien projet, sans le reste du magasin). */
import React, { createContext, useCallback, useContext, useMemo, useRef, useState, type ReactNode } from 'react';

type Store = { state: { toast: string | null }; toast: (message: string) => void };

const StoreContext = createContext<Store | null>(null);

export function StoreProvider({ children }: { children: ReactNode }) {
  const [message, setMessage] = useState<string | null>(null);
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const toast = useCallback((next: string) => {
    if (timer.current) clearTimeout(timer.current);
    setMessage(next);
    timer.current = setTimeout(() => setMessage(null), 2600);
  }, []);

  const value = useMemo(() => ({ state: { toast: message }, toast }), [message, toast]);
  return <StoreContext.Provider value={value}>{children}</StoreContext.Provider>;
}

export function useStore(): Store {
  const s = useContext(StoreContext);
  if (!s) throw new Error('useStore must be used inside <StoreProvider>');
  return s;
}

/** Le message d'une erreur d'API, traduit quand on le connaît. */
export function errorText(e: unknown, t: (k: any) => string, fallback: string): string {
  const raw = e instanceof Error ? e.message : String(e ?? '');
  const key = `error.${raw}`;
  const translated = t(key);
  return translated !== key ? translated : raw || fallback;
}
