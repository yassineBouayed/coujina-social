import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../src/i18n';
import { useSession } from '../src/session';
import { errorText, useStore } from '../src/store';
import { color, font, radius } from '../src/theme';
import type { ModerationItem, OpsWeek } from '../src/types';
import { BackButton, PrimaryButton, SecondaryButton } from '../src/ui/controls';
import { Screen, SectionHeader, Title } from '../src/ui/primitives';
import { Empty } from '../src/ui/social';

/**
 * La file de modération (équipe seulement) : les signalements les plus anciens
 * d'abord, en rouge au-delà de 24 h. Masquer demande un motif, que l'auteur
 * lira sur sa recette. En tête, la ligne de la semaine de la feuille
 * d'opérations.
 */
export default function Moderation() {
  const router = useRouter();
  const { t } = useI18n();
  const { toast } = useStore();
  const { api, me } = useSession();
  const [items, setItems] = useState<ModerationItem[]>([]);
  const [week, setWeek] = useState<OpsWeek | null>(null);
  const [reasons, setReasons] = useState<Record<string, string>>({});

  const load = () => {
    if (!api) return;
    api.moderationQueue().then(setItems).catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
    api.opsWeekly().then((w) => setWeek(w[0] ?? null)).catch(() => setWeek(null));
  };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(load, [api]);

  if (!me?.is_moderator) return <Screen><BackButton onPress={() => router.back()} /><Empty>{t('recipe.notFound')}</Empty></Screen>;

  const act = (p: Promise<void>) => p.then(load).catch((e) => toast(errorText(e, t, t('common.wentWrong'))));

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{t('moderation.title')}</Title>
      {week ? (
        <Text style={s.ops}>
          {t('moderation.ops')} : {t('moderation.opsLine', {
            received: week.received, resolved: week.resolved, within: week.within_24h, open: week.still_open,
          })}
        </Text>
      ) : null}

      {items.length === 0 ? <Empty>{t('moderation.empty')}</Empty> : null}
      {items.map((it) => (
        <View key={it.report_id} style={s.card}>
          <SectionHeader label={t(`report.${it.reason}`)} hint={it.age_hours >= 24 ? t('moderation.late') : t('moderation.age', { count: it.age_hours })} tone={it.age_hours >= 24 ? color.ember : color.plum} />
          {it.recipe_title ? (
            <Text style={s.target} onPress={() => it.recipe_id && router.push(`/recipe/${it.recipe_id}`)}>
              {it.recipe_title} — @{it.recipe_author}
            </Text>
          ) : (
            <Text style={s.target}>@{it.profile_username}</Text>
          )}
          {it.details ? <Text style={s.details}>« {it.details} »</Text> : null}
          <Text style={s.by}>{t('moderation.reportedBy', { name: it.reporter_username })}</Text>
          {it.recipe_id ? (
            <TextInput
              value={reasons[it.report_id] ?? ''}
              onChangeText={(v) => setReasons((r) => ({ ...r, [it.report_id]: v }))}
              placeholder={t('moderation.reasonPlaceholder')}
              placeholderTextColor={color.muted}
              style={s.input}
            />
          ) : null}
          <View style={s.actions}>
            {it.recipe_id ? (
              <PrimaryButton
                label={t('moderation.hide')}
                disabled={!(reasons[it.report_id] ?? '').trim()}
                onPress={() => void act(api!.hideRecipe(it.recipe_id!, reasons[it.report_id] ?? ''))}
                style={s.btn}
              />
            ) : null}
            <SecondaryButton label={t('moderation.dismiss')} onPress={() => void act(api!.dismissReport(it.report_id))} style={s.btn} />
          </View>
        </View>
      ))}
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12 },
  ops: { fontFamily: font.medium, fontSize: 13, color: color.inkSoft, marginTop: 6, marginBottom: 16 },
  card: { padding: 14, borderRadius: radius.card, borderWidth: 1, borderColor: color.border, backgroundColor: color.surface, marginBottom: 12 },
  target: { fontFamily: font.semibold, fontSize: 15, color: color.ink },
  details: { fontFamily: font.regular, fontSize: 13.5, fontStyle: 'italic', color: color.inkSoft, marginTop: 4 },
  by: { fontFamily: font.regular, fontSize: 12, color: color.mutedWarm, marginTop: 4 },
  input: {
    marginTop: 10, borderWidth: 1, borderColor: color.border, borderRadius: radius.md, paddingHorizontal: 12, paddingVertical: 8,
    fontFamily: font.regular, fontSize: 14, color: color.ink,
  },
  actions: { flexDirection: 'row', gap: 8, marginTop: 10 },
  btn: { flex: 1 },
});
