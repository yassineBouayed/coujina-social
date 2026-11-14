/**
 * Le mode démo : l'API entière, en mémoire, sur les données fictives de
 * `mock/mock.generated.ts` (npm run seed:fictive). Aucune requête réseau,
 * rien n'est conservé au redémarrage.
 *
 * Les règles sont les MÊMES que celles du SQL — visibilité, interdits,
 * crédit, borne de visibilité d'une copie, classements à fenêtre glissante —
 * redites ici en TypeScript. Le SQL fait foi : c'est lui que `npm run db:test`
 * vérifie ; ce fichier ne sert qu'à cliquer l'application sans projet.
 */
import { MOCK } from './mock/mock.generated';
import type { MockRecipe } from './mock/types';
import type {
  Api, Country, Cuisine, FeedKind, Flag, Me, Period, Person, Profile, Ranked,
  RecipeCard, RecipeDetail, RecipeInput, Visibility,
} from './types';

type Lang = 'fr' | 'en';
const RANK: Record<Visibility, number> = { private: 0, followers: 1, public: 2 };
const clamp = (wanted: Visibility, source: Visibility) => (RANK[wanted] > RANK[source] ? source : wanted);
const HOUR = 3600 * 1000;

let counter = 0;
const newId = () => `demo-${Date.now().toString(36)}-${(counter++).toString(36)}`;

/** Une détection d'interdits volontairement grossière : le mode démo n'a pas le référentiel. */
const WORDS: [RegExp, Flag[]][] = [
  [/\b(porc|lardons?|jambon|chorizo|bacon|saucisses?)\b/i, ['pork', 'meat']],
  [/\b(b(œ|oe)uf|veau|agneau|poulet|canard|dinde|viande|merguez)\b/i, ['meat']],
  [/\b(poissons?|thon|saumon|morue|cabillaud)\b/i, ['fish']],
  [/\b(crevettes?|crabes?|moules?|calamars?)\b/i, ['shellfish']],
  [/\b(vin|bi(è|e)re|rhum|alcool)\b/i, ['alcohol']],
  [/\b(farine|p(â|a)tes?|pain|semoule)\b/i, ['gluten']],
  [/\b(lait|beurre|cr(è|e)me|fromage|yaourt|parmesan)\b/i, ['dairy']],
  [/\b((œ|oe)ufs?|jaunes?)\b/i, ['egg']],
  [/\b(cacahu(è|e)tes?|arachides?)\b/i, ['peanut']],
  [/\b(noix|amandes?|noisettes?|pistaches?)\b/i, ['tree_nut']],
];
const detect = (lines: string[]): Flag[] => {
  const out = new Set<Flag>();
  for (const line of lines) for (const [re, flags] of WORDS) if (re.test(line)) flags.forEach((f) => out.add(f));
  return [...out];
};

type State = {
  me: string;
  users: (MockData['users'][number] & { avatar_url: string | null })[];
  follows: [string, string][];
  blocks: [string, string][];
  recipes: (MockRecipe & { created: number; declared_flags: Flag[]; copies_count: number })[];
  copies: { source: string; copier: string; at: number }[];
};
type MockData = typeof MOCK;

