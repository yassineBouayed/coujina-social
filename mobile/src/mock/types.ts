/** La forme des données fictives du mode démo (voir tools/seed/fictive.mjs). */
export type MockUser = {
  id: string;
  username: string;
  display_name: string;
  bio: string;
  is_editorial: boolean;
  cuisines: string[];
  exclusions: string[];
  onboarded: boolean;
};

export type MockRecipe = {
  id: string;
  title: string;
  native_name: string | null;
  description: string;
  cuisine: string;
  country: string | null;
  meal_type: string | null;
  difficulty: string;
  prep_min: number | null;
  cook_min: number | null;
  servings: number;
  cover_url: string | null;
  cover_credit: string | null;
  cover_source_url: string | null;
  video_url: string | null;
  author_id: string;
  visibility: string;
  flags: string[];
  hours_ago: number;
  copied_from: string | null;
  credit_author_id: string | null;
  modified_by_id: string | null;
  ingredients: { raw: string; optional: boolean }[];
  steps: string[];
  /** Inscrite au défi de la semaine en cours. */
  in_challenge?: boolean;
};

export type MockData = {
  editorialId: string;
  challenges: { id: string; slug: string; position: number; title: string; description: string; cuisine: string | null }[];
  cuisines: { slug: string; name_fr: string; name_en: string; from: string; to: string }[];
  countries: { slug: string; name_fr: string; name_en: string; flag: string; cuisine: string; lat: number; lng: number }[];
  users: MockUser[];
  follows: [string, string][];
  recipes: MockRecipe[];
  copies: { id: string; source: string; copier: string; hours_ago: number; visibility: string; modified: boolean }[];
  premium: string[];
  moderators: string[];
  families: {
    id: string; name: string; owner: string; code: string; members: string[];
    recipes: { recipe_id: string; added_by: string; note: string }[];
  }[];
  reports: { id: string; reporter: string; recipe_id: string; reason: string; details: string; hours_ago: number }[];
};
