import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Image, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import * as ImagePicker from 'expo-image-picker';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font, radius } from '../../src/theme';
import {
  DIFFICULTIES, FLAGS, VISIBILITIES,
  type Country, type Difficulty, type Flag, type RecipeDetail, type RecipeInput, type Visibility,
} from '../../src/types';
import { BackButton, Chip, PrimaryButton, SecondaryButton, TextField } from '../../src/ui/controls';
import { Note, Screen, SectionHeader, Title } from '../../src/ui/primitives';

const MAX_VIDEO_SECONDS = 180;

type Line = { raw: string; optional: boolean };

/**
 * Écrire une recette, modifier la sienne, ou copier celle d'un autre AVEC
 * modifications (?from=<id>) : elle s'affichera alors « Recette de X ·
 * modifiée par moi ».
 */
export default function EditRecipe() {
  const { id, from } = useLocalSearchParams<{ id?: string; from?: string }>();
  const router = useRouter();
  const { t } = useI18n();
  const { toast } = useStore();
  const { api, cuisines, bump } = useSession();

  const [loaded, setLoaded] = useState(!id && !from);
  const [source, setSource] = useState<RecipeDetail | null>(null);
  const [countries, setCountries] = useState<Country[]>([]);
  const [title, setTitle] = useState('');
  const [nativeName, setNativeName] = useState('');
  const [description, setDescription] = useState('');
  const [cuisine, setCuisine] = useState<string | null>(null);
  const [country, setCountry] = useState<string | null>(null);
  const [difficulty, setDifficulty] = useState<Difficulty>('medium');
  const [prep, setPrep] = useState('');
  const [cook, setCook] = useState('');
  const [servings, setServings] = useState('4');
  const [ingredients, setIngredients] = useState<Line[]>([{ raw: '', optional: false }]);
  const [steps, setSteps] = useState<string[]>(['']);
  const [visibility, setVisibility] = useState<Visibility>('public');
  const [declared, setDeclared] = useState<Flag[]>([]);
  const [cover, setCover] = useState<string | null>(null);
  const [video, setVideo] = useState<string | null>(null);
  const [uploading, setUploading] = useState<'photo' | 'video' | null>(null);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!api) return;
    api.globe().then(setCountries).catch(() => undefined);
    const start = id ?? from;
    if (!start) return;
    api.recipe(start).then((r) => {
      if (!r) return;
      if (from) setSource(r);
      setTitle(r.title);
      setNativeName(r.native_name ?? '');
      setDescription(r.description);
      setCuisine(r.cuisine);
      setCountry(r.country);
      setDifficulty(r.difficulty);
      setPrep(r.prep_min ? String(r.prep_min) : '');
      setCook(r.cook_min ? String(r.cook_min) : '');
      setServings(String(r.servings));
      setIngredients(r.ingredients.length ? r.ingredients : [{ raw: '', optional: false }]);
      setSteps(r.steps.length ? r.steps.map((x) => x.body) : ['']);
      setVisibility(from ? (r.visibility === 'public' ? 'public' : r.visibility) : r.visibility);
      setDeclared(r.declared_flags);
      setCover(r.cover_url);
      setVideo(r.video_url);
    }).finally(() => setLoaded(true));
  }, [api, id, from]);

  const pickMedia = async (kind: 'photo' | 'video', camera: boolean) => {
    if (!api) return;
    const perm = camera ? await ImagePicker.requestCameraPermissionsAsync() : await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (!perm.granted) {
      toast(t('edit.permission'));
      return;
    }
    const options: ImagePicker.ImagePickerOptions = {
      mediaTypes: kind === 'photo' ? ['images'] : ['videos'],
      quality: 0.8,
      allowsEditing: kind === 'photo',
      aspect: [4, 3],
      videoMaxDuration: MAX_VIDEO_SECONDS,
    };
    const result = camera ? await ImagePicker.launchCameraAsync(options) : await ImagePicker.launchImageLibraryAsync(options);
    if (result.canceled || !result.assets[0]) return;
    const asset = result.assets[0];
    setUploading(kind);
    try {
      const url = await api.upload(asset.uri, kind, asset.mimeType ?? null);
      if (kind === 'photo') setCover(url);
      else setVideo(url);
    } catch {
      toast(t('edit.uploadFailed'));
    } finally {
      setUploading(null);
    }
  };

  const num = (v: string) => (v.trim() ? Math.max(0, parseInt(v, 10) || 0) : null);

  const submit = async () => {
    if (!api) return;
    const input: RecipeInput = {
      title, native_name: nativeName, description, cuisine, country,
      meal_type: source?.meal_type ?? null, difficulty,
      prep_min: num(prep), cook_min: num(cook), servings: Math.min(50, Math.max(1, num(servings) ?? 4)),
      visibility, cover_url: cover, video_url: video, declared_flags: declared,
      ingredients: ingredients.filter((l) => l.raw.trim()).map((l) => ({ raw: l.raw.trim(), optional: l.optional })),
      steps: steps.filter((x) => x.trim()).map((body) => ({ body: body.trim() })),
    };
    setSaving(true);
    try {
      const saved = await api.save(id ?? null, input, from ?? null);
      bump();
      toast(t('edit.saved'));
      router.replace(`/recipe/${saved}`);
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setSaving(false);
    }
  };

  if (!loaded) return <Screen><ActivityIndicator color={color.plum} /></Screen>;

  const creator = source ? source.credit ?? source.author : null;
  const countryChoices = countries.filter((c) => !cuisine || c.cuisine === cuisine);

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{id ? t('edit.titleEdit') : from ? t('edit.titleCopy') : t('edit.titleNew')}</Title>
      {creator ? <Note style={s.gap}>{t('edit.copyNote', { name: creator.display_name || creator.username })}</Note> : null}

      <TextField value={title} onChangeText={setTitle} placeholder={t('edit.name')} autoCapitalize="sentences" style={s.gapLarge} />
      <TextField value={nativeName} onChangeText={setNativeName} placeholder={t('edit.nativeName')} autoCapitalize="sentences" style={s.gap} />
      <TextInput
        value={description}
        onChangeText={setDescription}
        placeholder={t('edit.description')}
        placeholderTextColor={color.muted}
        multiline
        style={[s.area, s.gap]}
      />

      <Section label={t('edit.media')}>
        <View style={s.mediaRow}>
          {cover ? <Image source={{ uri: cover }} style={s.thumb} /> : null}
          {video ? <View style={[s.thumb, s.videoThumb]}><Text style={s.play}>▶</Text></View> : null}
        </View>
        {uploading ? (
          <Text style={s.small}>{t('edit.uploading')}</Text>
        ) : (
          <View style={s.mediaButtons}>
            <SecondaryButton label={cover ? t('edit.removeMedia') + ' — photo' : t('edit.addPhoto')} onPress={() => (cover ? setCover(null) : void pickMedia('photo', false))} />
            {video ? (
              <SecondaryButton label={t('edit.removeMedia') + ' — vidéo'} onPress={() => setVideo(null)} />
            ) : (
              <>
                <SecondaryButton label={t('edit.recordVideo')} onPress={() => void pickMedia('video', true)} />
                <SecondaryButton label={t('edit.pickVideo')} onPress={() => void pickMedia('video', false)} />
              </>
            )}
          </View>
        )}
      </Section>

      <Section label={t('edit.cuisine')}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={s.chips}>
          {cuisines.map((c) => (
            <Chip key={c.slug} label={c.name} selected={cuisine === c.slug} onPress={() => { setCuisine(c.slug); setCountry(null); }} />
          ))}
        </ScrollView>
      </Section>

      <Section label={t('edit.country')}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={s.chips}>
          <Chip label={t('edit.countryNone')} selected={country === null} onPress={() => setCountry(null)} />
          {countryChoices.map((c) => (
            <Chip key={c.slug} label={`${c.flag} ${c.name}`} selected={country === c.slug} onPress={() => setCountry(c.slug)} />
          ))}
        </ScrollView>
      </Section>

      <Section label={t('edit.difficulty')}>
        <View style={s.chipsWrap}>
          {DIFFICULTIES.map((d) => (
            <Chip key={d} label={t(`difficulty.${d}`)} selected={difficulty === d} onPress={() => setDifficulty(d)} />
          ))}
        </View>
      </Section>

      <View style={s.numbers}>
        <NumberField label={t('edit.prep')} value={prep} onChange={setPrep} />
        <NumberField label={t('edit.cook')} value={cook} onChange={setCook} />
        <NumberField label={t('edit.servings')} value={servings} onChange={setServings} />
      </View>

      <Section label={t('edit.ingredients')}>
        {ingredients.map((l, i) => (
          <View key={i} style={s.line}>
            <TextField
              value={l.raw}
              onChangeText={(v) => setIngredients((all) => all.map((x, j) => (j === i ? { ...x, raw: v } : x)))}
              placeholder={t('edit.ingredientPlaceholder')}
              autoCapitalize="sentences"
              style={{ flex: 1 }}
            />
            <Text
              style={[s.optionalToggle, l.optional && s.optionalOn]}
              onPress={() => setIngredients((all) => all.map((x, j) => (j === i ? { ...x, optional: !x.optional } : x)))}>
              {t('edit.optional')}
            </Text>
            <Text style={s.remove} onPress={() => setIngredients((all) => (all.length > 1 ? all.filter((_, j) => j !== i) : all))}>✕</Text>
          </View>
        ))}
        <Text style={s.add} onPress={() => setIngredients((all) => [...all, { raw: '', optional: false }])}>+ {t('edit.addIngredient')}</Text>
      </Section>

      <Section label={t('edit.steps')}>
        {steps.map((body, i) => (
          <View key={i} style={s.line}>
            <TextInput
              value={body}
              onChangeText={(v) => setSteps((all) => all.map((x, j) => (j === i ? v : x)))}
              placeholder={t('edit.stepPlaceholder', { n: i + 1 })}
              placeholderTextColor={color.muted}
              multiline
              style={[s.area, { flex: 1 }]}
            />
            <Text style={s.remove} onPress={() => setSteps((all) => (all.length > 1 ? all.filter((_, j) => j !== i) : all))}>✕</Text>
          </View>
        ))}
        <Text style={s.add} onPress={() => setSteps((all) => [...all, ''])}>+ {t('edit.addStep')}</Text>
      </Section>

      <Section label={t('edit.declared')}>
        <Text style={s.small}>{t('edit.declaredSub')}</Text>
        <View style={[s.chipsWrap, s.gap]}>
          {FLAGS.map((f) => (
            <Chip
              key={f}
              label={t(`flag.${f}`)}
              selected={declared.includes(f)}
              onPress={() => setDeclared((d) => (d.includes(f) ? d.filter((x) => x !== f) : [...d, f]))}
            />
          ))}
        </View>
      </Section>

      <Section label={t('recipe.visibility')}>
        {VISIBILITIES.map((v) => (
          <Pressable key={v} accessibilityRole="radio" accessibilityState={{ selected: visibility === v }} onPress={() => setVisibility(v)} style={[s.radio, visibility === v && s.radioOn]}>
            <Text style={s.radioLabel}>{t(`visibility.${v}`)}</Text>
            <Text style={s.small}>{t(`visibility.${v}.sub`)}</Text>
          </Pressable>
        ))}
        {source && source.visibility !== 'public' ? (
          <Text style={s.small}>{t('visibility.clamped', { level: t(`visibility.${source.visibility}`) })}</Text>
        ) : null}
      </Section>

      <PrimaryButton label={t('edit.publish')} busy={saving} disabled={!!uploading} onPress={submit} style={s.gapLarge} />
    </Screen>
  );
}

