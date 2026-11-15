import React, { useCallback, useEffect, useRef, useState } from 'react';
import { ActivityIndicator, FlatList, RefreshControl, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { color, font } from '../../src/theme';
import type { FeedKind, RecipeCard } from '../../src/types';
import { ChallengeBanner, PriceSurveyCard, WhoToFollow } from '../../src/ui/coldstart';
import { DemoBanner, Empty, RecipeCardView, Segmented } from '../../src/ui/social';

/** L'accueil : les recettes et vidéos choisies pour mes cuisines, sans mes interdits. */
export default function Home() {
  const { t } = useI18n();
  const insets = useSafeAreaInsets();
  const { api, me, version } = useSession();
  const [kind, setKind] = useState<FeedKind>('all');
  const [items, setItems] = useState<RecipeCard[]>([]);
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const loadingRef = useRef(false);

  const load = useCallback(
    async (reset: boolean) => {
      if (!api || loadingRef.current) return;
      loadingRef.current = true;
      setLoading(true);
      setError(null);
      try {
        const offset = reset ? 0 : items.length;
        const page = await api.feed(offset, kind);
        setItems((prev) => {
          const base = reset ? [] : prev;
          const seen = new Set(base.map((r) => r.id));
          return [...base, ...page.filter((r) => !seen.has(r.id))];
        });
        setDone(page.length < 20);
      } catch (e) {
        setError(e instanceof Error ? e.message : String(e));
      } finally {
        loadingRef.current = false;
        setLoading(false);
        setRefreshing(false);
      }
    },
    [api, kind, items.length],
  );

  // Recharger quand le filtre change, ou quand une écriture ailleurs a changé ce qui se montre.
  useEffect(() => {
    void load(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [api, kind, version]);

  return (
    <FlatList
      style={s.list}
      contentContainerStyle={[s.content, { paddingTop: insets.top + 14 }]}
      data={items}
      keyExtractor={(r) => r.id}
      renderItem={({ item }) => <RecipeCardView recipe={item} />}
      onEndReachedThreshold={0.6}
      onEndReached={() => !done && !loading && void load(false)}
      refreshControl={
        <RefreshControl
          refreshing={refreshing}
          tintColor={color.plum}
          onRefresh={() => {
            setRefreshing(true);
            void load(true);
          }}
        />
      }
      ListHeaderComponent={
        <View>
          <DemoBanner />
          <Text style={s.title}>{t('home.hello', { name: me?.display_name?.split(' ')[0] || me?.username || '' })}</Text>
          <Text style={s.sub}>{t('home.sub')}</Text>
          <View style={s.blocks}>
            <PriceSurveyCard />
            <ChallengeBanner />
            <WhoToFollow />
          </View>
          <Segmented
            style={s.filter}
            value={kind}
            onChange={setKind}
            options={[
              { value: 'all', label: t('home.filter.all') },
              { value: 'photo', label: t('home.filter.photo') },
              { value: 'video', label: t('home.filter.video') },
            ]}
          />
          {error ? <Text style={s.error} onPress={() => void load(true)}>{error} — {t('common.retry')}</Text> : null}
        </View>
      }
      ListEmptyComponent={loading ? null : <Empty>{t('home.empty')}</Empty>}
      ListFooterComponent={
        loading ? <ActivityIndicator color={color.plum} style={s.footer} /> : items.length && done ? <Empty>{t('home.end')}</Empty> : null
      }
    />
  );
}

const s = StyleSheet.create({
  list: { flex: 1, backgroundColor: color.screen },
  content: { paddingHorizontal: 18, paddingBottom: 30 },
  title: { fontFamily: font.display, fontSize: 27, lineHeight: 30, letterSpacing: -0.5, color: color.ink },
  sub: { fontFamily: font.regular, fontSize: 13.5, lineHeight: 19, color: color.mutedWarm, marginTop: 4 },
  blocks: { marginTop: 16 },
  filter: { marginBottom: 16 },
  error: { fontFamily: font.medium, fontSize: 13, color: color.ember, marginBottom: 12 },
  footer: { marginVertical: 20 },
});
