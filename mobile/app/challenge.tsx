import React, { useEffect, useState } from 'react';
import { ActivityIndicator, StyleSheet, Text } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../src/i18n';
import { useSession } from '../src/session';
import { color, font } from '../src/theme';
import type { Challenge, RecipeCard } from '../src/types';
import { BackButton, PrimaryButton } from '../src/ui/controls';
import { Eyebrow, Screen, Title } from '../src/ui/primitives';
import { Empty, RecipeTile, TileGrid } from '../src/ui/social';

/** Le défi de la semaine : son thème, ses participations, et y participer. */
export default function ChallengeScreen() {
  const router = useRouter();
  const { t, tn } = useI18n();
  const { api, version } = useSession();
  const [challenge, setChallenge] = useState<Challenge | null | undefined>(undefined);
  const [entries, setEntries] = useState<RecipeCard[]>([]);

  useEffect(() => {
    if (!api) return;
    api.challenge().then(setChallenge).catch(() => setChallenge(null));
    api.challengeEntries().then(setEntries).catch(() => setEntries([]));
  }, [api, version]);

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      {challenge === undefined ? (
        <ActivityIndicator color={color.plum} />
      ) : challenge === null ? (
        <Empty>{t('common.wentWrong')}</Empty>
      ) : (
        <>
          <Eyebrow style={s.eyebrow}>{t('challenge.eyebrow')}</Eyebrow>
          <Title>{challenge.title}</Title>
          <Text style={s.description}>{challenge.description}</Text>
          <PrimaryButton label={t('challenge.join')} onPress={() => router.push({ pathname: '/recipe/edit', params: { challenge: '1' } })} style={s.cta} />
          <Text style={s.count}>{tn('challenge.entries', entries.length)}</Text>
          {entries.length ? (
            <TileGrid>{entries.map((r) => <RecipeTile key={r.id} recipe={r} />)}</TileGrid>
          ) : (
            <Empty>{t('challenge.empty')}</Empty>
          )}
        </>
      )}
    </Screen>
  );
}

const s = StyleSheet.create({
  eyebrow: { marginTop: 14, marginBottom: 6 },
  description: { fontFamily: font.regular, fontSize: 14.5, lineHeight: 21, color: color.inkSoft, marginTop: 8 },
  cta: { marginTop: 18 },
  count: { fontFamily: font.semibold, fontSize: 13, color: color.inkFaint, marginTop: 24, marginBottom: 12 },
});
