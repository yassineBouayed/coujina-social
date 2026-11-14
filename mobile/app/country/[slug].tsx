import React, { useEffect, useState } from 'react';
import { ActivityIndicator, StyleSheet, Text } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { color, font } from '../../src/theme';
import type { Country, RecipeCard } from '../../src/types';
import { BackButton } from '../../src/ui/controls';
import { Screen, Title } from '../../src/ui/primitives';
import { Empty, RecipeTile, TileGrid } from '../../src/ui/social';

/** Les recettes d'un pays, depuis une épingle du globe. */
export default function CountryScreen() {
  const { slug } = useLocalSearchParams<{ slug: string }>();
  const router = useRouter();
  const { t, tn } = useI18n();
  const { api } = useSession();
  const [country, setCountry] = useState<Country | null>(null);
  const [recipes, setRecipes] = useState<RecipeCard[] | null>(null);

  useEffect(() => {
    if (!api || !slug) return;
    api.globe().then((all) => setCountry(all.find((c) => c.slug === slug) ?? null)).catch(() => undefined);
    api.countryRecipes(slug).then(setRecipes).catch(() => setRecipes([]));
  }, [api, slug]);

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{country ? `${country.flag} ${country.name}` : ''}</Title>
      {recipes ? <Text style={s.sub}>{tn('explore.count', recipes.length)}</Text> : null}
      {recipes === null ? (
        <ActivityIndicator color={color.plum} />
      ) : recipes.length === 0 ? (
        <Empty>{t('country.empty')}</Empty>
      ) : (
        <TileGrid>{recipes.map((r) => <RecipeTile key={r.id} recipe={r} />)}</TileGrid>
      )}
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12 },
  sub: { fontFamily: font.regular, fontSize: 13, color: color.mutedWarm, marginTop: 4, marginBottom: 16 },
});
