import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Pressable, StyleSheet, Text, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../src/i18n';
import { useSession } from '../src/session';
import { color, font } from '../src/theme';
import type { Activity } from '../src/types';
import { BackButton } from '../src/ui/controls';
import { Screen, Title } from '../src/ui/primitives';
import { Avatar, Empty } from '../src/ui/social';

/** Ce qui m'est arrivé : nouveaux abonnés, recettes enregistrées ou refaites. */
export default function ActivityScreen() {
  const router = useRouter();
  const { t, locale } = useI18n();
  const { api, bump } = useSession();
  const [items, setItems] = useState<Activity[] | null>(null);

  useEffect(() => {
    if (!api) return;
    api.activity().then((list) => {
      setItems(list);
      // Vu : le compteur du profil retombe à zéro.
      void api.markActivitySeen().then(bump);
    }).catch(() => setItems([]));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [api]);

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{t('activity.title')}</Title>
      {items === null ? (
        <ActivityIndicator color={color.plum} />
      ) : items.length === 0 ? (
        <Empty>{t('activity.empty')}</Empty>
      ) : (
        items.map((a, i) => {
          const name = a.actor.display_name || `@${a.actor.username}`;
          const text = a.kind === 'follow'
            ? t('activity.follow', { name })
            : t(`activity.${a.kind}`, { name, recipe: a.recipe_title ?? '' });
          return (
            <Pressable
              key={`${a.kind}-${a.actor.id}-${a.at}-${i}`}
              accessibilityRole="button"
              onPress={() => router.push(a.recipe_id ? `/recipe/${a.recipe_id}` : `/user/${a.actor.id}`)}
              style={[s.row, a.is_new && s.rowNew]}>
              <Avatar person={a.actor} size={40} />
              <View style={{ flex: 1 }}>
                <Text style={s.text}>{text}</Text>
                <Text style={s.date}>{new Date(a.at).toLocaleDateString(locale, { day: 'numeric', month: 'long' })}</Text>
              </View>
              {a.is_new ? <View style={s.dot} /> : null}
            </Pressable>
          );
        })
      )}
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12, marginBottom: 12 },
  row: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 12, paddingHorizontal: 8, borderBottomWidth: 1, borderBottomColor: color.hairline },
  rowNew: { backgroundColor: color.emberTint, borderRadius: 10 },
  text: { fontFamily: font.regular, fontSize: 14, lineHeight: 19, color: color.ink },
  date: { fontFamily: font.regular, fontSize: 11.5, color: color.mutedWarm, marginTop: 2 },
  dot: { width: 8, height: 8, borderRadius: 4, backgroundColor: color.ember },
});
