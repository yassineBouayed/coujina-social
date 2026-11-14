import React, { useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { color, font } from '../../src/theme';
import { BackButton, Chip, PrimaryButton } from '../../src/ui/controls';
import { Screen } from '../../src/ui/primitives';

/**
 * Premier lancement, étape 1 sur 2 : les cuisines aimées. Repris de
 * l'onboarding de l'ancien projet, ramené à une seule question (on ne
 * distingue plus « les nôtres » et « à découvrir »).
 *
 * Avec `?edit=1`, le même écran sert depuis le profil.
 */
export default function OnboardingCuisines() {
  const { t } = useI18n();
  const router = useRouter();
  const { edit } = useLocalSearchParams<{ edit?: string }>();
  const { me, cuisines } = useSession();
  const [picked, setPicked] = useState<string[]>(me?.cuisines ?? []);

  const toggle = (slug: string) =>
    setPicked((c) => (c.includes(slug) ? c.filter((x) => x !== slug) : [...c, slug]));

  return (
    <Screen contentStyle={s.content}>
      {edit ? <BackButton onPress={() => router.back()} /> : null}
      <View style={s.progress}>
        <View style={[s.segment, s.on]} />
        <View style={s.segment} />
      </View>
      <Text style={s.step}>{t('onboarding.step', { n: 1 })}</Text>
      <Text style={s.title}>{t('onboarding.cuisines.title')}</Text>
      <Text style={s.sub}>{t('onboarding.cuisines.sub')}</Text>

      <View style={s.chips}>
        {cuisines.map((c) => (
          <Chip key={c.slug} large label={c.name} selected={picked.includes(c.slug)} onPress={() => toggle(c.slug)} />
        ))}
      </View>

      {picked.length === 0 ? <Text style={s.hint}>{t('onboarding.pickOne')}</Text> : null}
      <PrimaryButton
        label={t('onboarding.continue')}
        disabled={picked.length === 0}
        onPress={() =>
          router.push({ pathname: '/onboarding/diet', params: { cuisines: picked.join(','), ...(edit ? { edit: '1' } : {}) } })
        }
        style={s.cta}
      />
    </Screen>
  );
}

const s = StyleSheet.create({
  content: { paddingBottom: 40 },
  progress: { flexDirection: 'row', gap: 6, marginTop: 16 },
  segment: { flex: 1, height: 4, borderRadius: 2, backgroundColor: color.trackOff },
  on: { backgroundColor: color.plum },
  step: { fontFamily: font.semibold, fontSize: 11, letterSpacing: 1.4, textTransform: 'uppercase', color: color.plum, marginTop: 18 },
  title: { fontFamily: font.display, fontSize: 28, lineHeight: 32, letterSpacing: -0.5, color: color.ink, marginTop: 8 },
  sub: { fontFamily: font.regular, fontSize: 14, lineHeight: 21, color: color.inkSubtle, marginTop: 8, marginBottom: 20 },
  chips: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  hint: { fontFamily: font.regular, fontSize: 12.5, color: color.mutedWarm, marginTop: 18 },
  cta: { marginTop: 26 },
});