export function createMockApi(userId: string, lang: Lang): Api {
  const now = Date.now();
  const s: State = {
    me: userId,
    users: MOCK.users.map((u) => ({ ...u, avatar_url: null })),
    follows: MOCK.follows.map(([a, b]) => [a, b] as [string, string]),
    blocks: [],
    recipes: MOCK.recipes.map((r) => ({
      ...r,
      created: now - r.hours_ago * HOUR,
      declared_flags: [],
      copies_count: 0,
    })),
    copies: MOCK.copies.map((c) => ({ source: c.source, copier: c.copier, at: now - c.hours_ago * HOUR })),
  };
  // Les copies telles quelles du mode démo existent comme recettes de leur copieur.
  for (const c of MOCK.copies) {
    if (c.modified) continue;
    const src = s.recipes.find((r) => r.id === c.source);
    if (!src) continue;
    s.recipes.push({
      ...src,
      id: c.id,
      author_id: c.copier,
      visibility: clamp(c.visibility as Visibility, src.visibility as Visibility),
      created: now - c.hours_ago * HOUR,
      copied_from: src.id,
      credit_author_id: src.credit_author_id ?? src.author_id,
      modified_by_id: src.modified_by_id,
      copies_count: 0,
    });
  }
  const recount = () => {
    for (const r of s.recipes) r.copies_count = s.copies.filter((c) => c.source === r.id).length;
  };
  recount();

  const user = (id: string | null) => (id ? s.users.find((u) => u.id === id) ?? null : null);
  const me = () => user(s.me)!;
  const person = (id: string | null): Person | null => {
    const u = user(id);
    return u ? { id: u.id, username: u.username, display_name: u.display_name, avatar_url: u.avatar_url, is_editorial: u.is_editorial } : null;
  };
  const follows = (a: string, b: string) => s.follows.some(([x, y]) => x === a && y === b);
  const blocked = (a: string, b: string) => s.blocks.some(([x, y]) => (x === a && y === b) || (x === b && y === a));
  const canView = (r: State['recipes'][number]) =>
    r.author_id === s.me ||
    (!blocked(s.me, r.author_id) &&
      (r.visibility === 'public' || (r.visibility === 'followers' && follows(s.me, r.author_id))));
  const showcase = (r: State['recipes'][number]) => r.copied_from === null || r.modified_by_id === r.author_id;
  const allowed = (r: State['recipes'][number]) => !r.flags.some((f) => (me().exclusions as string[]).includes(f));
  const countries = new Map(MOCK.countries.map((c) => [c.slug, c]));

  const card = (r: State['recipes'][number]): RecipeCard => {
    const c = r.country ? countries.get(r.country) : null;
    return {
      id: r.id, title: r.title, native_name: r.native_name, cuisine: r.cuisine, country: r.country,
      country_name: c ? (lang === 'fr' ? c.name_fr : c.name_en) : null, country_flag: c?.flag ?? null,
      difficulty: r.difficulty as RecipeCard['difficulty'],
      total_min: (r.prep_min ?? 0) + (r.cook_min ?? 0),
      cover_url: r.cover_url, video_url: r.video_url, visibility: r.visibility as Visibility,
      flags: r.flags as Flag[], copies_count: r.copies_count, created_at: new Date(r.created).toISOString(),
      copied_from: r.copied_from,
      author: person(r.author_id)!, credit: person(r.credit_author_id), modified_by: person(r.modified_by_id),
    };
  };
  const find = (id: string) => {
    const r = s.recipes.find((x) => x.id === id);
    if (!r || !canView(r)) throw new Error('recipe_not_found');
    return r;
  };
  const visible = () => s.recipes.filter(canView);
  const delay = <T,>(v: T) => new Promise<T>((resolve) => setTimeout(() => resolve(v), 120));

  const api: Api = {
    live: false,

    cuisines: async (): Promise<Cuisine[]> =>
      MOCK.cuisines.map((c) => ({ slug: c.slug, name: lang === 'fr' ? c.name_fr : c.name_en, from: c.from, to: c.to })),

    me: async (): Promise<Me | null> => {
      const u = me();
      return { ...person(u.id)!, bio: u.bio, onboarded: u.onboarded, cuisines: u.cuisines, exclusions: u.exclusions as Flag[] };
    },

    onboard: async (cuisines, exclusions) => {
      Object.assign(me(), { cuisines, exclusions, onboarded: true });
    },

    updateProfile: async (patch) => {
      if (patch.username !== undefined && !/^[a-z0-9_.]{3,30}$/.test(patch.username)) throw new Error('username_invalid');
      if (patch.username && s.users.some((u) => u.username === patch.username && u.id !== s.me)) throw new Error('username_taken');
      Object.assign(me(), patch);
    },

    feed: async (offset, kind: FeedKind) => {
      const mine = me().cuisines;
      const score = (r: State['recipes'][number]) =>
        (r.cuisine && mine.includes(r.cuisine) ? 3 : 0) +
        (follows(s.me, r.author_id) ? 2 : 0) +
        Math.log(1 + r.copies_count) * 0.5 -
        (now - r.created) / (30 * 24 * HOUR);
      const list = visible()
        .filter((r) => r.author_id !== s.me && r.visibility !== 'private' && showcase(r) && allowed(r))
        .filter((r) => kind === 'all' || (kind === 'video') === !!r.video_url)
        .sort((a, b) => score(b) - score(a) || b.created - a.created);
      return delay(list.slice(offset, offset + 20).map(card));
    },

    trending: async (period: Period, cuisine, respectDiet): Promise<Ranked[]> => {
      const span = { day: 24, week: 168, month: 720 }[period] * HOUR;
      const counts = new Map<string, Set<string>>();
      for (const c of s.copies) {
        if (c.at <= Date.now() - span) continue;
        if (!counts.has(c.source)) counts.set(c.source, new Set());
        counts.get(c.source)!.add(c.copier);
      }
      const rows = [...counts]
        .map(([id, who]) => ({ r: s.recipes.find((x) => x.id === id), n: who.size }))
        .filter((x): x is { r: State['recipes'][number]; n: number } => !!x.r && canView(x.r) && x.r.visibility !== 'private')
        .filter((x) => !cuisine || x.r.cuisine === cuisine)
        .filter((x) => !respectDiet || allowed(x.r))
        .sort((a, b) => b.n - a.n || b.r.copies_count - a.r.copies_count);
      return delay(rows.slice(0, 30).map((x, i) => ({ rank: i + 1, period_copies: x.n, recipe: card(x.r) })));
    },

    globe: async (): Promise<Country[]> =>
      MOCK.countries.map((c) => ({
        slug: c.slug, name: lang === 'fr' ? c.name_fr : c.name_en, flag: c.flag, cuisine: c.cuisine, lat: c.lat, lng: c.lng,
        recipe_count: visible().filter((r) => r.country === c.slug && r.visibility !== 'private' && showcase(r) && allowed(r)).length,
      })),

    countryRecipes: async (country) =>
      delay(
        visible()
          .filter((r) => r.country === country && r.visibility !== 'private' && showcase(r) && allowed(r))
          .sort((a, b) => b.copies_count - a.copies_count)
          .map(card),
      ),

    recipe: async (id): Promise<RecipeDetail | null> => {
      const r = s.recipes.find((x) => x.id === id);
      if (!r || !canView(r)) return null;
      return {
        ...card(r), description: r.description, meal_type: r.meal_type, prep_min: r.prep_min, cook_min: r.cook_min,
        servings: r.servings, declared_flags: r.declared_flags, ingredients: r.ingredients, steps: r.steps.map((body) => ({ body })),
      };
    },

    copy: async (id, visibility) => {
      const src = find(id);
      if (src.author_id === s.me) throw new Error('cannot_copy_own');
      const existing = s.recipes.find((r) => r.author_id === s.me && r.copied_from === src.id && r.modified_by_id === src.modified_by_id);
      if (existing) return existing.id;
      const copy = {
        ...src, id: newId(), author_id: s.me, visibility: clamp(visibility, src.visibility as Visibility),
        created: Date.now(), copied_from: src.id, credit_author_id: src.credit_author_id ?? src.author_id,
        modified_by_id: src.modified_by_id, copies_count: 0,
      };
      s.recipes.push(copy);
      s.copies.push({ source: src.id, copier: s.me, at: Date.now() });
      recount();
      return copy.id;
    },

    save: async (id, input: RecipeInput, copiedFrom) => {
      if (!input.title.trim()) throw new Error('title_required');
      if (!input.ingredients.length) throw new Error('ingredients_required');
      if (!input.steps.length) throw new Error('steps_required');
      const flags = [...new Set([...detect(input.ingredients.filter((l) => !l.optional).map((l) => l.raw)), ...input.declared_flags])];
      const fields = {
        title: input.title.trim(), native_name: input.native_name.trim() || null, description: input.description,
        cuisine: input.cuisine ?? 'french', country: input.country, meal_type: input.meal_type, difficulty: input.difficulty,
        prep_min: input.prep_min, cook_min: input.cook_min, servings: input.servings, cover_url: input.cover_url,
        video_url: input.video_url, flags, declared_flags: input.declared_flags,
        ingredients: input.ingredients, steps: input.steps.map((x) => x.body),
      };
      if (id) {
        const cur = find(id);
        if (cur.author_id !== s.me) throw new Error('recipe_not_found');
        const src = cur.copied_from ? s.recipes.find((r) => r.id === cur.copied_from) : null;
        Object.assign(cur, fields, {
          visibility: src ? clamp(input.visibility, src.visibility as Visibility) : input.visibility,
          modified_by_id: cur.credit_author_id ? s.me : null,
        });
        return cur.id;
      }
      const src = copiedFrom ? find(copiedFrom) : null;
      const rec = {
        ...fields, id: newId(), author_id: s.me, hours_ago: 0, created: Date.now(), copies_count: 0,
        visibility: src ? clamp(input.visibility, src.visibility as Visibility) : input.visibility,
        copied_from: src?.id ?? null, credit_author_id: src ? src.credit_author_id ?? src.author_id : null,
        modified_by_id: src ? s.me : null,
        cuisine: input.cuisine ?? src?.cuisine ?? 'french', country: input.country ?? src?.country ?? null,
      };
      s.recipes.push(rec);
      if (src) s.copies.push({ source: src.id, copier: s.me, at: Date.now() });
      recount();
      return rec.id;
    },

    setVisibility: async (id, visibility) => {
      const cur = find(id);
      if (cur.author_id !== s.me) throw new Error('recipe_not_found');
      const src = cur.copied_from ? s.recipes.find((r) => r.id === cur.copied_from) : null;
      cur.visibility = src ? clamp(visibility, src.visibility as Visibility) : visibility;
      return cur.visibility as Visibility;
    },

    remove: async (id) => {
      const cur = find(id);
      if (cur.author_id !== s.me) throw new Error('recipe_not_found');
      s.recipes = s.recipes.filter((r) => r.id !== id);
      for (const r of s.recipes) if (r.copied_from === id) r.copied_from = null;
    },

    profile: async (userId): Promise<Profile | null> => {
      const u = user(userId);
      if (!u) return null;
      return {
        ...person(u.id)!, bio: u.bio,
        followers: s.follows.filter(([, b]) => b === u.id).length,
        following: s.follows.filter(([a]) => a === u.id).length,
        recipes: visible().filter((r) => r.author_id === u.id).length,
        is_following: follows(s.me, u.id), follows_me: follows(u.id, s.me), is_me: u.id === s.me,
      };
    },

    userRecipes: async (userId) =>
      delay(visible().filter((r) => r.author_id === userId).sort((a, b) => b.created - a.created).map(card)),

    follow: async (userId) => {
      if (userId === s.me) throw new Error('cannot_follow_self');
      if (!follows(s.me, userId)) s.follows.push([s.me, userId]);
    },
    unfollow: async (userId) => {
      s.follows = s.follows.filter(([a, b]) => !(a === s.me && b === userId));
    },
    block: async (userId) => {
      s.blocks.push([s.me, userId]);
      s.follows = s.follows.filter(([a, b]) => !((a === s.me && b === userId) || (a === userId && b === s.me)));
    },
    report: async () => undefined,

    searchProfiles: async (query) => {
      const q = query.trim().toLowerCase();
      return s.users
        .filter((u) => !q || `${u.username} ${u.display_name}`.toLowerCase().includes(q))
        .slice(0, 20)
        .map((u) => person(u.id)!);
    },

    // En démo, le fichier reste sur le téléphone : son URI locale fait l'affaire.
    upload: async (localUri) => localUri,

    deleteAccount: async () => {
      s.users = s.users.filter((u) => u.id !== s.me);
    },
  };
  return api;
}

/** Les comptes proposés à l'écran de connexion du mode démo. */
export const DEMO_ACCOUNTS = ['amina_cuisine', 'tom.newbie', 'marie_prive']
  .map((username) => MOCK.users.find((u) => u.username === username)!)
  .filter(Boolean)
  .map((u) => ({ id: u.id, username: u.username, display_name: u.display_name, onboarded: u.onboarded }));
