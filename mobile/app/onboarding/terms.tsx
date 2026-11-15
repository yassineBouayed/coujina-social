import React, { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font, radius } from '../../src/theme';
import { PrimaryButton } from '../../src/ui/controls';
import { Screen, Title } from '../../src/ui/primitives';

function Box({ checked, label, onPress }: { checked: boolean; label: string; onPress: () => void }) {
  return (
    <Pressable accessibilityRole="checkbox" accessibilityState={{ checked }} onPress={onPress} style={s.boxRow}>
      <View style={[s.box, checked && s.boxOn]}>{checked ? <Text style={s.tick}>✓</Text> : null}</View>
      <Text style={s.boxLabel}>{label}</Text>
    </Pressable>
  );
}

/**
 * La porte d'entrée : accepter les CGU et la politique de confidentialité
 * (dans leur version en vigueur), et déclarer avoir 15 ans ou plus. Rien de
 * coché d'avance. Si les textes changent, on repasse par ici.
 */
export default function Terms() {
  const { t } = useI18n();
  const router = useRouter();
  const { toast } = useStore();
  const { api, me, refreshMe } = useSession();
  const [age, setAge] = useState(false);
  const [accepted, setAccepted] = useState(false);
  const [busy, setBusy] = useState(false);

  const go = async () => {
    if (!api) return;
    setBusy(true);
    try {
      await api.acceptTerms(age);
      await refreshMe();
      router.replace(me?.onboarded ? '/' : '/onboarding/cuisines');
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setBusy(false);
    }
  };

  return (
    <Screen contentStyle={s.content}>
      <Title style={s.title}>{t('terms.title')}</Title>
      <Text style={s.sub}>{t('terms.sub')}</Text>
      <Text style={s.link} onPress={() => router.push('/legal/cgu')}>{t('terms.cgu')} →</Text>
      <Text style={s.link} onPress={() => router.push('/legal/privacy')}>{t('terms.privacy')} →</Text>

      <View style={s.boxes}>
        <Box checked={age} label={t('terms.age')} onPress={() => setAge((v) => !v)} />
        <Box checked={accepted} label={t('terms.accept')} onPress={() => setAccepted((v) => !v)} />
      </View>

      <PrimaryButton label={t('terms.continue')} busy={busy} disabled={!age || !accepted} onPress={go} style={s.cta} />
      {!age ? <Text style={s.note}>{t('terms.tooYoung')}</Text> : null}
    </Screen>
  );
}

const s = StyleSheet.create({
  content: { paddingBottom: 40 },
  title: { marginTop: 24 },
  sub: { fontFamily: font.regular, fontSize: 14.5, lineHeight: 21, color: color.inkSubtle, marginTop: 10, marginBottom: 14 },
  link: { fontFamily: font.semibold, fontSize: 14, color: color.plum, marginTop: 8 },
  boxes: { marginTop: 24, gap: 14 },
  boxRow: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  box: { width: 24, height: 24, borderRadius: 6, borderWidth: 1.5, borderColor: color.borderDark, alignItems: 'center', justifyContent: 'center', backgroundColor: color.surface },
  boxOn: { backgroundColor: color.plum, borderColor: color.plum },
  tick: { color: '#fff', fontFamily: font.bold, fontSize: 14 },
  boxLabel: { flex: 1, fontFamily: font.medium, fontSize: 14, lineHeight: 20, color: color.ink },
  cta: { marginTop: 26, borderRadius: radius.lg },
  note: { fontFamily: font.regular, fontSize: 12.5, color: color.mutedWarm, marginTop: 10 },
});
