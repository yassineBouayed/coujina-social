import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, ScrollView, StyleSheet, Text, useWindowDimensions, View } from 'react-native';
import { useRouter } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { color, font, radius } from '../../src/theme';
import type { Country, RecipeCard } from '../../src/types';
import { Chip, PrimaryButton } from '../../src/ui/controls';
import { Globe, rotationFor, type GlobeRotation } from '../../src/ui/Globe';
import { DemoBanner, RecipeTile, TileGrid } from '../../src/ui/social';

/** Le Tour du monde : la Terre, une épingle par pays, et ses recettes en dessous. */
export default function Explore() {
  const { t, tn } = useI18n();
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const { width } = useWindowDimensions();
  const { api, version } = useSession();
  const [countries, setCountries] = useState<Country[] | null>(null);
  const [selected, setSelected] = useState<string | null>(null);
  const [rotation, setRotation] = useState<GlobeRotation>([-10, -25]);
  const [preview, setPreview] = useState<RecipeCard[]>([]);

  useEffect(() => {
    if (!api) return;
    api.globe().then(setCountries).catch(() => setCountries([]));
  }, [api, version]);

  const country = useMemo(() => countries?.find((c) => c.slug === selected) ?? null, [countries, selected]);

  const pick = useCallback(
    (slug: string) => {
      setSelected(slug);
      const c = countries?.find((x) => x.slug === slug);
      if (c) setRotation(rotationFor(c));
    },
    [countries],
  );

  useEffect(() => {
    if (!api || !selected) return;
    let cancelled = false;
    api.countryRecipes(selected).then((list) => !cancelled && setPreview(list.slice(0, 4))).catch(() => setPreview([]));
    return () => {
      cancelled = true;
    };
  }, [api, selected]);

  const size = Math.min(width - 36, 420);
  const withRecipes = (countries ?? []).filter((c) => c.recipe_count > 0);

  return (
    <ScrollView style={s.screen} contentContainerStyle={[s.content, { paddingTop: insets.top + 14 }]} showsVerticalScrollIndicator={false}>
      <DemoBanner />
      <Text style={s.title}>{t('explore.title')}</Text>
      <Text style={s.sub}>{t('explore.sub')}</Text>

      <View style={s.globe}>
        {countries ? (
          <Globe size={size} countries={countries} selected={selected} onSelect={pick} rotation={rotation} onRotate={setRotation} />
        ) : (
          <ActivityIndicator color={color.plum} style={{ height: size }} />
        )}
      </View>

      <Text style={s.label}>{t('explore.jump')}</Text>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={s.jump}>
        {withRecipes.map((c) => (
          <Chip key={c.slug} label={`${c.flag} ${c.name}`} selected={c.slug === selected} onPress={() => pick(c.slug)} />
        ))}
      </ScrollView>

      {country ? (
        <View style={s.panel}>
          <Text style={s.country}>{country.flag} {country.name}</Text>
          <Text style={s.count}>{tn('explore.count', country.recipe_count)}</Text>
          <TileGrid>
            {preview.map((r) => (
              <RecipeTile key={r.id} recipe={r} />
            ))}
          </TileGrid>
          <PrimaryButton label={t('explore.see')} onPress={() => router.push(`/country/${country.slug}`)} />
        </View>
      ) : (
        <Text style={s.hint}>{t('explore.pick')}</Text>
      )}
    </ScrollView>
  );
}

const s = StyleSheet.create({
  screen: { flex: 1, backgroundColor: color.screen },
  content: { paddingHorizontal: 18, paddingBottom: 30 },
  title: { fontFamily: font.display, fontSize: 27, lineHeight: 30, letterSpacing: -0.5, color: color.ink },
  sub: { fontFamily: font.regular, fontSize: 13.5, color: color.mutedWarm, marginTop: 4 },
  globe: { alignItems: 'center', marginVertical: 14 },
  label: { fontFamily: font.semibold, fontSize: 11, letterSpacing: 1.4, textTransform: 'uppercase', color: color.plum, marginBottom: 8 },
  jump: { gap: 8, paddingRight: 18 },
  panel: { marginTop: 18, padding: 14, borderRadius: radius.card, backgroundColor: color.surface, borderWidth: 1, borderColor: color.border },
  country: { fontFamily: font.semibold, fontSize: 19, color: color.ink },
  count: { fontFamily: font.regular, fontSize: 13, color: color.mutedWarm, marginTop: 2, marginBottom: 12 },
  hint: { fontFamily: font.regular, fontSize: 13.5, color: color.mutedWarm, textAlign: 'center', marginTop: 22 },
});
