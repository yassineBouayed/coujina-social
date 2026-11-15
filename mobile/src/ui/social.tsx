/** Les pièces propres au réseau social : cartes, crédit, avatars, feuilles de choix. */
import React, { type ReactNode } from 'react';
import { Modal, Pressable, StyleSheet, Text, View, type StyleProp, type ViewStyle } from 'react-native';
import { useRouter } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { useI18n } from '../i18n';
import { useSession } from '../session';
import { color, font, radius } from '../theme';
import type { Person, RecipeCard as Card } from '../types';
import { RecipeImage } from './primitives';

const pressed = ({ pressed: p }: { pressed: boolean }) => ({ opacity: p ? 0.7 : 1 });

const AVATAR_TONES = ['#7C2A55', '#C65A1A', '#1D5A3A', '#B8862B', '#2E3D5C', '#9E2E4A'];

export function Avatar({ person, size = 36 }: { person: Pick<Person, 'id' | 'display_name' | 'username' | 'is_editorial'>; size?: number }) {
  const initial = (person.display_name || person.username || '?').trim().charAt(0).toUpperCase();
  const tone = person.is_editorial
    ? color.plum
    : AVATAR_TONES[[...person.id].reduce((n, ch) => n + ch.charCodeAt(0), 0) % AVATAR_TONES.length];
  return (
    <View style={[s.avatar, { width: size, height: size, borderRadius: size / 2, backgroundColor: tone }]}>
      <Text style={[s.avatarText, { fontSize: size * 0.42 }]}>{initial}</Text>
    </View>
  );
}

/** Un nom qui mène au profil. */
export function PersonLink({ person, style }: { person: Person; style?: object }) {
  const router = useRouter();
  return (
    <Text
      accessibilityRole="link"
      onPress={() => router.push(`/user/${person.id}`)}
      style={[s.link, style]}>
      {person.display_name || `@${person.username}`}
    </Text>
  );
}

/**
 * « Recette de X » ou « Recette de X · modifiée par Y ». Les deux noms sont
 * cliquables. Pour une recette qui n'est pas une copie, X est l'auteur.
 */
export function Attribution({ recipe, small }: { recipe: Card; small?: boolean }) {
  const { t } = useI18n();
  const creator = recipe.credit ?? recipe.author;
  const [before, after] = t('recipe.by', { name: '\u0000' }).split('\u0000');
  const [mBefore, mAfter] = t('recipe.modifiedBy', { name: '\u0000' }).split('\u0000');
  const text = small ? s.attrSmall : s.attr;
  return (
    <Text style={text} numberOfLines={small ? 1 : 2}>
      {before}
      <PersonLink person={creator} style={small ? s.linkSmall : undefined} />
      {after}
      {recipe.modified_by ? (
        <>
          {' · '}
          {mBefore}
          <PersonLink person={recipe.modified_by} style={small ? s.linkSmall : undefined} />
          {mAfter}
        </>
      ) : null}
    </Text>
  );
}

/** Nom d'origine · pays · difficulté · temps, sur une ligne. */
export function RecipeMeta({ recipe, light }: { recipe: Card; light?: boolean }) {
  const { t } = useI18n();
  const parts = [
    recipe.country_name ? `${recipe.country_flag ?? ''} ${recipe.country_name}`.trim() : null,
    t(`difficulty.${recipe.difficulty}`),
    recipe.total_min ? t('common.minutes', { count: recipe.total_min }) : null,
  ].filter(Boolean);
  return <Text style={[s.meta, light && s.metaLight]} numberOfLines={1}>{parts.join('  ·  ')}</Text>;
}

function useGradient(cuisine: string | null): readonly [string, string] | undefined {
  const { cuisines } = useSession();
  const c = cuisines.find((x) => x.slug === cuisine);
  return c ? [c.from, c.to] : undefined;
}

