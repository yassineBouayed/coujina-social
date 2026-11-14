/** Layout and typography primitives shared by every screen. */
import React, { useEffect, useRef, type ReactElement, type ReactNode } from 'react';
import {
  Animated,
  Easing,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  View,
  type RefreshControlProps,
  type StyleProp,
  type TextStyle,
  type ViewStyle,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { color, font, gradientFor, radius, type CuisineSlug } from '../theme';

/** The screen-entry animation from the design: 8px rise, 320ms. */
export function FadeIn({ children, style }: { children: ReactNode; style?: StyleProp<ViewStyle> }) {
  const t = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(t, {
      toValue: 1,
      duration: 320,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
  }, [t]);

  return (
    <Animated.View
      style={[
        style,
        { opacity: t, transform: [{ translateY: t.interpolate({ inputRange: [0, 1], outputRange: [8, 0] }) }] },
      ]}>
      {children}
    </Animated.View>
  );
}

/** Scrolling body of a screen. Horizontal padding matches the design's 22px. */
export function Screen({
  children,
  padded = true,
  /** Set false when the screen paints its own header up under the status bar. */
  topInset = true,
  contentStyle,
  /** A `<RefreshControl>` for the screens where pulling down means something. */
  refreshControl,
}: {
  children: ReactNode;
  /** Set false when a section needs to bleed to the edge (carousels, headers). */
  padded?: boolean;
  topInset?: boolean;
  contentStyle?: StyleProp<ViewStyle>;
  refreshControl?: ReactElement<RefreshControlProps>;
}) {
  const insets = useSafeAreaInsets();
  return (
    <ScrollView
      style={s.screen}
      contentContainerStyle={[
        { paddingTop: (topInset ? insets.top : 0) + 14, paddingBottom: 30 },
        padded && { paddingHorizontal: 22 },
        contentStyle,
      ]}
      refreshControl={refreshControl}
      showsVerticalScrollIndicator={false}>
      <FadeIn>{children}</FadeIn>
    </ScrollView>
  );
}

export function Title({ children, style }: { children: ReactNode; style?: StyleProp<TextStyle> }) {
  return <Text style={[s.title, style]}>{children}</Text>;
}

export function Subtitle({ children, style }: { children: ReactNode; style?: StyleProp<TextStyle> }) {
  return <Text style={[s.subtitle, style]}>{children}</Text>;
}

/** Uppercase section label. `tone` picks the plum default or the specialty ember. */
export function Eyebrow({
  children,
  tone = color.plum,
  style,
}: {
  children: ReactNode;
  tone?: string;
  style?: StyleProp<TextStyle>;
}) {
  return <Text style={[s.eyebrow, { color: tone }, style]}>{children}</Text>;
}

export function SectionHeader({
  label,
  hint,
  tone,
  right,
}: {
  label: string;
  hint?: string;
  tone?: string;
  right?: ReactNode;
}) {
  return (
    <View style={s.sectionHeader}>
      <View style={s.sectionHeaderLeft}>
        <Eyebrow tone={tone}>{label}</Eyebrow>
        {hint ? <Text style={s.hint}>{hint}</Text> : null}
      </View>
      {right}
    </View>
  );
}

/** White rounded container. Children are separated by hairlines, as in the design. */
export function Card({ children, style }: { children: ReactNode; style?: StyleProp<ViewStyle> }) {
  return <View style={[s.card, style]}>{children}</View>;
}

/** One row of a `Card`. The first row drops the top hairline. */
export function CardRow({
  children,
  first,
  style,
}: {
  children: ReactNode;
  first?: boolean;
  style?: StyleProp<ViewStyle>;
}) {
  return <View style={[s.cardRow, first && s.cardRowFirst, style]}>{children}</View>;
}

/** Sand-filled explanatory panel. Used for the spec's "this is a help, not a guarantee" notes. */
export function Note({ children, style }: { children: ReactNode; style?: StyleProp<ViewStyle> }) {
  return (
    <View style={[s.note, style]}>
      <Text style={s.noteText}>{children}</Text>
    </View>
  );
}

/**
 * The recipe photo, or the cuisine's gradient when there is no photo.
 *
 * J5 built the whole image chain — three sizes, a predictable storage path, a
 * seed that knows which file is which — but every file it has produced so far
 * is a placeholder, and the database says so (`image_is_placeholder`). So the
 * gradient stays, and `uri` is passed only for an image that is a real one.
 * Painting a flat wash and calling it a photo would be the easiest lie in the
 * app to tell.
 */
export function RecipeImage({
  cuisine,
  gradient,
  uri,
  style,
  children,
}: {
  cuisine?: CuisineSlug;
  /** Straight off the catalogue row; falls back to the map in `theme`. */
  gradient?: readonly [string, string];
  uri?: string | null;
  style?: StyleProp<ViewStyle>;
  children?: ReactNode;
}) {
  const [from, to] = gradient ?? gradientFor(cuisine ?? 'maghrebi');
  return (
    <LinearGradient colors={[from, to]} start={{ x: 0.15, y: 0 }} end={{ x: 0.85, y: 1 }} style={style}>
      {uri ? <Image source={{ uri }} style={StyleSheet.absoluteFill} resizeMode="cover" /> : null}
      {children}
    </LinearGradient>
  );
}

const s = StyleSheet.create({
  screen: { flex: 1, backgroundColor: color.screen },
  title: { fontFamily: font.display, fontSize: 27, lineHeight: 30, letterSpacing: -0.54, color: color.ink },
  // Warm grey, not the pale one. The canvas keeps #A08F7F for what is spent —
  // a bought line struck through, a caption under a number — and sets every
  // sentence that a screen still expects you to read one notch darker.
  subtitle: { fontFamily: font.regular, fontSize: 13, lineHeight: 18, color: color.mutedWarm, marginTop: 4 },
  eyebrow: {
    fontFamily: font.semibold,
    fontSize: 11,
    letterSpacing: 1.5,
    textTransform: 'uppercase',
  },
  sectionHeader: { flexDirection: 'row', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 8 },
  sectionHeaderLeft: { flexDirection: 'row', alignItems: 'baseline', gap: 8, flexShrink: 1 },
  hint: { fontFamily: font.regular, fontSize: 12, color: color.mutedWarm, flexShrink: 1 },
  card: {
    borderWidth: 1,
    borderColor: color.border,
    borderRadius: radius.lg,
    backgroundColor: color.surface,
    overflow: 'hidden',
  },
  cardRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 11,
    paddingVertical: 12,
    paddingHorizontal: 13,
    borderTopWidth: 1,
    borderTopColor: color.hairline,
  },
  cardRowFirst: { borderTopWidth: 0 },
  note: { padding: 14, borderRadius: radius.lg, backgroundColor: color.sand },
  noteText: { fontFamily: font.regular, fontSize: 12.5, lineHeight: 19, color: color.inkSubtle },
});
