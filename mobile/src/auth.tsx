/**
 * La connexion. Repris de l'ancien projet (Google, Apple, retour par lien
 * profond, PKCE) ; le lien magique cède la place à e-mail + mot de passe.
 *
 *   e-mail + mot de passe   signUp -> code à six chiffres -> session
 *   Google                  OAuth dans le navigateur système
 *   Apple (iOS)             obligatoire dès qu'on propose Google : règle 4.8
 *                           de l'App Store. Le bouton Google n'est montré sur
 *                           iOS que si Apple l'est aussi.
 *
 * Sans Supabase configuré, le MODE DÉMO : on « se connecte » en choisissant
 * une personne fictive, et ce choix est gardé sur le téléphone.
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';
import { Platform } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as AppleAuthentication from 'expo-apple-authentication';
import * as AuthSession from 'expo-auth-session';
import * as Linking from 'expo-linking';
import * as WebBrowser from 'expo-web-browser';
import type { Session } from '@supabase/supabase-js';

import { useI18n } from './i18n';
import { isSupabaseConfigured, supabase } from './supabase';

WebBrowser.maybeCompleteAuthSession();

const redirectTo = AuthSession.makeRedirectUri({ scheme: 'coujinasocial', path: 'auth-callback' });
if (__DEV__ && isSupabaseConfigured) console.log('[auth] redirectTo =', redirectTo);

const DEMO_KEY = 'coujina-social.demoUser';

export type Auth = {
  loading: boolean;
  userId: string | null;
  email: string | null;
  configured: boolean;
  appleAvailable: boolean;
  /** Adresse en attente du code de confirmation, après une inscription. */
  pendingConfirmation: string | null;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string) => Promise<void>;
  confirmSignUp: (code: string) => Promise<void>;
  clearPending: () => void;
  resetPassword: (email: string) => Promise<void>;
  signInWithGoogle: () => Promise<void>;
  signInWithApple: () => Promise<void>;
  signInDemo: (userId: string) => void;
  signOut: () => Promise<void>;
};

const AuthContext = createContext<Auth | null>(null);

function fail(error: unknown, fallback: string): never {
  const message =
    typeof error === 'object' && error !== null && 'message' in error
      ? String((error as { message: unknown }).message)
      : fallback;
  throw new Error(message || fallback);
}

const isCancellation = (error: unknown) => {
  const code = (error as { code?: string } | null)?.code;
  return code === 'ERR_REQUEST_CANCELED' || code === 'ERR_CANCELED';
};