/** La grande carte de l'accueil : photo ou vidéo, nom, origine, difficulté, temps. */
export function RecipeCardView({ recipe, badge, style }: { recipe: Card; badge?: ReactNode; style?: StyleProp<ViewStyle> }) {
  const router = useRouter();
  const gradient = useGradient(recipe.cuisine);
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel={recipe.title}
      onPress={() => router.push(`/recipe/${recipe.id}`)}
      style={(p) => [s.card, pressed(p), style]}>
      <RecipeImage cuisine={recipe.cuisine ?? undefined} gradient={gradient} uri={recipe.cover_url} style={s.cardImage}>
        {recipe.video_url ? (
          <View style={s.play}>
            <Text style={s.playGlyph}>▶</Text>
          </View>
        ) : null}
        {badge ? <View style={s.badge}>{badge}</View> : null}
      </RecipeImage>
      <View style={s.cardBody}>
        <Text style={s.cardTitle} numberOfLines={2}>{recipe.title}</Text>
        {recipe.native_name && recipe.native_name !== recipe.title ? (
          <Text style={s.native} numberOfLines={1}>{recipe.native_name}</Text>
        ) : null}
        <RecipeMeta recipe={recipe} />
        <Attribution recipe={recipe} small />
      </View>
    </Pressable>
  );
}

/** La petite carte, deux par ligne (profils, Mes recettes, pays). */
export function RecipeTile({ recipe, corner, style }: { recipe: Card; corner?: string; style?: StyleProp<ViewStyle> }) {
  const router = useRouter();
  const gradient = useGradient(recipe.cuisine);
  const { t } = useI18n();
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel={recipe.title}
      onPress={() => router.push(`/recipe/${recipe.id}`)}
      style={(p) => [s.tile, pressed(p), style]}>
      <RecipeImage cuisine={recipe.cuisine ?? undefined} gradient={gradient} uri={recipe.cover_url} style={s.tileImage}>
        {recipe.video_url ? <Text style={s.tilePlay}>▶</Text> : null}
        {corner ? <Text style={s.corner}>{corner}</Text> : null}
      </RecipeImage>
      <Text style={s.tileTitle} numberOfLines={2}>{recipe.title}</Text>
      <Text style={s.tileMeta} numberOfLines={1}>
        {[recipe.country_flag, t(`difficulty.${recipe.difficulty}`), recipe.total_min ? t('common.minutes', { count: recipe.total_min }) : null]
          .filter(Boolean)
          .join(' · ')}
      </Text>
    </Pressable>
  );
}

export function TileGrid({ children }: { children: ReactNode }) {
  return <View style={s.grid}>{children}</View>;
}

/** Une rangée de pastilles exclusives (filtres, périodes). */
export function Segmented<T extends string>({
  options, value, onChange, style,
}: {
  options: { value: T; label: string }[];
  value: T;
  onChange: (v: T) => void;
  style?: StyleProp<ViewStyle>;
}) {
  return (
    <View style={[s.segmented, style]}>
      {options.map((o) => {
        const on = o.value === value;
        return (
          <Pressable
            key={o.value}
            accessibilityRole="button"
            accessibilityState={{ selected: on }}
            onPress={() => onChange(o.value)}
            style={[s.segment, on && s.segmentOn]}>
            <Text style={[s.segmentText, on && s.segmentTextOn]} numberOfLines={1}>{o.label}</Text>
          </Pressable>
        );
      })}
    </View>
  );
}

/** Une feuille modale de choix, depuis le bas de l'écran. */
export function OptionSheet<T extends string>({
  visible, title, options, onPick, onClose, note,
}: {
  visible: boolean;
  title: string;
  options: { value: T; label: string; sub?: string; danger?: boolean }[];
  onPick: (v: T) => void;
  onClose: () => void;
  note?: string;
}) {
  const insets = useSafeAreaInsets();
  const { t } = useI18n();
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <Pressable style={s.backdrop} onPress={onClose} accessibilityLabel={t('common.cancel')} />
      <View style={[s.sheet, { paddingBottom: insets.bottom + 14 }]}>
        <Text style={s.sheetTitle}>{title}</Text>
        {note ? <Text style={s.sheetNote}>{note}</Text> : null}
        {options.map((o) => (
          <Pressable key={o.value} accessibilityRole="button" onPress={() => onPick(o.value)} style={(p) => [s.option, pressed(p)]}>
            <Text style={[s.optionLabel, o.danger && { color: color.ember }]}>{o.label}</Text>
            {o.sub ? <Text style={s.optionSub}>{o.sub}</Text> : null}
          </Pressable>
        ))}
        <Pressable accessibilityRole="button" onPress={onClose} style={(p) => [s.option, s.cancel, pressed(p)]}>
          <Text style={s.cancelLabel}>{t('common.cancel')}</Text>
        </Pressable>
      </View>
    </Modal>
  );
}

export function Empty({ children }: { children: ReactNode }) {
  return <Text style={s.empty}>{children}</Text>;
}

export function DemoBanner() {
  const { api } = useSession();
  const { t } = useI18n();
  if (!api || api.live) return null;
  return <Text style={s.demo}>{t('common.demo')}</Text>;
}

