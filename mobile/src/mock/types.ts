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
};

export type MockData = {
  editorialId: string;
  cuisines: { slug: string; name_fr: string; name_en: string; from: string; to: string }[];
  countries: { slug: string; name_fr: string; name_en: string; flag: string; cuisine: string; lat: number; lng: number }[];
  users: MockUser[];
  follows: [string, string][];
  recipes: MockRecipe[];
  copies: { id: string; source: string; copier: string; hours_ago: number; visibility: string; modified: boolean }[];
};
