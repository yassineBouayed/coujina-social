/** Le vocabulaire partagé par les écrans, l'API Supabase et le mode démo. */

export type Flag =
  | 'meat' | 'pork' | 'alcohol' | 'gluten' | 'peanut'
  | 'tree_nut' | 'dairy' | 'egg' | 'fish' | 'shellfish';

/** L'ordre dans lequel les écrans les montrent. */
export const FLAGS: Flag[] = [
  'meat', 'pork', 'fish', 'shellfish', 'alcohol', 'gluten', 'dairy', 'egg', 'peanut', 'tree_nut',
];

/** Raccourcis du deuxième écran du premier lancement. */
export const DIET_PRESETS: { key: 'vegetarian' | 'vegan' | 'noPorkAlcohol'; flags: Flag[] }[] = [
  { key: 'vegetarian', flags: ['meat', 'pork', 'fish', 'shellfish'] },
  { key: 'vegan', flags: ['meat', 'pork', 'fish', 'shellfish', 'dairy', 'egg'] },
  { key: 'noPorkAlcohol', flags: ['pork', 'alcohol'] },
];

export type Visibility = 'public' | 'followers' | 'private';
export const VISIBILITIES: Visibility[] = ['public', 'followers', 'private'];
export type Difficulty = 'easy' | 'medium' | 'hard';
export const DIFFICULTIES: Difficulty[] = ['easy', 'medium', 'hard'];
export type Period = 'day' | 'week' | 'month';
export type FeedKind = 'all' | 'photo' | 'video';
export type ReportReason = 'spam' | 'offensive' | 'copyright' | 'dangerous' | 'allergen_missing' | 'other';

/** La version des CGU et de la politique de confidentialité en vigueur (même valeur qu'en SQL). */
export const TERMS_VERSION = '2026-11-15';

export type Person = {
  id: string;
  username: string;
  display_name: string;
  avatar_url: string | null;
  is_editorial: boolean;
};

export type RecipeCard = {
  id: string;
  title: string;
  native_name: string | null;
  cuisine: string | null;
  country: string | null;
  country_name: string | null;
  country_flag: string | null;
  difficulty: Difficulty;
  total_min: number;
  cover_url: string | null;
  /** Crédit obligatoire d'une photo qui n'est pas de l'auteur (Wikimedia…). */
  cover_credit: string | null;
  cover_source_url: string | null;
  video_url: string | null;
  visibility: Visibility;
  /** Motif d'un masquage par la modération, lu par l'auteur seul (DSA). */
  moderation_reason: string | null;
  flags: Flag[];
  copies_count: number;
  created_at: string;
  copied_from: string | null;
  author: Person;
  /** Le créateur d'origine, quand la recette vient d'une autre. */
  credit: Person | null;
  /** Qui a modifié la version que l'on lit. */
  modified_by: Person | null;
};

export type RecipeDetail = RecipeCard & {
  description: string;
  meal_type: string | null;
  prep_min: number | null;
  cook_min: number | null;
  servings: number;
  declared_flags: Flag[];
  ingredients: { raw: string; optional: boolean }[];
  steps: { body: string }[];
};

export type RecipeInput = {
  title: string;
  native_name: string;
  description: string;
  cuisine: string | null;
  country: string | null;
  meal_type: string | null;
  difficulty: Difficulty;
  prep_min: number | null;
  cook_min: number | null;
  servings: number;
  visibility: Visibility;
  cover_url: string | null;
  video_url: string | null;
  declared_flags: Flag[];
  ingredients: { raw: string; optional: boolean }[];
  steps: { body: string }[];
};

export type Profile = Person & {
  bio: string;
  followers: number;
  following: number;
  recipes: number;
  is_following: boolean;
  follows_me: boolean;
  is_me: boolean;
};

export type Me = Person & {
  bio: string;
  onboarded: boolean;
  analytics_opt_out: boolean;
  /** Version des CGU acceptée, null si jamais. */
  terms_version: string | null;
  /** Consentement explicite aux interdits alimentaires (RGPD art. 9). */
  diet_consent: boolean;
  is_premium: boolean;
  is_moderator: boolean;
  notify: { copies: boolean; follows: boolean; challenge: boolean };
  cuisines: string[];
  exclusions: Flag[];
};

export type Cuisine = { slug: string; name: string; from: string; to: string };
export type Country = {
  slug: string;
  name: string;
  flag: string;
  cuisine: string;
  lat: number;
  lng: number;
  recipe_count: number;
};

export type Ranked = { rank: number; period_copies: number; recipe: RecipeCard };

/**
 * Le contrat unique. `api.supabase.ts` le tient contre la vraie base,
 * `api.mock.ts` contre les données fictives, sans réseau.
 */
