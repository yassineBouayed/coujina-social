import React, { useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font } from '../../src/theme';
import { DIET_PRESETS, FLAGS, type Flag } from '../../src/types';
import { BackButton, Chip, PrimaryButton, SecondaryButton } from '../../src/ui/controls';
import { Note, Screen } from '../../src/ui/primitives';

/**
 * Premier lancement, étape 2 sur 2 : ce que l'on ne mange pas. Les deux
 * réponses partent ensemble, en un seul appel (profile_onboard) : entre deux
 * écritures, l'accueil montrerait des plats interdits.
 */
export default function OnboardingDiet() {
  const { t } = useI18n();
  const router = useRouter();
  const { toast } = useStore();
  const { cuisines, edit } = useLocalSearchParams<{ cuisines?: string; edit?: string }>();
  const { api, me, refreshMe, bump } = useSession();
  const [rules, setRules] = useState<Flag[]>(me?.exclusions ?? []);
  const [saving, setSaving] = useState(false);

  const picked = (cuisines ?? '').split(',').filter(Boolean);
  const toggle = (f: Flag) => setRules((r) => (r.includes(f) ? r.filter((x) => x !== f) : [...r, f]));
  const applyPreset = (flags: Flag[]) => setRules((r) => [...new Set([...r, ...flags])]);

  const finish = async (chosen: Flag[] = rules) => {
    if (!api) return;
    setSaving(true);
    try {
      await api.onboard(picked, chosen);
      await refreshMe();
      bump();
      if (edit) {
        toast(t('onboarding.saved'));
        router.dismissTo('/profile');
      } else {
        router.replace('/');
      }
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setSaving(false);
    }
  };

  return (
    <Screen contentStyle={s.content}>
      <BackButton onPress={() => router.back()} />
      <View style={s.progress}>
        <View style={[s.segment, s.on]} />
        <View style={[s.segment, s.on]} />
      </View>
      <Text style={s.step}>{t('onboarding.step', { n: 2 })}</Text>
      <Text style={s.title}>{t('onboarding.diet.title')}</Text>
      <Text style={s.sub}>{t('onboarding.diet.sub')}</Text>

      {/* RGPD, art. 9 : ces choix peuvent révéler une religion ou une santé. On
          explique d'abord, on demande un accord distinct, et « passer » reste
          un vrai choix. Sans accord, la base refuse d'enregistrer un interdit. */}
      {!me?.diet_consent ? (
        <View style={s.consent}>
          <Text style={s.consentTitle}>{t('consent.title')}</Text>
          <Text style={s.consentBody}>{t('consent.body')}</Text>
          <Text style={s.consentLink} onPress={() => router.push('/legal/privacy')}>{t('terms.privacy')} →</Text>
          <PrimaryButton
            label={t('consent.accept')}
            onPress={() => {
              void api?.giveDietConsent().then(refreshMe).catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
            }}
            style={s.gap}
          />
          <SecondaryButton label={t('consent.skip')} busy={saving} onPress={() => void finish([])} style={s.gapSmall} />
        </View>
      ) : (
      <>
      <Text style={s.label}>{t('onboarding.diet.presets')}</Text>
      <View style={s.chips}>
        {DIET_PRESETS.map((p) => (
          <Chip
            key={p.key}
            label={t(`preset.${p.key}`)}
            selected={p.flags.every((f) => rules.includes(f))}
            onPress={() => applyPreset(p.flags)}
          />
        ))}
      </View>

      <View style={[s.chips, s.gap]}>
        {FLAGS.map((f) => (
          <Chip key={f} large label={t(`flag.${f}`)} selected={rules.includes(f)} onPress={() => toggle(f)} />
        ))}
      </View>

      <Note style={s.note}>{t('onboarding.diet.disclaimer')}</Note>

      <PrimaryButton
        label={rules.length ? t('onboarding.finish') : t('onboarding.nothing')}
        busy={saving}
        onPress={() => void finish()}
        style={s.cta}
      />
      </>
      )}
    </Screen>
  );
}

const s = StyleSheet.create({
  content: { paddingBottom: 40 },
  consent: { padding: 16, borderRadius: 16, backgroundColor: color.sand, marginTop: 4 },
  consentTitle: { fontFamily: font.semibold, fontSize: 15, color: color.ink },
  consentBody: { fontFamily: font.regular, fontSize: 13.5, lineHeight: 20, color: color.inkSoft, marginTop: 6 },
  consentLink: { fontFamily: font.semibold, fontSize: 13, color: color.plum, marginTop: 8 },
  gapSmall: { marginTop: 8 },
  progress: { flexDirection: 'row', gap: 6, marginTop: 16 },
  segment: { flex: 1, height: 4, borderRadius: 2, backgroundColor: color.trackOff },
  on: { backgroundColor: color.plum },
  step: { fontFamily: font.semibold, fontSize: 11, letterSpacing: 1.4, textTransform: 'uppercase', color: color.plum, marginTop: 18 },
  title: { fontFamily: font.display, fontSize: 28, lineHeight: 32, letterSpacing: -0.5, color: color.ink, marginTop: 8 },
  sub: { fontFamily: font.regular, fontSize: 14, lineHeight: 21, color: color.inkSubtle, marginTop: 8, marginBottom: 18 },
  label: { fontFamily: font.semibold, fontSize: 12, color: color.inkFaint, marginBottom: 8 },
  chips: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  gap: { marginTop: 18 },
  note: { marginTop: 22 },
  cta: { marginTop: 22 },
});
