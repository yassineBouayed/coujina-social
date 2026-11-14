import React, { useEffect, useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useVideoPlayer, VideoView } from 'expo-video';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font, radius } from '../../src/theme';
import { VISIBILITIES, type RecipeDetail, type ReportReason, type Visibility } from '../../src/types';
import { confirm } from '../../src/ui/confirm';
import { BackButton, PrimaryButton, SecondaryButton } from '../../src/ui/controls';
import { RecipeImage, Screen, SectionHeader } from '../../src/ui/primitives';
import { Attribution, Empty, OptionSheet, RecipeMeta } from '../../src/ui/social';

const REASONS: ReportReason[] = ['spam', 'offensive', 'copyright', 'dangerous', 'other'];

function Video({ uri }: { uri: string }) {
  const player = useVideoPlayer(uri, (p) => {
    p.loop = false;
  });
  return <VideoView player={player} style={s.video} nativeControls contentFit="cover" allowsPictureInPicture={false} />;
}

/**
 * La fiche d'une recette. Pour une recette d'un autre : « Enregistrer »
 * (copie telle quelle) et « Copier et modifier ». Pour la mienne : modifier,
 * choisir qui la voit, supprimer.
 */
export default function RecipeScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const { t, tn } = useI18n();
  const { toast } = useStore();
  const { api, me, cuisines, bump, version } = useSession();
  const [recipe, setRecipe] = useState<RecipeDetail | null | undefined>(undefined);
  const [sheet, setSheet] = useState<'none' | 'save' | 'visibility' | 'report'>('none');
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    if (!api || !id) return;
    api.recipe(id).then(setRecipe).catch(() => setRecipe(null));
  }, [api, id, version]);

  if (recipe === undefined) {
    return <Screen><BackButton onPress={() => router.back()} /><ActivityIndicator color={color.plum} /></Screen>;
  }
  if (recipe === null) {
    return <Screen><BackButton onPress={() => router.back()} /><Empty>{t('recipe.notFound')}</Empty></Screen>;
  }

  const mine = recipe.author.id === me?.id;
  const c = cuisines.find((x) => x.slug === recipe.cuisine);
  const visibilityOptions = VISIBILITIES.map((v) => ({ value: v, label: t(`visibility.${v}`), sub: t(`visibility.${v}.sub`) }));

  const save = async (visibility: Visibility) => {
    if (!api) return;
    setSheet('none');
    setBusy(true);
    try {
      const copyId = await api.copy(recipe.id, visibility);
      bump();
      toast(t('recipe.saved'));
      router.push(`/recipe/${copyId}`);
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setBusy(false);
    }
  };

  const changeVisibility = async (visibility: Visibility) => {
    if (!api) return;
    setSheet('none');
    try {
      const applied = await api.setVisibility(recipe.id, visibility);
      if (applied !== visibility) toast(t('visibility.clamped', { level: t(`visibility.${applied}`) }));
      setRecipe({ ...recipe, visibility: applied });
      bump();
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    }
  };

  const remove = () =>
    confirm(t('recipe.deleteConfirm'), { ok: t('common.delete'), cancel: t('common.cancel') }, () => {
      api
        ?.remove(recipe.id)
        .then(() => {
          bump();
          toast(t('recipe.deleted'));
          router.back();
        })
        .catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
    });

  const contains = recipe.flags.map((f) => t(`flag.${f}`)).join(', ');

  return (
    <Screen padded={false} topInset={false}>
      {recipe.video_url ? (
        <Video uri={recipe.video_url} />
      ) : (
        <RecipeImage cuisine={recipe.cuisine ?? undefined} gradient={c ? [c.from, c.to] : undefined} uri={recipe.cover_url} style={s.hero} />
      )}
      <View style={s.back}>
        <BackButton onDark onPress={() => router.back()} />
      </View>

      <View style={s.body}>
        <Text style={s.title}>{recipe.title}</Text>
        {recipe.native_name && recipe.native_name !== recipe.title ? <Text style={s.native}>{recipe.native_name}</Text> : null}
        <RecipeMeta recipe={recipe} />
        <View style={s.attr}>
          <Attribution recipe={recipe} />
        </View>
        <Text style={s.small}>
          {[
            t(`visibility.${recipe.visibility}`),
            recipe.copies_count ? tn('recipe.copies', recipe.copies_count) : null,
            t('recipe.servingsCount', { count: recipe.servings }),
          ].filter(Boolean).join('  ·  ')}
        </Text>

        <View style={s.actions}>
          {mine ? (
            <>
              <PrimaryButton label={t('common.edit')} onPress={() => router.push({ pathname: '/recipe/edit', params: { id: recipe.id } })} />
              <SecondaryButton label={`${t('recipe.visibility')} : ${t(`visibility.${recipe.visibility}`)}`} onPress={() => setSheet('visibility')} />
            </>
          ) : (
            <>
              <PrimaryButton label={t('recipe.save')} busy={busy} onPress={() => setSheet('save')} />
              <SecondaryButton label={t('recipe.copyEdit')} onPress={() => router.push({ pathname: '/recipe/edit', params: { from: recipe.id } })} />
            </>
          )}
        </View>

        {recipe.description ? <Text style={s.description}>{recipe.description}</Text> : null}
        {contains ? <Text style={s.contains}>{t('recipe.contains', { list: contains })}</Text> : null}

        <View style={s.section}>
          <SectionHeader
            label={t('recipe.ingredients')}
            hint={[recipe.prep_min ? t('recipe.prep', { count: recipe.prep_min }) : null, recipe.cook_min ? t('recipe.cook', { count: recipe.cook_min }) : null].filter(Boolean).join(' · ')}
          />
          {recipe.ingredients.map((l, i) => (
            <Text key={i} style={s.ingredient}>
              •  {l.raw}
              {l.optional ? <Text style={s.optional}>  ({t('recipe.optional')})</Text> : null}
            </Text>
          ))}
        </View>

        <View style={s.section}>
          <SectionHeader label={t('recipe.steps')} />
          {recipe.steps.map((step, i) => (
            <View key={i} style={s.step}>
              <Text style={s.stepN}>{i + 1}</Text>
              <Text style={s.stepText}>{step.body}</Text>
            </View>
          ))}
        </View>

        {mine ? (
          <Text style={s.danger} onPress={remove}>{t('common.delete')}</Text>
        ) : (
          <Text style={s.report} onPress={() => setSheet('report')}>{t('recipe.report')}</Text>
        )}
      </View>

      <OptionSheet
        visible={sheet === 'save'}
        title={t('recipe.saveSheet')}
        note={recipe.visibility !== 'public' ? t('visibility.clamped', { level: t(`visibility.${recipe.visibility}`) }) : undefined}
        options={visibilityOptions}
        onPick={save}
        onClose={() => setSheet('none')}
      />
      <OptionSheet
        visible={sheet === 'visibility'}
        title={t('recipe.visibility')}
        options={visibilityOptions}
        onPick={changeVisibility}
        onClose={() => setSheet('none')}
      />
      <OptionSheet
        visible={sheet === 'report'}
        title={t('report.title')}
        options={REASONS.map((r) => ({ value: r, label: t(`report.${r}`) }))}
        onPick={(reason) => {
          setSheet('none');
          api?.report({ recipeId: recipe.id }, reason).then(() => toast(t('recipe.reported')))
            .catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
        }}
        onClose={() => setSheet('none')}
      />
    </Screen>
  );
}

