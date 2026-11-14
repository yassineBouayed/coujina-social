/**
 * Le client Supabase — repris de l'ancien projet.
 *
 * EXPO_PUBLIC_SUPABASE_URL et EXPO_PUBLIC_SUPABASE_ANON_KEY (voir .env.example)
 * sont publiques par construction : la clé anonyme n'ouvre rien seule, tout est
 * derrière la RLS de supabase/migrations. Sans elles, `supabase` vaut null et
 * l'application tourne en MODE DÉMO sur les données fictives.
 */
import AsyncStorage from '@react-native-async-storage/async-storage';
import { AppState, Platform } from 'react-native';
import { createClient, type SupabaseClient } from '@supabase/supabase-js';

const url = process.env.EXPO_PUBLIC_SUPABASE_URL ?? '';
const anonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY ?? '';

export const isSupabaseConfigured = url.length > 0 && anonKey.length > 0;

export const supabase: SupabaseClient | null = isSupabaseConfigured
  ? createClient(url, anonKey, {
      auth: {
        storage: AsyncStorage,
        autoRefreshToken: true,
        persistSession: true,
        detectSessionInUrl: false,
        flowType: 'pkce',
      },
    })
  : null;

// Rafraîchir les jetons seulement au premier plan (recommandation Supabase).
if (supabase && Platform.OS !== 'web') {
  AppState.addEventListener('change', (next) => {
    if (next === 'active') supabase.auth.startAutoRefresh();
    else supabase.auth.stopAutoRefresh();
  });
}
