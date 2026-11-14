/**
 * La session : l'API du compte connecté (Supabase ou démo), son profil, ses
 * préférences, et les cuisines. Un seul endroit où l'on sait qui est « moi ».
 *
 * `version` augmente à chaque écriture qui change ce que les listes montrent
 * (copie, recette écrite, abonnement, préférences) : les onglets s'en servent
 * pour se recharger sans qu'on ait à tirer l'écran.
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';

import { createMockApi } from './api.mock';
import { createSupabaseApi } from './api.supabase';
import { useAuth } from './auth';
import { useI18n } from './i18n';
import { supabase } from './supabase';
import type { Api, Cuisine, Me } from './types';

export type SessionStore = {
  api: Api | null;
  me: Me | null;
  cuisines: Cuisine[];
  loading: boolean;
  error: string | null;
  version: number;
  bump: () => void;
  refreshMe: () => Promise<void>;
  cuisineName: (slug: string | null) => string;
};

const SessionContext = createContext<SessionStore | null>(null);

export function SessionProvider({ children }: { children: ReactNode }) {
  const { userId } = useAuth();
  const { lang } = useI18n();
  const [me, setMe] = useState<Me | null>(null);
  const [cuisines, setCuisines] = useState<Cuisine[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [version, setVersion] = useState(0);

  const api = useMemo<Api | null>(() => {
    if (!userId) return null;
    return supabase ? createSupabaseApi(supabase, userId, lang) : createMockApi(userId, lang);
    // Changer de langue recrée l'API démo : ses données sont perdues, c'est un prototype.
  }, [userId, lang]);

  const refreshMe = useCallback(async () => {
    if (!api) return;
    try {
      setError(null);
      setMe(await api.me());
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    }
  }, [api]);

  useEffect(() => {
    if (!api) {
      setMe(null);
      return;
    }
    let cancelled = false;
    setLoading(true);
    Promise.all([api.me(), api.cuisines()])
      .then(([m, c]) => {
        if (cancelled) return;
        setMe(m);
        setCuisines(c);
      })
      .catch((e) => !cancelled && setError(e instanceof Error ? e.message : String(e)))
      .finally(() => !cancelled && setLoading(false));
    return () => {
      cancelled = true;
    };
  }, [api]);

  const value = useMemo<SessionStore>(() => ({
    api, me, cuisines, loading, error, version,
    bump: () => setVersion((v) => v + 1),
    refreshMe,
    cuisineName: (slug) => cuisines.find((c) => c.slug === slug)?.name ?? slug ?? '',
  }), [api, me, cuisines, loading, error, version, refreshMe]);

  return <SessionContext.Provider value={value}>{children}</SessionContext.Provider>;
}

export function useSession(): SessionStore {
  const s = useContext(SessionContext);
  if (!s) throw new Error('useSession must be used inside <SessionProvider>');
  return s;
}

/** L'API, quand on sait déjà être connecté (tous les écrans derrière la porte). */
export function useApi(): Api {
  const { api } = useSession();
  if (!api) throw new Error('useApi called without a signed-in user');
  return api;
}
