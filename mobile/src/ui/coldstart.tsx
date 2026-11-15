/**
 * Ce que l'accueil montre au-dessus du fil, pour un réseau encore jeune :
 * la question du prix (une fois), le défi de la semaine, et des cuisiniers
 * à suivre. Chaque bloc disparaît quand il n'a rien à dire.
 */
import React, { useEffect, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../i18n';
import { useSession } from '../session';
import { useStore } from '../store';
import { color, font, radius } from '../theme';
import type { Challenge, PriceAnswer, Suggestion } from '../types';
import { Avatar } from './social';

const price = (cents: number, locale: string) =>
  (cents / 100).toLocaleString(locale, { style: 'currency', currency: 'EUR' });

/** La question du prix : posée une fois, au prix fixé pour cette personne. */
export function PriceSurveyCard() {
  const { t, locale } = useI18n();
  const { toast } = useStore();
  const { api, version } = useSession();
  const [due, setDue] = useState<{ due: boolean; price_cents: number } | null>(null);
  const [wants, setWants] = useState('');

  useEffect(() => {
    api?.priceSurvey().then(setDue).catch(() => setDue(null));
  }, [api, version]);

  if (!api || !due?.due) return null;

  const answer = (a: PriceAnswer) => {
    void api.answerPriceSurvey(a, wants.trim()).then(() => {
      setDue({ ...due, due: false });
      toast(t('survey.thanks'));
    });
  };

  return (
    <View style={s.survey}>
      <Text style={s.eyebrow}>{t('survey.title')}</Text>
      <Text style={s.question}>{t('survey.question', { price: price(due.price_cents, locale) })}</Text>
      <TextInput
        value={wants}
        onChangeText={setWants}
        placeholder={t('survey.wants')}
        placeholderTextColor={color.muted}
        maxLength={500}
        style={s.wants}
      />
      <View style={s.answers}>
        {(['yes', 'maybe', 'no'] as const).map((a) => (
          <Pressable key={a} accessibilityRole="button" onPress={() => answer(a)} style={({ pressed }) => [s.answer, pressed && { opacity: 0.7 }]}>
            <Text style={s.answerText}>{t(`survey.${a}`)}</Text>
          </Pressable>
        ))}
      </View>
    </View>
  );
}

/** Le défi de la semaine, et le nombre de participations. */
export function ChallengeBanner() {
  const { t, tn } = useI18n();
  const router = useRouter();
  const { api, version } = useSession();
  const [challenge, setChallenge] = useState<Challenge | null>(null);
  const [count, setCount] = useState(0);

  useEffect(() => {
    if (!api) return;
    api.challenge().then(setChallenge).catch(() => setChallenge(null));
    api.challengeEntries().then((r) => setCount(r.length)).catch(() => setCount(0));
  }, [api, version]);

  if (!challenge) return null;
  return (
    <Pressable accessibilityRole="button" onPress={() => router.push('/challenge')} style={({ pressed }) => [s.challenge, pressed && { opacity: 0.85 }]}>
      <Text style={s.challengeEyebrow}>{t('challenge.eyebrow')}</Text>
      <Text style={s.challengeTitle}>{challenge.title}</Text>
      <Text style={s.challengeText} numberOfLines={2}>{challenge.description}</Text>
      <Text style={s.challengeCount}>{tn('challenge.entries', count)}  ·  {t('challenge.join')} →</Text>
    </Pressable>
  );
}

/** Des cuisiniers qui aiment les mêmes cuisines, à suivre d'un geste. */
export function WhoToFollow() {
  const { t, tn } = useI18n();
  const router = useRouter();
  const { api, bump, version } = useSession();
  const [people, setPeople] = useState<Suggestion[]>([]);

  useEffect(() => {
    api?.whoToFollow().then(setPeople).catch(() => setPeople([]));
  }, [api, version]);

  if (!api || !people.length) return null;
  return (
    <View style={s.follow}>
      <Text style={s.eyebrow}>{t('follow.title')}</Text>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={s.followRow}>
        {people.map((p) => (
          <View key={p.id} style={s.person}>
            <Pressable accessibilityRole="button" onPress={() => router.push(`/user/${p.id}`)} style={s.personTop}>
              <Avatar person={p} size={48} />
              <Text style={s.personName} numberOfLines={1}>{p.display_name || p.username}</Text>
              <Text style={s.personMeta} numberOfLines={1}>
                {p.shared_cuisines ? tn('follow.shared', p.shared_cuisines) : tn('follow.recipes', p.public_recipes)}
              </Text>
            </Pressable>
            <Pressable
              accessibilityRole="button"
              onPress={() => {
                setPeople((all) => all.filter((x) => x.id !== p.id));
                void api.follow(p.id).then(bump);
              }}
              style={({ pressed }) => [s.followBtn, pressed && { opacity: 0.7 }]}>
              <Text style={s.followText}>{t('profile.follow')}</Text>
            </Pressable>
          </View>
        ))}
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  eyebrow: { fontFamily: font.semibold, fontSize: 11, letterSpacing: 1.4, textTransform: 'uppercase', color: color.plum, marginBottom: 8 },
  survey: { padding: 14, borderRadius: radius.card, backgroundColor: color.emberTint, borderWidth: 1, borderColor: color.emberBorder, marginBottom: 16 },
  question: { fontFamily: font.medium, fontSize: 14.5, lineHeight: 20, color: color.ink },
  wants: {
    marginTop: 10, borderWidth: 1, borderColor: color.emberBorder, borderRadius: radius.md, backgroundColor: color.surface,
    paddingHorizontal: 12, paddingVertical: 8, fontFamily: font.regular, fontSize: 14, color: color.ink,
  },
  answers: { flexDirection: 'row', gap: 8, marginTop: 10 },
  answer: { flex: 1, paddingVertical: 9, borderRadius: radius.pill, backgroundColor: color.surface, alignItems: 'center', borderWidth: 1, borderColor: color.emberBorder },
  answerText: { fontFamily: font.semibold, fontSize: 13.5, color: color.emberInk },
  challenge: { padding: 16, borderRadius: radius.card, backgroundColor: color.plum, marginBottom: 16 },
  challengeEyebrow: { fontFamily: font.semibold, fontSize: 11, letterSpacing: 1.4, textTransform: 'uppercase', color: '#F3D9E6' },
  challengeTitle: { fontFamily: font.display, fontSize: 21, lineHeight: 25, color: '#fff', marginTop: 6 },
  challengeText: { fontFamily: font.regular, fontSize: 13.5, lineHeight: 19, color: '#F7E8EF', marginTop: 4 },
  challengeCount: { fontFamily: font.semibold, fontSize: 12.5, color: '#fff', marginTop: 10 },
  follow: { marginBottom: 16 },
  followRow: { gap: 10, paddingRight: 18 },
  person: { width: 130, padding: 12, borderRadius: radius.lg, backgroundColor: color.surface, borderWidth: 1, borderColor: color.border, alignItems: 'center' },
  personTop: { alignItems: 'center', width: '100%' },
  personName: { fontFamily: font.semibold, fontSize: 13.5, color: color.ink, marginTop: 8 },
  personMeta: { fontFamily: font.regular, fontSize: 11.5, color: color.mutedWarm, marginTop: 2 },
  followBtn: { marginTop: 10, paddingVertical: 6, paddingHorizontal: 16, borderRadius: radius.pill, backgroundColor: color.plum },
  followText: { fontFamily: font.semibold, fontSize: 12.5, color: '#fff' },
});