export interface Api {
  readonly live: boolean;
  cuisines(): Promise<Cuisine[]>;
  me(): Promise<Me | null>;
  onboard(cuisines: string[], exclusions: Flag[]): Promise<void>;
  updateProfile(patch: { username?: string; display_name?: string; bio?: string; avatar_url?: string | null }): Promise<void>;
  feed(offset: number, kind: FeedKind): Promise<RecipeCard[]>;
  trending(period: Period, cuisine: string | null, respectDiet: boolean): Promise<Ranked[]>;
  globe(): Promise<Country[]>;
  countryRecipes(country: string): Promise<RecipeCard[]>;
  recipe(id: string): Promise<RecipeDetail | null>;
  copy(id: string, visibility: Visibility): Promise<string>;
  save(id: string | null, input: RecipeInput, copiedFrom: string | null): Promise<string>;
  setVisibility(id: string, visibility: Visibility): Promise<Visibility>;
  remove(id: string): Promise<void>;
  profile(userId: string): Promise<Profile | null>;
  userRecipes(userId: string): Promise<RecipeCard[]>;
  follow(userId: string): Promise<void>;
  unfollow(userId: string): Promise<void>;
  block(userId: string): Promise<void>;
  report(target: { recipeId?: string; profileId?: string }, reason: ReportReason): Promise<void>;
  searchProfiles(query: string): Promise<Person[]>;
  upload(localUri: string, kind: 'photo' | 'video', mime: string | null): Promise<string>;
  deleteAccount(): Promise<void>;

  // La mesure de la bêta : ouvertures, vues, et la question du prix.
  track(name: EventName, recipeId?: string): Promise<void>;
  setAnalyticsOptOut(optOut: boolean): Promise<void>;
  priceSurvey(): Promise<{ due: boolean; price_cents: number }>;
  answerPriceSurvey(answer: PriceAnswer, wants: string): Promise<void>;

  // Le réseau encore vide : défi de la semaine, qui suivre, activité, invitation.
  challenge(): Promise<Challenge | null>;
  challengeEntries(): Promise<RecipeCard[]>;
  joinChallenge(recipeId: string): Promise<void>;
  whoToFollow(): Promise<Suggestion[]>;
  activity(): Promise<Activity[]>;
  activityUnread(): Promise<number>;
  markActivitySeen(): Promise<void>;
  profileByUsername(username: string): Promise<string | null>;

  // Conformité : CGU et âge, consentement aux interdits, notifications.
  acceptTerms(isOver15: boolean): Promise<void>;
  giveDietConsent(): Promise<void>;
  withdrawDietConsent(): Promise<void>;
  setNotify(patch: Partial<Me['notify']>): Promise<void>;
  registerPushToken(token: string, platform: string): Promise<void>;

  // Modération (équipe seulement).
  moderationQueue(): Promise<ModerationItem[]>;
  hideRecipe(recipeId: string, reason: string): Promise<void>;
  dismissReport(reportId: string): Promise<void>;
  opsWeekly(): Promise<OpsWeek[]>;

  // Le livre de famille (premium).
  myFamilies(): Promise<Family[]>;
  createFamily(name: string): Promise<string>;
  joinFamily(code: string): Promise<string>;
  leaveFamily(bookId: string): Promise<void>;
  addToFamily(bookId: string, recipeId: string, note: string): Promise<void>;
  familyRecipes(bookId: string): Promise<FamilyRecipe[]>;
}

export type ModerationItem = {
  report_id: string;
  reason: ReportReason;
  details: string;
  age_hours: number;
  recipe_id: string | null;
  recipe_title: string | null;
  recipe_author: string | null;
  profile_username: string | null;
  reporter_username: string;
};
export type OpsWeek = {
  week_start: string;
  received: number;
  resolved: number;
  still_open: number;
  median_hours: number | null;
  within_24h: number;
  hidden_recipes: number;
};
export type Family = {
  id: string;
  name: string;
  invite_code: string | null;
  is_owner: boolean;
  members: number;
  recipes: number;
  owner_premium: boolean;
};
export type FamilyRecipe = { note: string; added_by_name: string; recipe: RecipeCard };

export type EventName = 'app_open' | 'recipe_view' | 'video_play' | 'share_invite';
export type PriceAnswer = 'yes' | 'maybe' | 'no';
export type Challenge = { id: string; slug: string; title: string; description: string; cuisine: string | null };
export type Suggestion = Person & { shared_cuisines: number; public_recipes: number };
export type Activity = {
  kind: 'follow' | 'copy' | 'copy_modified';
  at: string;
  actor: Person;
  recipe_id: string | null;
  recipe_title: string | null;
  is_new: boolean;
};
