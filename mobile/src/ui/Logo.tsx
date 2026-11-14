/**
 * The couJina mark — the J-louche — and the wordmark that goes with it.
 *
 * The brand is one letter and one drop: the J *is* the ladle, and the drop is
 * the dot of the i, moved. The charter draws it on a 64 grid as a single
 * 7-wide stroke with round caps — a straight stem, a hook of radius 10 that
 * closes it from below, and a drop of radius 4 resting in the hollow.
 *
 *   <path d="M42 15v20a10 10 0 0 1-20 0" stroke-width="7" stroke-linecap="round">
 *   <circle cx="32" cy="33" r="4">
 *
 * Those are the same numbers `tools/brand/logo.mjs` rasterises into the app
 * icons, and this file is the on-screen half of that one definition. It is
 * drawn with plain views rather than an SVG runtime: the shape is a rounded
 * bar, a clipped ring and two discs, so the whole mark costs four views and
 * no native module. A logo that needs a dependency is a logo that disappears
 * the day the dependency does.
 *
 * The colour rule is the charter's, and it lives here so no screen has to
 * remember it: on a light ground the J takes plum and the drop ember, on a
 * dark ground both take saffron, on the plum ground the J takes sand and the
 * drop saffron, on a photograph the whole signature turns white. The drop
 * falls in exactly two cases — the monochrome variant, and below 24px, where
 * it would close the hook rather than sit in it.
 */
import React from 'react';
import { StyleSheet, Text, View, type StyleProp, type TextStyle, type ViewStyle } from 'react-native';

import { brand, color, font } from '../theme';

/** Which ground the mark is standing on. The colours follow from it. */
export type LogoOn = 'light' | 'dark' | 'plum' | 'photo' | 'mono';

/** The charter's floor. At 24 the stroke thins; below it the drop falls. */
const SMALL = 24;

const TONES: Record<LogoOn, { ink: string; drop: string | null }> = {
  light: { ink: brand.plum, drop: brand.ember },
  dark: { ink: brand.saffron, drop: brand.saffron },
  // The plum ground is its own case in the charter, and it has to be: plum on
  // plum is nothing, and the saffron of the dark ground would put the app
  // icon's own two colours the wrong way round. "Sur prune : J sable, goutte
  // safran" — it is the tile the icon is exported from.
  plum: { ink: brand.sand, drop: brand.saffron },
  photo: { ink: '#FFFFFF', drop: '#FFFFFF' },
  mono: { ink: color.ink, drop: null },
};

export function Logo({
  size = 40,
  on = 'light',
  /** Overrides the tone's ink — for a ground the four tones do not name. */
  ink,
  style,
}: {
  size?: number;
  on?: LogoOn;
  ink?: string;
  style?: StyleProp<ViewStyle>;
}) {
  const tone = TONES[on];
  const stroke = size <= SMALL ? 5.5 : 7;
  const drop = size < SMALL ? null : tone.drop;

  // One grid unit in pixels. Every number below is a charter coordinate.
  const u = size / 64;
  const half = stroke / 2;
  const outer = 10 + half; // the hook's outer radius

  return (
    <View style={[{ width: size, height: size }, style]}>
      {/* The stem, from (42,15) down to the hook. Round on top, flat where it
          meets the ring — a rounded foot would leave a notch at the join.
          It runs half a unit PAST y=35 and finishes under the ring rather
          than butting against it: two edges that merely touch are at the
          mercy of how each one rounds to a physical pixel, and half a unit
          is still well inside the hook's outer radius. */}
      <View
        style={{
          position: 'absolute',
          left: (42 - half) * u,
          top: (15 - half) * u,
          width: stroke * u,
          height: (35 - 15 + half + 0.5) * u,
          borderTopLeftRadius: half * u,
          borderTopRightRadius: half * u,
          backgroundColor: ink ?? tone.ink,
        }}
      />

      {/* The hook: a full ring, clipped to its lower half. */}
      <View
        style={{
          position: 'absolute',
          left: (32 - outer) * u,
          top: 35 * u,
          width: outer * 2 * u,
          height: outer * u,
          overflow: 'hidden',
        }}>
        <View
          style={{
            position: 'absolute',
            top: -outer * u,
            width: outer * 2 * u,
            height: outer * 2 * u,
            borderRadius: outer * u,
            borderWidth: stroke * u,
            borderColor: ink ?? tone.ink,
          }}
        />
      </View>

      {/* The round cap that closes the hook at (22,35). Its lower half falls
          on the ring, which is the same colour; its upper half is the cap. */}
      <View
        style={{
          position: 'absolute',
          left: (22 - half) * u,
          top: (35 - half) * u,
          width: stroke * u,
          height: stroke * u,
          borderRadius: half * u,
          backgroundColor: ink ?? tone.ink,
        }}
      />

      {drop ? (
        <View
          style={{
            position: 'absolute',
            left: 28 * u,
            top: 29 * u,
            width: 8 * u,
            height: 8 * u,
            borderRadius: 4 * u,
            backgroundColor: drop,
          }}
        />
      ) : null}
    </View>
  );
}

/**
 * The name, set the one way it is ever set: lowercase, with a capital J that
 * carries the mark's colour. No "Coujina", no "COUJINA" — the brand is already
 * in the word, and the J is what makes it a ladle.
 */
export function Wordmark({
  size = 26,
  on = 'light',
  style,
}: {
  size?: number;
  on?: LogoOn;
  style?: StyleProp<TextStyle>;
}) {
  // The name takes saffron on plum where the mark takes sand: a sand J inside
  // a sand word would disappear, and the charter's own tile sets it in saffron.
  const j = on === 'light' ? brand.plum : on === 'mono' ? color.ink : on === 'photo' ? '#FFFFFF' : brand.saffron;
  const rest = on === 'light' || on === 'mono' ? color.ink : '#FFFFFF';

  return (
    <Text style={[s.word, { fontSize: size, letterSpacing: size * -0.031, color: rest }, style]}>
      cou<Text style={{ color: j }}>J</Text>ina
    </Text>
  );
}

/** The mark and the name, side by side, spaced as the charter signs them. */
export function Signature({
  size = 30,
  on = 'light',
  style,
}: {
  size?: number;
  on?: LogoOn;
  style?: StyleProp<ViewStyle>;
}) {
  return (
    <View style={[s.signature, { gap: size * 0.3 }, style]}>
      <Logo size={size} on={on} />
      <Wordmark size={size * 0.73} on={on} />
    </View>
  );
}

const s = StyleSheet.create({
  word: { fontFamily: font.display },
  signature: { flexDirection: 'row', alignItems: 'center' },
});