const s = StyleSheet.create({
  hero: { height: 300 },
  video: { width: '100%', height: 300, backgroundColor: '#000' },
  back: { position: 'absolute', top: 48, left: 16 },
  body: { paddingHorizontal: 22, paddingTop: 18 },
  title: { fontFamily: font.display, fontSize: 26, lineHeight: 30, letterSpacing: -0.4, color: color.ink },
  native: { fontFamily: font.regular, fontSize: 15, color: color.mutedWarm, fontStyle: 'italic', marginTop: 3 },
  attr: { marginTop: 10 },
  small: { fontFamily: font.regular, fontSize: 12.5, color: color.mutedWarm, marginTop: 6 },
  actions: { gap: 10, marginTop: 18 },
  description: { fontFamily: font.regular, fontSize: 14.5, lineHeight: 21, color: color.inkSoft, marginTop: 20 },
  contains: {
    fontFamily: font.medium, fontSize: 12.5, color: color.emberMeta, backgroundColor: color.emberTint,
    padding: 10, borderRadius: radius.md, marginTop: 14, overflow: 'hidden',
  },
  section: { marginTop: 26 },
  ingredient: { fontFamily: font.regular, fontSize: 15, lineHeight: 23, color: color.ink },
  optional: { color: color.mutedWarm, fontSize: 13 },
  step: { flexDirection: 'row', gap: 12, marginBottom: 14 },
  stepN: { fontFamily: font.bold, fontSize: 15, color: color.plum, width: 20 },
  stepText: { flex: 1, fontFamily: font.regular, fontSize: 15, lineHeight: 22, color: color.ink },
  danger: { fontFamily: font.semibold, fontSize: 14, color: color.ember, textAlign: 'center', marginVertical: 26 },
  report: { fontFamily: font.medium, fontSize: 13, color: color.mutedWarm, textAlign: 'center', marginVertical: 26 },
});
