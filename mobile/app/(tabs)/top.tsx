import React, { useEffect, useState } from 'react';
import { ActivityIndicator, ScrollView, StyleSheet, Text, View } from 'react-native';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { color, font } from '../../src/theme';
import type { Period, Ranked } from '../../src/types';
import { Chip, Toggle } from '../../src/ui/controls';
import { Screen, Title } from '../../src/ui/primitives';
import { DemoBanner, Empty, RecipeCardView, Segmented } from '../../src/ui/social';

/**
 * Les plus copiées du jour, de la semaine, du mois. Toutes les cuisines par
 * défaut (pas seulement les miennes), avec un filtre par cuisine. Ce que je ne
 * mange pas est masqué, sauf si je demande à tout voir.
 */
export default function Top() {
  const { t, tn } = useI18n();
  const { api, cuisines, version } = useSession();
  const [period, setPeriod] = useState<Period>('week');
  const [cuisine, setCuisine] = useState<string | null>(null);
  const [respectDiet, setRespectDiet] = useState(true);
  const [rows, setRows] = useState<Ranked[] | null>(null);

  useEffect(() => {
    if (!api) return;
    let cancelled = false;
    setRows(null);
    api
      .trending(period, cuisine, respectDiet)
      .then((r) => !cancelled && setRows(r))
      .catch(() => !cancelled && setRows([]));
    return () => {
      cancelled = true;
    };
  }, [api, period, cuisine, respectDiet, version]);

  return (
    <Screen>
      <DemoBanner />
      <Title>{t('top.title')}</Title>
      <Text style={s.sub}>{t('top.sub')}</Text>

      <Segmented
        style={s.periods}
        value={period}
        onChange={setPeriod}
        options={[
          { value: 'day', label: t('top.period.day') },
          { value: 'week', label: t('top.period.week') },
          { value: 'month', label: t('top.period.month') },
        ]}
      />

      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={s.chips}>
        <Chip label={t('top.allCuisines')} selected={cuisine === null} onPress={() => setCuisine(null)} />
        {cuisines.map((c) => (
          <Chip key={c.slug} label={c.name} selected={cuisine === c.slug} onPress={() => setCuisine(c.slug)} />
        ))}
      </ScrollView>

      <View style={s.toggle}>
        <Text style={s.toggleLabel}>{t('top.respectDiet')}</Text>
        <Toggle label={t('top.respectDiet')} value={respectDiet} onPress={() => setRespectDiet((v) => !v)} />
      </View>

      {rows === null ? (
        <ActivityIndicator color={color.plum} style={{ marginTop: 20 }} />
      ) : rows.length === 0 ? (
        <Empty>{t('top.empty')}</Empty>
      ) : (
        rows.map((r) => (
          <RecipeCardView
            key={r.recipe.id}
            recipe={r.recipe}
            badge={
              <View style={s.badge}>
                <Text style={s.rank}>#{r.rank}</Text>
                <Text style={s.copies}>{tn('top.copies', r.period_copies)}</Text>
              </View>
            }
          />
        ))
      )}
    </Screen>
  );
}

const s = StyleSheet.create({
  sub: { fontFamily: font.regular, fontSize: 13.5, color: color.mutedWarm, marginTop: 4 },
  periods: { marginTop: 16 },
  chips: { gap: 8, paddingVertical: 14, paddingRight: 18 },
  toggle: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 },
  toggleLabel: { fontFamily: font.medium, fontSize: 14, color: color.ink, flex: 1 },
  badge: { flexDirection: 'row', alignItems: 'center', gap: 8, backgroundColor: 'rgba(31,20,16,0.7)', borderRadius: 10, paddingHorizontal: 10, paddingVertical: 5 },
  rank: { fontFamily: font.bold, fontSize: 15, color: '#fff' },
  copies: { fontFamily: font.medium, fontSize: 12, color: '#fff' },
});
