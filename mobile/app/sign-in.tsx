import React, { useState } from 'react';
import { Platform, Pressable, StyleSheet, Text, View } from 'react-native';

import { DEMO_ACCOUNTS } from '../src/api.mock';
import { useAuth } from '../src/auth';
import { useI18n } from '../src/i18n';
import { color, font, radius } from '../src/theme';
import { Signature } from '../src/ui/Logo';
import { PrimaryButton, SecondaryButton, TextField } from '../src/ui/controls';
import { Note, Screen } from '../src/ui/primitives';
import { Avatar } from '../src/ui/social';

type Busy = 'password' | 'google' | 'apple' | 'code' | 'reset' | null;
const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/**
 * Connexion et inscription : e-mail + mot de passe, Google, et Apple sur iOS.
 * Sans Supabase, le mode démo propose trois personnes fictives.
 */
export default function SignIn() {
  const { t } = useI18n();
  const auth = useAuth();
  const [mode, setMode] = useState<'signIn' | 'signUp'>('signIn');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [code, setCode] = useState('');
  const [busy, setBusy] = useState<Busy>(null);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);

  const attempt = async (kind: Exclude<Busy, null>, fn: () => Promise<void>) => {
    setError(null);
    setInfo(null);
    setBusy(kind);
    try {
      await fn();
    } catch (e) {
      setError(e instanceof Error ? e.message : t('common.wentWrong'));
    } finally {
      setBusy(null);
    }
  };

  if (!auth.configured) {
    const blurb: Record<string, string> = {
      amina_cuisine: t('signIn.demo.amina'),
      'tom.newbie': t('signIn.demo.tom'),
      marie_prive: t('signIn.demo.marie'),
    };
    return (
      <Screen contentStyle={s.content}>
        <Signature style={s.signature} />
        <Text style={s.title}>{t('signIn.title')}</Text>
        <Text style={s.sub}>{t('signIn.sub')}</Text>
        <Text style={s.section}>{t('signIn.demo.title')}</Text>
        <Text style={s.small}>{t('signIn.demo.sub')}</Text>
        {DEMO_ACCOUNTS.map((a) => (
          <Pressable
            key={a.id}
            accessibilityRole="button"
            onPress={() => auth.signInDemo(a.id)}
            style={({ pressed }) => [s.demo, pressed && { opacity: 0.7 }]}>
            <Avatar person={{ ...a, is_editorial: false }} size={40} />
            <View style={{ flex: 1 }}>
              <Text style={s.demoName}>{a.display_name} <Text style={s.demoUser}>@{a.username}</Text></Text>
              <Text style={s.small}>{blurb[a.username]}</Text>
            </View>
          </Pressable>
        ))}
      </Screen>
    );
  }

  if (auth.pendingConfirmation) {
    return (
      <Screen contentStyle={s.content}>
        <Text style={s.title}>{t('signIn.confirm.title')}</Text>
        <Text style={s.sub}>{t('signIn.confirm.sub', { email: auth.pendingConfirmation })}</Text>
        <TextField
          value={code}
          onChangeText={(v) => setCode(v.replace(/[^0-9]/g, '').slice(0, 6))}
          placeholder={t('signIn.confirm.code')}
          variant="code"
          keyboardType="number-pad"
          autoComplete="one-time-code"
          textContentType="oneTimeCode"
          maxLength={6}
          style={s.gapLarge}
        />
        <PrimaryButton
          label={t('signIn.confirm.submit')}
          busy={busy === 'code'}
          disabled={code.length !== 6 || busy !== null}
          onPress={() => attempt('code', () => auth.confirmSignUp(code))}
          style={s.gap}
        />
        {error ? <Text style={s.error}>{error}</Text> : null}
        <SecondaryButton label={t('signIn.confirm.other')} onPress={auth.clearPending} style={s.gap} />
      </Screen>
    );
  }

  const valid = EMAIL.test(email.trim()) && password.length >= (mode === 'signUp' ? 8 : 1);
  const showGoogle = Platform.OS !== 'ios' || auth.appleAvailable;
  const submit = () =>
    attempt('password', () => (mode === 'signIn' ? auth.signIn(email, password) : auth.signUp(email, password)));

  return (
    <Screen contentStyle={s.content}>
      <Signature style={s.signature} />
      <Text style={s.title}>{t('signIn.title')}</Text>
      <Text style={s.sub}>{t('signIn.sub')}</Text>

      <View style={s.options}>
        {auth.appleAvailable ? (
          <PrimaryButton
            label={t('signIn.apple')}
            busy={busy === 'apple'}
            disabled={busy !== null}
            onPress={() => attempt('apple', auth.signInWithApple)}
          />
        ) : null}
        {showGoogle ? (
          <SecondaryButton
            label={t('signIn.google')}
            busy={busy === 'google'}
            disabled={busy !== null}
            onPress={() => attempt('google', auth.signInWithGoogle)}
          />
        ) : null}
      </View>

      <View style={s.divider}>
        <View style={s.rule} />
        <Text style={s.dividerLabel}>{t('common.or')}</Text>
        <View style={s.rule} />
      </View>

      <TextField
        value={email}
        onChangeText={setEmail}
        placeholder={t('signIn.email')}
        keyboardType="email-address"
        autoComplete="email"
        textContentType="emailAddress"
        editable={busy === null}
      />
      <TextField
        value={password}
        onChangeText={setPassword}
        placeholder={t('signIn.password')}
        secureTextEntry
        autoComplete={mode === 'signUp' ? 'new-password' : 'current-password'}
        textContentType={mode === 'signUp' ? 'newPassword' : 'password'}
        editable={busy === null}
        onSubmitEditing={() => valid && submit()}
        style={s.gap}
      />
      {mode === 'signUp' ? <Text style={s.small}>{t('signIn.passwordRule')}</Text> : null}

      <PrimaryButton
        label={mode === 'signIn' ? t('signIn.submit') : t('signIn.create')}
        busy={busy === 'password'}
        disabled={!valid || busy !== null}
        onPress={submit}
        style={s.gap}
      />
      {error ? <Text style={s.error}>{error}</Text> : null}
      {info ? <Text style={s.info}>{info}</Text> : null}

      <Text style={s.switch} onPress={() => setMode(mode === 'signIn' ? 'signUp' : 'signIn')}>
        {mode === 'signIn' ? t('signIn.toSignUp') : t('signIn.toSignIn')}
      </Text>
      {mode === 'signIn' ? (
        <Text
          style={s.switch}
          onPress={() =>
            EMAIL.test(email.trim())
              ? attempt('reset', async () => {
                  await auth.resetPassword(email);
                  setInfo(t('signIn.forgotSent', { email: email.trim() }));
                })
              : setError(t('signIn.email'))
          }>
          {t('signIn.forgot')}
        </Text>
      ) : null}

      <Note style={s.note}>{t('signIn.terms')}</Note>
    </Screen>
  );
}

