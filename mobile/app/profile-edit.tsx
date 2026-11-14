import React, { useState } from 'react';
import { StyleSheet, Text, TextInput } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../src/i18n';
import { useSession } from '../src/session';
import { errorText, useStore } from '../src/store';
import { color, font, radius } from '../src/theme';
import { BackButton, PrimaryButton, TextField } from '../src/ui/controls';
import { Screen, Title } from '../src/ui/primitives';

const USERNAME = /^[a-z0-9_.]{3,30}$/;

/** Modifier son nom, son nom d'utilisateur et sa bio. */
export default function ProfileEdit() {
  const router = useRouter();
  const { t } = useI18n();
  const { toast } = useStore();
  const { api, me, refreshMe, bump } = useSession();
  const [username, setUsername] = useState(me?.username ?? '');
  const [name, setName] = useState(me?.display_name ?? '');
  const [bio, setBio] = useState(me?.bio ?? '');
  const [saving, setSaving] = useState(false);

  const valid = USERNAME.test(username);

  const save = async () => {
    if (!api) return;
    setSaving(true);
    try {
      await api.updateProfile({ username, display_name: name.trim().slice(0, 60), bio: bio.trim().slice(0, 280) });
      await refreshMe();
      bump();
      toast(t('profile.saved'));
      router.back();
    } catch (e) {
      const raw = e instanceof Error ? e.message : '';
      toast(/duplicate|unique/i.test(raw) ? t('error.username_taken') : errorText(e, t, t('common.wentWrong')));
    } finally {
      setSaving(false);
    }
  };

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{t('profile.edit')}</Title>

      <Text style={s.label}>{t('profile.username')}</Text>
      <TextField value={username} onChangeText={(v) => setUsername(v.toLowerCase().trim())} autoCapitalize="none" />
      {!valid ? <Text style={s.error}>{t('profile.usernameInvalid')}</Text> : null}

      <Text style={s.label}>{t('profile.displayName')}</Text>
      <TextField value={name} onChangeText={setName} maxLength={60} />

      <Text style={s.label}>{t('profile.bio')}</Text>
      <TextInput value={bio} onChangeText={setBio} maxLength={280} multiline style={s.area} placeholderTextColor={color.muted} />
      <Text style={s.count}>{bio.length}/280</Text>

      <PrimaryButton label={t('common.save')} busy={saving} disabled={!valid} onPress={save} style={s.cta} />
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12, marginBottom: 8 },
  label: { fontFamily: font.semibold, fontSize: 12.5, color: color.inkFaint, marginTop: 16, marginBottom: 6 },
  error: { fontFamily: font.regular, fontSize: 12, color: color.ember, marginTop: 4 },
  area: {
    minHeight: 90, borderWidth: 1, borderColor: color.border, borderRadius: radius.md, backgroundColor: color.surface,
    paddingHorizontal: 14, paddingVertical: 10, fontFamily: font.regular, fontSize: 15, color: color.ink, textAlignVertical: 'top',
  },
  count: { fontFamily: font.regular, fontSize: 11.5, color: color.muted, textAlign: 'right', marginTop: 4 },
  cta: { marginTop: 24 },
});
