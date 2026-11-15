import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../src/i18n';
import { useSession } from '../src/session';
import { errorText, useStore } from '../src/store';
import { color, font, radius } from '../src/theme';
import { BackButton, PrimaryButton, SecondaryButton } from '../src/ui/controls';
import { Note, Screen, Title } from '../src/ui/primitives';

/**
 * L'offre Premium — le livre de famille, à l'année. Pendant la bêta : un essai
 * de 30 jours, puis une PRÉCOMMANDE payée (lien Stripe). C'est la preuve
 * d'argent réel demandée par le panel : le rapport de bêta compte qui a payé,
 * et qui a payé après avoir exporté son livre.
 */
export default function Premium() {
  const router = useRouter();
  const { t, tn, locale } = useI18n();
  const { toast } = useStore();
  const { api, me, refreshMe, bump } = useSession();
  const [busy, setBusy] = useState(false);
  const [opened, setOpened] = useState(false);

  useEffect(() => {
    if (api) void api.track('premium_view');
  }, [api]);

  if (!me) return <Screen><BackButton onPress={() => router.back()} /></Screen>;

  const day = 24 * 3600 * 1000;
  const trialDays = me.trial_until ? Math.ceil((Date.parse(me.trial_until) - Date.now()) / day) : 0;
  const paidUntil = me.has_paid && me.premium_until ? new Date(me.premium_until).toLocaleDateString(locale, { day: 'numeric', month: 'long', year: 'numeric' }) : null;

  const buy = async () => {
    if (!api) return;
    setBusy(true);
    try {
      const result = await api.preorder();
      if (result === 'unavailable') toast(t('premium.unavailable'));
      else if (result === 'opened') setOpened(true);
      await refreshMe();
      bump();
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setBusy(false);
    }
  };

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{t('premium.title')}</Title>
      <Text style={s.sub}>{t('premium.sub')}</Text>

      <View style={s.card}>
        <Text style={s.price}>{t('premium.price')}</Text>
        {[t('premium.point1'), t('premium.point2'), t('premium.point3')].map((p) => (
          <Text key={p} style={s.point}>✓  {p}</Text>
        ))}
      </View>

      {paidUntil ? (
        <Note style={s.gap}>{t('premium.paid', { date: paidUntil })}</Note>
      ) : (
        <>
          {trialDays > 0 ? <Text style={s.trial}>{tn('premium.trial', trialDays)}</Text> : null}
          <PrimaryButton label={t('premium.cta')} busy={busy} onPress={() => void buy()} style={s.gap} />
          <Text style={s.note}>{t('premium.note')}</Text>
          {opened ? (
            <>
              <Note style={s.gap}>{t('premium.opened')}</Note>
              <SecondaryButton label={t('premium.refresh')} onPress={() => void refreshMe()} style={s.gapSmall} />
            </>
          ) : null}
        </>
      )}

      <Text style={s.link} onPress={() => router.push('/family')}>{t('family.title')} →</Text>
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12 },
  sub: { fontFamily: font.regular, fontSize: 14.5, lineHeight: 21, color: color.inkSubtle, marginTop: 8 },
  card: { marginTop: 18, padding: 16, borderRadius: radius.card, backgroundColor: color.surface, borderWidth: 2, borderColor: color.plum },
  price: { fontFamily: font.display, fontSize: 22, color: color.plum, marginBottom: 10 },
  point: { fontFamily: font.medium, fontSize: 14, lineHeight: 22, color: color.ink },
  trial: { fontFamily: font.semibold, fontSize: 14, color: color.green, marginTop: 18 },
  gap: { marginTop: 16 },
  gapSmall: { marginTop: 8 },
  note: { fontFamily: font.regular, fontSize: 12, lineHeight: 17, color: color.mutedWarm, marginTop: 8 },
  link: { fontFamily: font.semibold, fontSize: 14, color: color.plum, marginTop: 24 },
});
