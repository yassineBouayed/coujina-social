import React, { useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, RefreshControl, StyleSheet, Text } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { color, font } from '../../src/theme';
import type { RecipeCard } from '../../src/types';
import { PrimaryButton } from '../../src/ui/controls';
import { Screen, Title } from '../../src/ui/primitives';
import { DemoBanner, Empty, RecipeTile, Segmented, TileGrid } from '../../src/ui/social';

type Filter = 'all' | 'created' | 'copied';

/**
 * Mes recettes : celles que j'ai écrites, et celles que j'ai enregistrées
 * (copiées telles quelles ou modifiées). Le coin de chaque vignette dit qui
 * peut la voir.
 */
export default function Mine() {
  const { t } = useI18n();
  const router = useRouter();
  const { api, me, version } = useSession();
  const [items, setItems] = useState<RecipeCard[] | null>(null);
  const [filter, setFilter] = useState<Filter>('all');
  const [refreshing, setRefreshing] = useState(false);

  const load = () => {
    if (!api || !me) return Promise.resolve();
    return api.userRecipes(me.id).then(setItems).catch(() => setItems([]));
  };

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [api, me?.id, version]);

  const shown = useMemo(
    () =>
      (items ?? []).filter((r) =>
        filter === 'all' ? true : filter === 'created' ? r.copied_from === null && !r.credit : r.copied_from !== null || !!r.credit,
      ),
    [items, filter],
  );

  return (
    <Screen
      refreshControl={
        <RefreshControl refreshing={refreshing} tintColor={color.plum} onRefresh={() => {
          setRefreshing(true);
          void load().finally(() => setRefreshing(false));
        }} />
      }>
      <DemoBanner />
      <Title>{t('mine.title')}</Title>
      <Text style={s.sub}>{t('mine.sub')}</Text>
      <PrimaryButton label={t('mine.new')} onPress={() => router.push('/recipe/edit')} style={s.cta} />
      <Segmented
        style={s.filter}
        value={filter}
        onChange={setFilter}
        options={[
          { value: 'all', label: t('mine.filter.all') },
          { value: 'created', label: t('mine.filter.created') },
          { value: 'copied', label: t('mine.filter.copied') },
        ]}
      />
      {items === null ? (
        <ActivityIndicator color={color.plum} />
      ) : shown.length === 0 ? (
        <Empty>{t('mine.empty')}</Empty>
      ) : (
        <TileGrid>
          {shown.map((r) => (
            <RecipeTile key={r.id} recipe={r} corner={t(`visibility.${r.visibility}`)} />
          ))}
        </TileGrid>
      )}
    </Screen>
  );
}

const s = StyleSheet.create({
  sub: { fontFamily: font.regular, fontSize: 13.5, lineHeight: 19, color: color.mutedWarm, marginTop: 4 },
  cta: { marginTop: 16 },
  filter: { marginTop: 16, marginBottom: 16 },
});
