import React, { useEffect, useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font, radius } from '../../src/theme';
import type { Family } from '../../src/types';
import { BackButton, PrimaryButton, SecondaryButton, TextField } from '../../src/ui/controls';
import { Note, Screen, Title } from '../../src/ui/primitives';
import { Empty } from '../../src/ui/social';

/** Mes livres de famille : ceux que j'ai créés (premium) et ceux que j'ai rejoints (gratuit). */
export default function Families() {
  const router = useRouter();
  const { t, tn } = useI18n();
  const { toast } = useStore();
  const { api, me, version, bump } = useSession();
  const [books, setBooks] = useState<Family[]>([]);
  const [name, setName] = useState('');
  const [code, setCode] = useState('');
  const [busy, setBusy] = useState<'create' | 'join' | null>(null);

  useEffect(() => {
    api?.myFamilies().then(setBooks).catch(() => setBooks([]));
  }, [api, version]);

  const run = async (kind: 'create' | 'join') => {
    if (!api) return;
    setBusy(kind);
    try {
      const id = kind === 'create' ? await api.createFamily(name) : await api.joinFamily(code);
      bump();
      setName('');
      setCode('');
      router.push(`/family/${id}`);
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setBusy(null);
    }
  };

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{t('family.title')}</Title>
      <Text style={s.sub}>{t('family.sub')}</Text>

      {books.length ? (
        books.map((b) => (
          <Pressable key={b.id} accessibilityRole="button" onPress={() => router.push(`/family/${b.id}`)} style={s.book}>
            <Text style={s.bookName}>{b.name}</Text>
            <Text style={s.bookMeta}>{tn('family.members', b.members)}  ·  {tn('family.recipes', b.recipes)}</Text>
          </Pressable>
        ))
      ) : (
        <Empty>{t('family.empty')}</Empty>
      )}

      <View style={s.block}>
        <Text style={s.label}>{t('family.join')}</Text>
        <TextField value={code} onChangeText={(v) => setCode(v.toUpperCase())} placeholder={t('family.codePlaceholder')} autoCapitalize="characters" />
        <SecondaryButton label={t('family.join')} busy={busy === 'join'} disabled={code.trim().length < 4} onPress={() => void run('join')} style={s.gap} />
      </View>

      <View style={s.block}>
        <Text style={s.label}>{t('family.create')}</Text>
        {me?.is_premium ? (
          <>
            <TextField value={name} onChangeText={setName} placeholder={t('family.namePlaceholder')} autoCapitalize="sentences" maxLength={60} />
            <PrimaryButton label={t('family.create')} busy={busy === 'create'} disabled={!name.trim()} onPress={() => void run('create')} style={s.gap} />
          </>
        ) : (
          <Note>{t('family.premium')}</Note>
        )}
      </View>
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12 },
  sub: { fontFamily: font.regular, fontSize: 14, lineHeight: 20, color: color.inkSubtle, marginTop: 6, marginBottom: 16 },
  book: { padding: 14, borderRadius: radius.lg, borderWidth: 1, borderColor: color.border, backgroundColor: color.surface, marginBottom: 10 },
  bookName: { fontFamily: font.semibold, fontSize: 16, color: color.ink },
  bookMeta: { fontFamily: font.regular, fontSize: 12.5, color: color.mutedWarm, marginTop: 3 },
  block: { marginTop: 24 },
  label: { fontFamily: font.semibold, fontSize: 12, letterSpacing: 1.2, textTransform: 'uppercase', color: color.plum, marginBottom: 8 },
  gap: { marginTop: 10 },
});
