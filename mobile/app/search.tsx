import React, { useEffect, useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../src/i18n';
import { useSession } from '../src/session';
import { color, font } from '../src/theme';
import type { Person } from '../src/types';
import { BackButton, TextField } from '../src/ui/controls';
import { Screen, Title } from '../src/ui/primitives';
import { Avatar } from '../src/ui/social';

/** Trouver quelqu'un à suivre, par son nom ou son nom d'utilisateur. */
export default function Search() {
  const router = useRouter();
  const { t } = useI18n();
  const { api, me } = useSession();
  const [query, setQuery] = useState('');
  const [people, setPeople] = useState<Person[]>([]);

  useEffect(() => {
    if (!api) return;
    const timer = setTimeout(() => {
      api.searchProfiles(query).then((list) => setPeople(list.filter((p) => p.id !== me?.id))).catch(() => setPeople([]));
    }, 250);
    return () => clearTimeout(timer);
  }, [api, query, me?.id]);

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{t('profile.search')}</Title>
      <TextField value={query} onChangeText={setQuery} placeholder="@" autoCapitalize="none" style={s.field} />
      {people.map((p) => (
        <Pressable key={p.id} accessibilityRole="button" onPress={() => router.push(`/user/${p.id}`)} style={s.row}>
          <Avatar person={p} />
          <View>
            <Text style={s.name}>{p.display_name || p.username}</Text>
            <Text style={s.user}>@{p.username}{p.is_editorial ? ` · ${t('profile.editorial')}` : ''}</Text>
          </View>
        </Pressable>
      ))}
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12 },
  field: { marginTop: 16, marginBottom: 10 },
  row: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 10, borderBottomWidth: 1, borderBottomColor: color.hairline },
  name: { fontFamily: font.semibold, fontSize: 15, color: color.ink },
  user: { fontFamily: font.regular, fontSize: 12.5, color: color.mutedWarm },
});
