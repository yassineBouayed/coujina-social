import React, { useEffect } from 'react';
import { ActivityIndicator, View } from 'react-native';
import { Stack, useRouter, useSegments } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useFonts } from 'expo-font';
import {
  FamiljenGrotesk_400Regular,
  FamiljenGrotesk_500Medium,
  FamiljenGrotesk_600SemiBold,
  FamiljenGrotesk_700Bold,
} from '@expo-google-fonts/familjen-grotesk';
import { BricolageGrotesque_700Bold } from '@expo-google-fonts/bricolage-grotesque';

import { AuthProvider, useAuth } from '../src/auth';
import { usePushRouting } from '../src/push';
import { I18nProvider } from '../src/i18n';
import { SessionProvider, useSession } from '../src/session';
import { StoreProvider } from '../src/store';
import { color } from '../src/theme';
import { TERMS_VERSION } from '../src/types';
import { Toast } from '../src/ui/Toast';

/**
 * Les deux portes : être connecté, puis avoir répondu aux deux questions du
 * premier lancement (cuisines, puis ce que l'on ne mange pas). Tant que l'une
 * n'est pas franchie, on y est ramené.
 */
function Gate() {
  const { loading: authLoading, userId } = useAuth();
  usePushRouting();
  const { me, loading } = useSession();
  const segments = useSegments();
  const router = useRouter();

  const inSignIn = segments[0] === 'sign-in';
  const inOnboarding = segments[0] === 'onboarding';
  const inTerms = inOnboarding && (segments as string[])[1] === 'terms';
  const inLegal = segments[0] === 'legal';

  useEffect(() => {
    if (authLoading) return;
    if (!userId) {
      if (!inSignIn) router.replace('/sign-in');
      return;
    }
    if (loading || !me) return;
    // Les CGU d'abord, et à nouveau quand elles changent ; leurs textes restent lisibles.
    if (me.terms_version !== TERMS_VERSION) {
      if (!inTerms && !inLegal) router.replace('/onboarding/terms');
      return;
    }
    if (!me.onboarded) {
      if (!inOnboarding) router.replace('/onboarding/cuisines');
      return;
    }
    if (inSignIn) router.replace('/');
  }, [authLoading, userId, loading, me, inSignIn, inOnboarding, inTerms, inLegal, router]);

  if (authLoading) {
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: color.screen }}>
        <ActivityIndicator color={color.plum} />
      </View>
    );
  }

  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: color.screen } }}>
      <Stack.Screen name="(tabs)" />
      <Stack.Screen name="sign-in" />
      <Stack.Screen name="onboarding/terms" />
      <Stack.Screen name="onboarding/cuisines" />
      <Stack.Screen name="onboarding/diet" />
      <Stack.Screen name="recipe/[id]" />
      <Stack.Screen name="recipe/edit" options={{ presentation: 'modal' }} />
      <Stack.Screen name="user/[id]" />
      <Stack.Screen name="country/[slug]" />
      <Stack.Screen name="profile-edit" options={{ presentation: 'modal' }} />
      <Stack.Screen name="search" />
      <Stack.Screen name="challenge" />
      <Stack.Screen name="activity" />
      <Stack.Screen name="u/[username]" />
      <Stack.Screen name="legal/[doc]" />
      <Stack.Screen name="family/index" />
      <Stack.Screen name="family/[id]" />
      <Stack.Screen name="moderation" />
    </Stack>
  );
}

export default function RootLayout() {
  const [fontsLoaded] = useFonts({
    FamiljenGrotesk_400Regular,
    FamiljenGrotesk_500Medium,
    FamiljenGrotesk_600SemiBold,
    FamiljenGrotesk_700Bold,
    BricolageGrotesque_700Bold,
  });
  if (!fontsLoaded) return null;

  return (
    <SafeAreaProvider>
      <I18nProvider>
        <StoreProvider>
          <AuthProvider>
            <SessionProvider>
              <StatusBar style="dark" />
              <Gate />
              <Toast />
            </SessionProvider>
          </AuthProvider>
        </StoreProvider>
      </I18nProvider>
    </SafeAreaProvider>
  );
}