const s = StyleSheet.create({
  content: { paddingBottom: 34 },
  signature: { marginTop: 30 },
  title: { fontFamily: font.display, fontSize: 30, lineHeight: 33, letterSpacing: -0.6, color: color.ink, marginTop: 24 },
  sub: { fontFamily: font.regular, fontSize: 15, lineHeight: 22, color: color.inkSubtle, marginTop: 10 },
  section: { fontFamily: font.semibold, fontSize: 16, color: color.ink, marginTop: 30 },
  small: { fontFamily: font.regular, fontSize: 12.5, lineHeight: 18, color: color.mutedWarm, marginTop: 4 },
  demo: {
    flexDirection: 'row', alignItems: 'center', gap: 12, padding: 12, marginTop: 12,
    borderRadius: radius.lg, borderWidth: 1, borderColor: color.border, backgroundColor: color.surface,
  },
  demoName: { fontFamily: font.semibold, fontSize: 15, color: color.ink },
  demoUser: { fontFamily: font.regular, fontSize: 13, color: color.mutedWarm },
  options: { gap: 10, marginTop: 28 },
  divider: { flexDirection: 'row', alignItems: 'center', gap: 12, marginVertical: 20 },
  rule: { flex: 1, height: 1, backgroundColor: color.border },
  dividerLabel: { fontFamily: font.regular, fontSize: 12.5, color: color.muted },
  gap: { marginTop: 10 },
  gapLarge: { marginTop: 24 },
  error: { fontFamily: font.medium, fontSize: 13, lineHeight: 19, color: color.ember, marginTop: 12 },
  info: { fontFamily: font.medium, fontSize: 13, lineHeight: 19, color: color.green, marginTop: 12 },
  switch: { fontFamily: font.semibold, fontSize: 13.5, color: color.plum, marginTop: 16, textAlign: 'center' },
  note: { marginTop: 24 },
});
