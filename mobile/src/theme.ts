/**
 * Design tokens for couJina, lifted from the design canvas.
 * Every literal in the screens should come from here.
 *
 * The palette was refreshed with the rename: plum, ember, olive and saffron
 * each moved a notch or two, and the sand and ink grounds went with them. The
 * values below are the charter's, not an approximation of it.
 */

export const color = {
  /** Screen background inside the phone. */
  screen: '#FCF7F0',
  surface: '#FFFFFF',
  /** Muted sand fill used for inline panels and segmented controls. */
  sand: '#F3EAE0',
  sandDeep: '#E7DCCE',

  border: '#EADFD3',
  borderStrong: '#E0D2C2',
  borderDark: '#D8C9B8',
  hairline: '#F3EAE0',
  trackOff: '#DED2C4',

  ink: '#1F1410',
  inkSoft: '#4A3A2E',
  inkMuted: '#5C4B3E',
  inkFaint: '#6B5A4C',
  inkSubtle: '#7B6A5B',
  muted: '#A08F7F',
  mutedWarm: '#8B7A6B',
  tabIdle: '#A99887',

  /** Primary. Onboarding, actions, active tab. */
  plum: '#7C2A55',
  /** Accent. Shopping sessions, anti-waste urgency. */
  ember: '#C65A1A',
  emberTint: '#FDF1E6',
  emberBorder: '#F0C9A8',
  /**
   * The two inks the screens use ON the ember tint, and they are not the same
   * one twice: the canvas sets an action's label at #B04A18 and the sentence
   * underneath it at #8B4A22, so a button reads as a button and the line that
   * explains it stays a line of text. On white the accent itself is the ink —
   * `ember`, never these two. The old single `emberDeep` (#B0522E) is gone: it
   * was neither of the two, and a token nobody uses is a token that will be
   * used wrongly.
   */
  emberInk: '#B04A18',
  emberMeta: '#8B4A22',

  /** Positive. In stock, verified, confirmed. */
  green: '#1D5A3A',
  greenTint: '#E6F0E9',
  amber: '#E0A828',

  unverifiedFg: '#8B7A6B',
  unverifiedBg: '#F1EAE2',
} as const;

/**
 * The colours the mark is allowed to take, named as the charter names them
 * rather than by what they mean inside a screen.
 *
 * `color.plum` and `brand.plum` are the same ink, and that is the point: the
 * logo is not a decoration sitting beside the interface, it is drawn out of
 * the same pots. The split exists so `Logo.tsx` can say "saffron on a dark
 * ground" — a rule about the mark — without borrowing `color.amber`, which is
 * a rule about a pantry running low.
 */
export const brand = {
  plum: '#7C2A55',
  ember: '#C65A1A',
  saffron: '#E0A828',
  sand: '#FCF7F0',
  ink: '#1F1410',
} as const;

/**
 * Two-stop gradients, one per cuisine, standing in for the recipe photo.
 *
 * The database serves the same pair on every catalogue row since J5 — it is a
 * column of `cuisines`, so the image pipeline and the app cannot drift apart.
 * This map is the offline fallback, and what `gradientFor` reaches for when a
 * row arrives without one.
 *
 * Six of the eight moved with the rename. The pairs below are the ones the
 * "couJina app" canvas draws, and they are drawn out of the refreshed pots —
 * ember for the Maghreb and South Asia, plum for East Asia, saffron for Latin
 * America — where the old ones still carried the pre-rename tones. Levantine
 * and Caribbean are unchanged because no canvas draws them yet. The values
 * live in `data/cuisines.psv`; this map only repeats them for the phone.
 */
export const cuisineGradient: Record<string, readonly [string, string]> = {
  maghrebi: ['#C65A1A', '#7A2E1E'],
  'west-african': ['#B8862B', '#5A3A1E'],
  levantine: ['#C2A11A', '#5C4A1E'],
  'south-asian': ['#C65A1A', '#4A1533'],
  caribbean: ['#1F7A5C', '#2E3D5C'],
  french: ['#9AA36F', '#3E4A2E'],
  'east-asian': ['#7C2A55', '#2E1226'],
  'latin-american': ['#E0A828', '#7A2E1E'],
};

/** Cuisines are addressed by slug now — the display name is data, not a key. */
export type CuisineSlug = string;

export const gradientFor = (cuisine: CuisineSlug): readonly [string, string] =>
  cuisineGradient[cuisine] ?? cuisineGradient.maghrebi;

export const font = {
  regular: 'FamiljenGrotesk_400Regular',
  medium: 'FamiljenGrotesk_500Medium',
  semibold: 'FamiljenGrotesk_600SemiBold',
  bold: 'FamiljenGrotesk_700Bold',
  /** Display face. Screen titles and the invite code only. */
  display: 'BricolageGrotesque_700Bold',
} as const;

export const radius = {
  sm: 7,
  md: 13,
  lg: 14,
  xl: 16,
  card: 18,
  pill: 999,
} as const;