function Section({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <View style={s.section}>
      <SectionHeader label={label} />
      {children}
    </View>
  );
}

function NumberField({ label, value, onChange }: { label: string; value: string; onChange: (v: string) => void }) {
  return (
    <View style={{ flex: 1 }}>
      <Text style={s.small}>{label}</Text>
      <TextField value={value} onChangeText={(v) => onChange(v.replace(/[^0-9]/g, '').slice(0, 4))} keyboardType="number-pad" />
    </View>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12 },
  gap: { marginTop: 10 },
  gapLarge: { marginTop: 22 },
  area: {
    minHeight: 64, borderWidth: 1, borderColor: color.border, borderRadius: radius.md, backgroundColor: color.surface,
    paddingHorizontal: 14, paddingVertical: 10, fontFamily: font.regular, fontSize: 15, color: color.ink, textAlignVertical: 'top',
  },
  section: { marginTop: 24 },
  small: { fontFamily: font.regular, fontSize: 12.5, lineHeight: 18, color: color.mutedWarm, marginBottom: 4 },
  mediaRow: { flexDirection: 'row', gap: 10, marginBottom: 10 },
  thumb: { width: 96, height: 72, borderRadius: radius.md },
  videoThumb: { backgroundColor: color.ink, alignItems: 'center', justifyContent: 'center' },
  play: { color: '#fff', fontSize: 20 },
  mediaButtons: { gap: 8 },
  chips: { gap: 8, paddingRight: 18 },
  chipsWrap: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  numbers: { flexDirection: 'row', gap: 10, marginTop: 24 },
  line: { flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: 8 },
  optionalToggle: { fontFamily: font.medium, fontSize: 11.5, color: color.muted, paddingHorizontal: 6 },
  optionalOn: { color: color.plum },
  remove: { fontSize: 16, color: color.muted, paddingHorizontal: 6 },
  add: { fontFamily: font.semibold, fontSize: 14, color: color.plum, marginTop: 6 },
  radio: { padding: 12, borderRadius: radius.lg, borderWidth: 1, borderColor: color.border, backgroundColor: color.surface, marginBottom: 8 },
  radioOn: { borderColor: color.plum, borderWidth: 2 },
  radioLabel: { fontFamily: font.semibold, fontSize: 14.5, color: color.ink },
});
