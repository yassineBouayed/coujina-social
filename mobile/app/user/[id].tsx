import React, { useEffect, useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font } from '../../src/theme';
import type { Profile, RecipeCard, ReportReason } from '../../src/types';
import { BackButton, PrimaryButton, SecondaryButton } from '../../src/ui/controls';
import { Screen } from '../../src/ui/primitives';
import { ProfileHeader } from '../../src/ui/ProfileHeader';
import { Empty, OptionSheet, RecipeTile, TileGrid } from '../../src/ui/social';

const REASONS: ReportReason[] = ['spam', 'offensive', 'copyright', 'dangerous', 'other'];

/** Le profil de quelqu'un d'autre : ses recettes visibles pour moi, et le suivre. */
export default function UserProfile() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const { t } = useI18n();
  const { toast } = useStore();
  const { api, me, bump, version } = useSession();
  const [profile, setProfile] = useState<Profile | null | undefined>(undefined);
  const [recipes, setRecipes] = useState<RecipeCard[]>([]);
  const [busy, setBusy] = useState(false);
  const [menu, setMenu] = useState<'none' | 'more' | 'report'>('none');

  const load = () => {
    if (!api || !id) return;
    api.profile(id).then(setProfile).catch(() => setProfile(null));
    api.userRecipes(id).then(setRecipes).catch(() => setRecipes([]));
  };
  useEffect(load, [api, id, version]);

  useEffect(() => {
    if (me && id === me.id) router.replace('/profile');
  }, [me, id, router]);

  const toggleFollow = async () => {
    if (!api || !profile) return;
    setBusy(true);
    try {
      if (profile.is_following) await api.unfollow(profile.id);
      else await api.follow(profile.id);
      bump();
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setBusy(false);
    }
  };

  if (profile === undefined) return <Screen><BackButton onPress={() => router.back()} /><ActivityIndicator color={color.plum} /></Screen>;
  if (profile === null) return <Screen><BackButton onPress={() => router.back()} /><Empty>{t('recipe.notFound')}</Empty></Screen>;

  return (
    <Screen>
      <View style={s.top}>
        <BackButton onPress={() => router.back()} />
        {!profile.is_editorial ? <Text style={s.more} onPress={() => setMenu('more')}>•••</Text> : null}
      </View>
      <ProfileHeader
        profile={profile}
        action={
          profile.is_following ? (
            <SecondaryButton label={t('profile.unfollow')} busy={busy} onPress={toggleFollow} />
          ) : (
            <PrimaryButton label={t('profile.follow')} busy={busy} onPress={toggleFollow} />
          )
        }
      />
      <View style={s.grid}>
        {recipes.length ? (
          <TileGrid>
            {recipes.map((r) => <RecipeTile key={r.id} recipe={r} />)}
          </TileGrid>
        ) : (
          <Empty>{t('profile.noRecipes')}</Empty>
        )}
      </View>

      <OptionSheet
        visible={menu === 'more'}
        title={`@${profile.username}`}
        options={[
          { value: 'report', label: t('profile.report') },
          { value: 'block', label: t('profile.block'), danger: true },
        ]}
        onClose={() => setMenu('none')}
        onPick={(v) => {
          if (v === 'report') return setMenu('report');
          setMenu('none');
          api?.block(profile.id).then(() => {
            toast(t('profile.blocked'));
            bump();
            router.back();
          }).catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
        }}
      />
      <OptionSheet
        visible={menu === 'report'}
        title={t('report.title')}
        options={REASONS.map((r) => ({ value: r, label: t(`report.${r}`) }))}
        onClose={() => setMenu('none')}
        onPick={(reason) => {
          setMenu('none');
          api?.report({ profileId: profile.id }, reason).then(() => toast(t('recipe.reported')))
            .catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
        }}
      />
    </Screen>
  );
}

const s = StyleSheet.create({
  top: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  more: { fontFamily: font.bold, fontSize: 18, color: color.inkFaint, padding: 8 },
  grid: { marginTop: 22 },
});