const s = StyleSheet.create({
  avatar: { alignItems: 'center', justifyContent: 'center' },
  avatarText: { fontFamily: font.semibold, color: '#fff' },
  link: { fontFamily: font.semibold, color: color.plum },
  linkSmall: { fontFamily: font.medium },
  attr: { fontFamily: font.regular, fontSize: 13.5, lineHeight: 19, color: color.inkSubtle },
  attrSmall: { fontFamily: font.regular, fontSize: 12, color: color.mutedWarm, marginTop: 6 },
  meta: { fontFamily: font.regular, fontSize: 12.5, color: color.inkFaint, marginTop: 5 },
  metaLight: { color: 'rgba(255,255,255,0.85)' },
  card: { borderRadius: radius.card, backgroundColor: color.surface, borderWidth: 1, borderColor: color.border, overflow: 'hidden', marginBottom: 16 },
  cardImage: { height: 190, justifyContent: 'space-between' },
  cardBody: { padding: 14 },
  cardTitle: { fontFamily: font.semibold, fontSize: 17, lineHeight: 22, color: color.ink },
  native: { fontFamily: font.regular, fontSize: 13, color: color.mutedWarm, marginTop: 2, fontStyle: 'italic' },
  play: { position: 'absolute', alignSelf: 'center', top: 70, width: 50, height: 50, borderRadius: 25, backgroundColor: 'rgba(31,20,16,0.55)', alignItems: 'center', justifyContent: 'center' },
  playGlyph: { color: '#fff', fontSize: 20, marginLeft: 3 },
  badge: { position: 'absolute', top: 12, left: 12 },
  tile: { width: '48%', marginBottom: 16 },
  tileImage: { height: 120, borderRadius: radius.lg, overflow: 'hidden' },
  tilePlay: { position: 'absolute', right: 8, bottom: 6, color: '#fff', fontSize: 16 },
  corner: {
    position: 'absolute', left: 8, top: 8, backgroundColor: 'rgba(31,20,16,0.6)', color: '#fff',
    fontFamily: font.semibold, fontSize: 10.5, paddingHorizontal: 7, paddingVertical: 3, borderRadius: 6, overflow: 'hidden',
  },
  tileTitle: { fontFamily: font.semibold, fontSize: 14, lineHeight: 18, color: color.ink, marginTop: 7 },
  tileMeta: { fontFamily: font.regular, fontSize: 11.5, color: color.mutedWarm, marginTop: 3 },
  grid: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-between' },
  segmented: { flexDirection: 'row', backgroundColor: color.sand, borderRadius: radius.pill, padding: 3 },
  segment: { flex: 1, paddingVertical: 8, borderRadius: radius.pill, alignItems: 'center' },
  segmentOn: { backgroundColor: color.surface },
  segmentText: { fontFamily: font.medium, fontSize: 13, color: color.inkFaint },
  segmentTextOn: { color: color.plum, fontFamily: font.semibold },
  backdrop: { flex: 1, backgroundColor: 'rgba(31,20,16,0.35)' },
  sheet: { backgroundColor: color.screen, borderTopLeftRadius: 22, borderTopRightRadius: 22, paddingHorizontal: 18, paddingTop: 18 },
  sheetTitle: { fontFamily: font.semibold, fontSize: 16, color: color.ink, marginBottom: 8 },
  sheetNote: { fontFamily: font.regular, fontSize: 12.5, lineHeight: 18, color: color.mutedWarm, marginBottom: 8 },
  option: { paddingVertical: 13, borderTopWidth: 1, borderTopColor: color.hairline },
  optionLabel: { fontFamily: font.medium, fontSize: 15, color: color.ink },
  optionSub: { fontFamily: font.regular, fontSize: 12.5, color: color.mutedWarm, marginTop: 2 },
  cancel: { alignItems: 'center' },
  cancelLabel: { fontFamily: font.semibold, fontSize: 15, color: color.inkFaint },
  empty: { fontFamily: font.regular, fontSize: 13.5, lineHeight: 20, color: color.mutedWarm, textAlign: 'center', marginVertical: 30 },
  demo: {
    fontFamily: font.medium, fontSize: 11.5, color: color.emberInk, backgroundColor: color.emberTint,
    paddingVertical: 6, paddingHorizontal: 10, borderRadius: radius.md, marginBottom: 12, alignSelf: 'flex-start', overflow: 'hidden',
  },
});
