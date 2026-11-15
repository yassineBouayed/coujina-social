import React, { useEffect, useState } from 'react';
import { Pressable, Share, StyleSheet, Text, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useAuth } from '../../src/auth';
import { useI18n, type LangChoice } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font } from '../../src/theme';
import type { Profile } from '../../src/types';
import { SecondaryButton, Toggle } from '../../src/ui/controls';
import { Card, CardRow, Screen, SectionHeader } from '../../src/ui/primitives';
import { confirm } from '../../src/ui/confirm';
import { ProfileHeader } from '../../src/ui/ProfileHeader';
import { DemoBanner, Segmented } from '../../src/ui/social';

/** Mon profil : mes compteurs, mes préférences, la langue, le compte. */
export default function MyProfile() {
  const { t, choice, setChoice } = useI18n();
  const router = useRouter();
  const { toast } = useStore();
  const auth = useAuth();
  const { tn } = useI18n();
  const { api, me, cuisineName, version, refreshMe, bump } = useSession();
  const [profile, setProfile] = useState<Profile | null>(null);
  const [unread, setUnread] = useState(0);

  useEffect(() => {
    if (!api || !me) return;
    api.profile(me.id).then(setProfile).catch(() => setProfile(null));
    api.activityUnread().then(setUnread).catch(() => setUnread(0));
  }, [api, me, version]);

  const invite = () => {
    if (!api || !me) return;
    void api.track('share_invite');
    void Share.share({
      message: t('invite.message', { username: me.username, link: `coujinasocial://u/${me.username}` }),
    });
  };

  if (!me) return <Screen><DemoBanner /></Screen>;

  const row = (label: string, value: string, onPress: () => void, first = false) => (
    <Pressable accessibilityRole="button" onPress={onPress}>
      <CardRow first={first} style={s.row}>
        <View style={{ flex: 1 }}>
          <Text style={s.rowLabel}>{label}</Text>
          <Text style={s.rowValue} numberOfLines={2}>{value}</Text>
        </View>
        <Text style={s.chevron}>›</Text>
      </CardRow>
    </Pressable>
  );

  return (
    <Screen>
      <DemoBanner />
      {profile ? (
        <ProfileHeader
          profile={profile}
          action={<SecondaryButton label={t('profile.edit')} onPress={() => router.push('/profile-edit')} />}
        />
      ) : null}

      <View style={s.section}>
        <Card>
          {row(
            t('activity.title'),
            unread ? tn('activity.unread', unread) : '—',
            () => router.push('/activity'),
            true,
          )}
          {row(t('profile.premium'), me.has_paid ? '✓' : t('premium.price'), () => router.push('/premium'))}
          {row(t('profile.family'), '', () => router.push('/family'))}
          {me.is_moderator ? row(t('profile.moderation'), '', () => router.push('/moderation')) : null}
        </Card>
      </View>

      <View style={s.links}>
        <Text style={s.search} onPress={() => router.push('/search')}>{t('profile.search')} →</Text>
        <Text style={s.search} onPress={invite}>{t('invite.button')} →</Text>
      </View>

      <View style={s.section}>
        <SectionHeader label={t('profile.preferences')} />
        <Card>
          {row(
            t('profile.cuisines'),
            me.cuisines.map(cuisineName).join(', ') || '—',
            () => router.push({ pathname: '/onboarding/cuisines', params: { edit: '1' } }),
            true,
          )}
          {row(
            t('profile.diet'),
            me.exclusions.length ? me.exclusions.map((f) => t(`flag.${f}`)).join(', ') : t('profile.dietNone'),
            () => router.push({ pathname: '/onboarding/cuisines', params: { edit: '1' } }),
          )}
        </Card>
        {me.diet_consent ? (
          <Text
            style={s.withdraw}
            onPress={() =>
              confirm(t('consent.withdrawConfirm'), { ok: t('consent.withdraw'), cancel: t('common.cancel') }, () => {
                api?.withdrawDietConsent()
                  .then(() => refreshMe())
                  .then(() => {
                    bump();
                    toast(t('consent.withdrawn'));
                  })
                  .catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
              })
            }>
            {t('consent.withdraw')}
          </Text>
        ) : null}
      </View>

      <View style={s.section}>
        <SectionHeader label={t('profile.notifications')} />
        <Card>
          {(['copies', 'follows', 'challenge'] as const).map((k, i) => (
            <CardRow key={k} first={i === 0} style={s.row}>
              <Text style={[s.rowLabel, { flex: 1 }]}>{t(`notify.${k}`)}</Text>
              <Toggle
                label={t(`notify.${k}`)}
                value={me.notify[k]}
                onPress={() => {
                  api?.setNotify({ [k]: !me.notify[k] }).then(refreshMe).catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
                }}
              />
            </CardRow>
          ))}
        </Card>
      </View>

      <View style={s.section}>
        <SectionHeader label={t('profile.language')} />
        <Segmented<LangChoice>
          value={choice}
          onChange={setChoice}
          options={[
            { value: 'fr', label: 'Français' },
            { value: 'en', label: 'English' },
            { value: 'system', label: t('profile.language.system') },
          ]}
        />
      </View>

      <View style={s.section}>
        <Card>
          <CardRow first style={s.row}>
            <View style={{ flex: 1 }}>
              <Text style={s.rowLabel}>{t('profile.analytics')}</Text>
              <Text style={s.rowValue}>{t('profile.analytics.sub')}</Text>
            </View>
            <Toggle
              label={t('profile.analytics')}
              value={!me.analytics_opt_out}
              onPress={() => {
                api
                  ?.setAnalyticsOptOut(!me.analytics_opt_out)
                  .then(refreshMe)
                  .catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
              }}
            />
          </CardRow>
        </Card>
      </View>

      <View style={s.links}>
        <Text style={s.search} onPress={() => router.push('/legal/cgu')}>{t('legal.cgu')} →</Text>
        <Text style={s.search} onPress={() => router.push('/legal/privacy')}>{t('legal.privacy')} →</Text>
      </View>

      <View style={s.section}>
        <SecondaryButton label={t('profile.signOut')} onPress={() => void auth.signOut()} />
        <Text
          style={s.delete}
          onPress={() =>
            confirm(t('profile.deleteConfirm'), { ok: t('profile.delete'), cancel: t('common.cancel') }, () => {
              api
                ?.deleteAccount()
                .then(() => {
                  toast(t('profile.deleted'));
                  return auth.signOut();
                })
                .catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
            })
          }>
          {t('profile.delete')}
        </Text>
      </View>
    </Screen>
  );
}

const s = StyleSheet.create({
  links: { marginTop: 18, gap: 12 },
  withdraw: { fontFamily: font.medium, fontSize: 13, color: color.ember, marginTop: 10 },
  search: { fontFamily: font.semibold, fontSize: 14, color: color.plum },
  section: { marginTop: 26 },
  row: { paddingVertical: 13 },
  rowLabel: { fontFamily: font.medium, fontSize: 14.5, color: color.ink },
  rowValue: { fontFamily: font.regular, fontSize: 12.5, color: color.mutedWarm, marginTop: 3 },
  chevron: { fontFamily: font.regular, fontSize: 22, color: color.muted },
  delete: { fontFamily: font.semibold, fontSize: 13.5, color: color.ember, textAlign: 'center', marginTop: 20 },
});