export function AuthProvider({ children }: { children: ReactNode }) {
  const { t } = useI18n();
  const [loading, setLoading] = useState(true);
  const [session, setSession] = useState<Session | null>(null);
  const [demoUser, setDemoUser] = useState<string | null>(null);
  const [appleAvailable, setAppleAvailable] = useState(false);
  const [pending, setPending] = useState<string | null>(null);

  useEffect(() => {
    if (!supabase) {
      AsyncStorage.getItem(DEMO_KEY)
        .then((id) => setDemoUser(id))
        .catch(() => undefined)
        .finally(() => setLoading(false));
      return;
    }
    let cancelled = false;
    supabase.auth.getSession().then(({ data }) => {
      if (cancelled) return;
      setSession(data.session);
      setLoading(false);
    });
    const { data } = supabase.auth.onAuthStateChange((_event, next) => {
      setSession(next);
      setLoading(false);
      if (next) setPending(null);
    });
    return () => {
      cancelled = true;
      data.subscription.unsubscribe();
    };
  }, []);

  useEffect(() => {
    if (Platform.OS !== 'ios') return;
    AppleAuthentication.isAvailableAsync().then(setAppleAvailable).catch(() => setAppleAvailable(false));
  }, []);

  /** `coujinasocial://auth-callback?code=…` (PKCE) ou `#access_token=…`. */
  const consumeUrl = useCallback(async (url: string) => {
    if (!supabase || !url.includes('auth-callback')) return;
    const { queryParams } = Linking.parse(url);
    const code = typeof queryParams?.code === 'string' ? queryParams.code : null;
    if (code) {
      await supabase.auth.exchangeCodeForSession(code);
      return;
    }
    const params = new URLSearchParams(url.includes('#') ? url.slice(url.indexOf('#') + 1) : '');
    const access_token = params.get('access_token');
    const refresh_token = params.get('refresh_token');
    if (access_token && refresh_token) await supabase.auth.setSession({ access_token, refresh_token });
  }, []);

  useEffect(() => {
    if (!supabase) return;
    Linking.getInitialURL().then((url) => url && void consumeUrl(url));
    const sub = Linking.addEventListener('url', ({ url }) => void consumeUrl(url));
    return () => sub.remove();
  }, [consumeUrl]);

  const value = useMemo<Auth>(() => ({
    loading,
    userId: supabase ? session?.user?.id ?? null : demoUser,
    email: session?.user?.email ?? null,
    configured: isSupabaseConfigured,
    appleAvailable,
    pendingConfirmation: pending,

    signIn: async (email, password) => {
      if (!supabase) return;
      const { error } = await supabase.auth.signInWithPassword({ email: email.trim().toLowerCase(), password });
      if (error) fail(error, t('error.signIn'));
    },

    signUp: async (email, password) => {
      if (!supabase) return;
      const address = email.trim().toLowerCase();
      const { data, error } = await supabase.auth.signUp({
        email: address,
        password,
        options: { emailRedirectTo: redirectTo },
      });
      if (error) fail(error, t('error.signUp'));
      // Confirmation d'e-mail activée côté projet : pas de session tant que le code n'est pas tapé.
      if (!data.session) setPending(address);
    },

    confirmSignUp: async (code) => {
      if (!supabase || !pending) return;
      const { error } = await supabase.auth.verifyOtp({ email: pending, token: code.replace(/\D/g, ''), type: 'signup' });
      if (error) fail(error, t('error.code'));
    },

    clearPending: () => setPending(null),

    resetPassword: async (email) => {
      if (!supabase) return;
      const { error } = await supabase.auth.resetPasswordForEmail(email.trim().toLowerCase(), { redirectTo });
      if (error) fail(error, t('common.wentWrong'));
    },

    signInWithGoogle: async () => {
      if (!supabase) return;
      const { data, error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: { redirectTo, skipBrowserRedirect: true },
      });
      if (error || !data?.url) fail(error, t('error.googleSignIn'));
      const result = await WebBrowser.openAuthSessionAsync(data.url, redirectTo);
      if (result.type === 'success') await consumeUrl(result.url);
    },

    signInWithApple: async () => {
      if (!supabase) return;
      try {
        const credential = await AppleAuthentication.signInAsync({
          requestedScopes: [
            AppleAuthentication.AppleAuthenticationScope.FULL_NAME,
            AppleAuthentication.AppleAuthenticationScope.EMAIL,
          ],
        });
        if (!credential.identityToken) fail(null, t('error.appleToken'));
        const { error } = await supabase.auth.signInWithIdToken({ provider: 'apple', token: credential.identityToken });
        if (error) fail(error, t('error.appleSignIn'));
      } catch (error) {
        if (isCancellation(error)) return;
        fail(error, t('error.appleSignIn'));
      }
    },

    signInDemo: (id) => {
      setDemoUser(id);
      void AsyncStorage.setItem(DEMO_KEY, id).catch(() => undefined);
    },

    signOut: async () => {
      if (supabase) {
        await supabase.auth.signOut();
        return;
      }
      setDemoUser(null);
      await AsyncStorage.removeItem(DEMO_KEY).catch(() => undefined);
    },
  }), [loading, session, demoUser, appleAvailable, pending, consumeUrl, t]);

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): Auth {
  const auth = useContext(AuthContext);
  if (!auth) throw new Error('useAuth must be used inside <AuthProvider>');
  return auth;
}
