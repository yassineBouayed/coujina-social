/**
 * Les notifications push, côté téléphone.
 *
 * On ne demande la permission qu'une fois, et seulement quand elle a un sens :
 * juste après la première recette enregistrée ou écrite — jamais au premier
 * lancement, où un « non » réflexe est définitif. Les règles d'envoi (trois
 * cas, une par jour, rien la nuit) sont côté serveur.
 */
import { useEffect } from 'react';
import { Platform } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Constants from 'expo-constants';
import * as Notifications from 'expo-notifications';
import { useRouter } from 'expo-router';

import type { Api } from './types';

const ASKED_KEY = 'coujina-social.pushAsked';

if (Platform.OS !== 'web') {
  Notifications.setNotificationHandler({
    handleNotification: async () => ({
      shouldShowBanner: true,
      shouldShowList: true,
      shouldPlaySound: false,
      shouldSetBadge: false,
    }),
  });
}

/** Demande la permission une fois, puis enregistre le jeton. Ne lève jamais. */
export async function askForPushOnce(api: Api): Promise<void> {
  if (Platform.OS === 'web' || !api.live) return;
  try {
    if (await AsyncStorage.getItem(ASKED_KEY)) return;
    await AsyncStorage.setItem(ASKED_KEY, '1');
    const { granted } = await Notifications.requestPermissionsAsync();
    if (!granted) return;
    const projectId = Constants.expoConfig?.extra?.eas?.projectId as string | undefined;
    const token = await Notifications.getExpoPushTokenAsync(projectId ? { projectId } : undefined);
    await api.registerPushToken(token.data, Platform.OS);
  } catch (e) {
    // Expo Go sans projet EAS, simulateur, refus : la notification n'est qu'un plus.
    if (__DEV__) console.warn('[push]', e);
  }
}

/** Une notification touchée ouvre l'écran qu'elle annonce. */
export function usePushRouting(): void {
  const router = useRouter();
  useEffect(() => {
    if (Platform.OS === 'web') return;
    const sub = Notifications.addNotificationResponseReceivedListener((response) => {
      const screen = response.notification.request.content.data?.screen;
      router.push(screen === 'challenge' ? '/challenge' : '/activity');
    });
    return () => sub.remove();
  }, [router]);
}
