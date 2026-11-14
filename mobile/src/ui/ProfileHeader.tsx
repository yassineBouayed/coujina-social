/** L'en-tête d'un profil : avatar, nom, bio, compteurs, et l'action principale. */
import React, { type ReactNode } from 'react';
import { StyleSheet, Text, View } from 'react-native';

import { useI18n } from '../i18n';
import { color, font, radius } from '../theme';
import type { Profile } from '../types';
import { Avatar } from './social';

export function ProfileHeader({ profile, action }: { profile: Profile; action?: ReactNode }) {
  const { t } = useI18n();
  return (
    <View>
      <View style={s.row}>
        <Avatar person={profile} size={72} />
        <View style={s.counts}>
          <Count n={profile.recipes} label={t('profile.recipes')} />
          <Count n={profile.followers} label={t('profile.followers')} />
          <Count n={profile.following} label={t('profile.following')} />
        </View>
      </View>
      <Text style={s.name}>{profile.display_name || profile.username}</Text>
      <Text style={s.username}>
        @{profile.username}
        {profile.is_editorial ? `  ·  ${t('profile.editorial')}` : ''}
        {profile.follows_me && !profile.is_me ? `  ·  ${t('profile.followsYou')}` : ''}
      </Text>
      {profile.bio ? <Text style={s.bio}>{profile.bio}</Text> : null}
      {action ? <View style={s.action}>{action}</View> : null}
    </View>
  );
}

function Count({ n, label }: { n: number; label: string }) {
  return (
    <View style={s.count}>
      <Text style={s.countN}>{n}</Text>
      <Text style={s.countLabel}>{label}</Text>
    </View>
  );
}

const s = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', gap: 18, marginTop: 10 },
  counts: { flex: 1, flexDirection: 'row', justifyContent: 'space-around' },
  count: { alignItems: 'center' },
  countN: { fontFamily: font.bold, fontSize: 18, color: color.ink },
  countLabel: { fontFamily: font.regular, fontSize: 11.5, color: color.mutedWarm, marginTop: 2 },
  name: { fontFamily: font.display, fontSize: 22, color: color.ink, marginTop: 14 },
  username: { fontFamily: font.regular, fontSize: 13, color: color.mutedWarm, marginTop: 2 },
  bio: { fontFamily: font.regular, fontSize: 14, lineHeight: 20, color: color.inkSoft, marginTop: 10 },
  action: { marginTop: 14, borderRadius: radius.lg },
});
