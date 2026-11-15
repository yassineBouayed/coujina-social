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
  Activity, Api, Challenge, Family, FamilyRecipe, ModerationItem, OpsWeek, Country, Cuisine, FeedKind, Flag, Me, Period, Person, Profile, Ranked,
  RecipeCard, RecipeDetail, RecipeInput, Suggestion, Visibility,
} from './types';
import { TERMS_VERSION } from './types';

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
  // Mesure, question du prix, activité : de quoi faire vivre les écrans, rien de plus.
  let optOut = false;
  // Conformité, abonnement, livres de famille, signalements : l'état de la démo.
  const terms = new Map<string, string | null>(MOCK.users.map((u) => [u.id, u.onboarded ? TERMS_VERSION : null]));
  const consent = new Set(MOCK.users.filter((u) => u.exclusions.length).map((u) => u.id));
  let notify = { copies: true, follows: true, challenge: true };
  const families = MOCK.families.map((b) => ({ ...b, members: [...b.members], recipes: b.recipes.map((r) => ({ ...r })) }));
  const reports = MOCK.reports.map((r) => ({ ...r, open: true }));
  const hidden = new Map<string, string>();
  let surveyAnswered = false;
  let activitySeen = Date.now() - 3 * 24 * HOUR;
  const followedAt = now - 40 * 24 * HOUR;

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
  const inMyFamilyBook = (id: string) => families.some((b) => b.members.includes(s.me) && b.recipes.some((r) => r.recipe_id === id));
  const canView = (r: State['recipes'][number]) =>
    r.author_id === s.me ||
    (!hidden.has(r.id) &&
      (inMyFamilyBook(r.id) ||
        (!blocked(s.me, r.author_id) &&
          (r.visibility === 'public' || (r.visibility === 'followers' && follows(s.me, r.author_id))))));
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
      cover_url: r.cover_url, cover_credit: r.cover_credit, cover_source_url: r.cover_source_url, video_url: r.video_url, visibility: r.visibility as Visibility,
      moderation_reason: r.author_id === s.me ? hidden.get(r.id) ?? null : null,
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
  /** Le défi de la semaine : la semaine (lundi UTC) choisit dans la liste, en boucle, comme en SQL. */
  const currentChallenge = (): Challenge | null => {
    const list = [...MOCK.challenges].sort((a, b) => a.position - b.position);
    if (!list.length) return null;
    // Le 5 janvier 1970 (jour 4) est le premier lundi : même numéro de semaine que current_challenge().
    const monday = Math.floor((Date.now() / 86400000 - 4) / 7);
    const c = list.at(monday % list.length)!;
    return { id: c.id, slug: c.slug, title: c.title, description: c.description, cuisine: c.cuisine };
  };
  const delay = <T,>(v: T) => new Promise<T>((resolve) => setTimeout(() => resolve(v), 120));

  const api: Api = {
    live: false,

    cuisines: async (): Promise<Cuisine[]> =>
      MOCK.cuisines.map((c) => ({ slug: c.slug, name: lang === 'fr' ? c.name_fr : c.name_en, from: c.from, to: c.to })),

    me: async (): Promise<Me | null> => {
      const u = me();
      return {
        ...person(u.id)!, bio: u.bio, onboarded: u.onboarded, analytics_opt_out: optOut, cuisines: u.cuisines, exclusions: u.exclusions as Flag[],
        terms_version: terms.get(u.id) ?? null, diet_consent: consent.has(u.id), is_premium: MOCK.premium.includes(u.id),
        is_moderator: MOCK.moderators.includes(u.id), notify,
      };
    },

    onboard: async (cuisines, exclusions) => {
      if (exclusions.length && !consent.has(s.me)) throw new Error('diet_consent_required');
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
      // Le crédit suit la photo : gardé si elle est la même, perdu si l'auteur la remplace.
      const creditFor = (from: { cover_url: string | null; cover_credit: string | null; cover_source_url: string | null } | null) =>
        from && from.cover_url === input.cover_url
          ? { cover_credit: from.cover_credit, cover_source_url: from.cover_source_url }
          : { cover_credit: null, cover_source_url: null };
      if (id) {
        const cur = find(id);
        if (cur.author_id !== s.me) throw new Error('recipe_not_found');
        const src = cur.copied_from ? s.recipes.find((r) => r.id === cur.copied_from) : null;
        Object.assign(cur, fields, creditFor(cur), {
          visibility: src ? clamp(input.visibility, src.visibility as Visibility) : input.visibility,
          modified_by_id: cur.credit_author_id ? s.me : null,
        });
        return cur.id;
      }
      const src = copiedFrom ? find(copiedFrom) : null;
      const rec = {
        ...fields, ...creditFor(src), id: newId(), author_id: s.me, hours_ago: 0, created: Date.now(), copies_count: 0,
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

    track: async () => undefined,
    setAnalyticsOptOut: async (next) => {
      optOut = next;
    },
    // En démo, la question du prix vient tout de suite : il n'y a pas trois jours d'usage à attendre.
    priceSurvey: async () => ({ due: !surveyAnswered, price_cents: [299, 399, 499].at([...s.me].reduce((n, c) => n + c.charCodeAt(0), 0) % 3) ?? 399 }),
    answerPriceSurvey: async () => {
      surveyAnswered = true;
    },

    challenge: async () => currentChallenge(),
    challengeEntries: async () =>
      delay(visible().filter((r) => r.in_challenge && r.visibility !== 'private' && allowed(r)).sort((a, b) => b.copies_count - a.copies_count).map(card)),
    joinChallenge: async (recipeId) => {
      const r = find(recipeId);
      if (r.author_id !== s.me) throw new Error('recipe_not_found');
      r.in_challenge = true;
    },
    whoToFollow: async (): Promise<Suggestion[]> =>
      s.users
        .filter((u) => u.id !== s.me && !u.is_editorial && !follows(s.me, u.id) && !blocked(s.me, u.id))
        .map((u) => ({
          ...person(u.id)!,
          shared_cuisines: u.cuisines.filter((c) => me().cuisines.includes(c)).length,
          public_recipes: s.recipes.filter((r) => r.author_id === u.id && r.visibility === 'public' && showcase(r)).length,
        }))
        .sort((a, b) => b.shared_cuisines - a.shared_cuisines || b.public_recipes - a.public_recipes || a.username.localeCompare(b.username))
        .slice(0, 10),
    activity: async (): Promise<Activity[]> => {
      const mineIds = new Set(s.recipes.filter((r) => r.author_id === s.me).map((r) => r.id));
      const items: Activity[] = [
        ...s.follows.filter(([, b]) => b === s.me).map(([a]) => ({
          kind: 'follow' as const, at: new Date(followedAt).toISOString(), actor: person(a)!, recipe_id: null, recipe_title: null,
          is_new: followedAt > activitySeen,
        })),
        ...s.copies.filter((c) => mineIds.has(c.source) && c.copier !== s.me).map((c) => {
          const copy = s.recipes.find((r) => r.author_id === c.copier && r.copied_from === c.source);
          return {
            kind: (copy && copy.modified_by_id === c.copier ? 'copy_modified' : 'copy') as Activity['kind'],
            at: new Date(c.at).toISOString(), actor: person(c.copier)!, recipe_id: c.source,
            recipe_title: s.recipes.find((r) => r.id === c.source)?.title ?? null, is_new: c.at > activitySeen,
          };
        }),
      ];
      return items.filter((i) => i.actor && !blocked(s.me, i.actor.id)).sort((a, b) => b.at.localeCompare(a.at));
    },
    activityUnread: async () => (await api.activity()).filter((a) => a.is_new).length,
    markActivitySeen: async () => {
      activitySeen = Date.now();
    },
    profileByUsername: async (username) => s.users.find((u) => u.username === username.toLowerCase())?.id ?? null,

    acceptTerms: async (isOver15) => {
      if (!isOver15) throw new Error('too_young');
      terms.set(s.me, TERMS_VERSION);
    },
    giveDietConsent: async () => {
      consent.add(s.me);
    },
    withdrawDietConsent: async () => {
      consent.delete(s.me);
      me().exclusions = [];
    },
    setNotify: async (patch) => {
      notify = { ...notify, ...patch };
    },
    registerPushToken: async () => undefined,

    moderationQueue: async (): Promise<ModerationItem[]> => {
      if (!MOCK.moderators.includes(s.me)) throw new Error('not_moderator');
      return reports.filter((r) => r.open).map((r) => {
        const rec = s.recipes.find((x) => x.id === r.recipe_id);
        return {
          report_id: r.id, reason: r.reason as ModerationItem['reason'], details: r.details, age_hours: r.hours_ago,
          recipe_id: r.recipe_id, recipe_title: rec?.title ?? null, recipe_author: user(rec?.author_id ?? null)?.username ?? null,
          profile_username: null, reporter_username: user(r.reporter)?.username ?? '',
        };
      });
    },
    hideRecipe: async (recipeId, reason) => {
      if (!reason.trim()) throw new Error('reason_required');
      hidden.set(recipeId, reason.trim());
      for (const r of reports) if (r.recipe_id === recipeId) r.open = false;
    },
    dismissReport: async (reportId) => {
      const r = reports.find((x) => x.id === reportId);
      if (r) r.open = false;
    },
    opsWeekly: async (): Promise<OpsWeek[]> => {
      const monday = new Date();
      monday.setDate(monday.getDate() - ((monday.getDay() + 6) % 7));
      const done = reports.filter((r) => !r.open).length;
      return [{
        week_start: monday.toISOString().slice(0, 10), received: reports.length, resolved: done,
        still_open: reports.length - done, median_hours: done ? 4 : null, within_24h: done, hidden_recipes: hidden.size,
      }];
    },

    myFamilies: async (): Promise<Family[]> =>
      families.filter((b) => b.members.includes(s.me)).map((b) => ({
        id: b.id, name: b.name, invite_code: b.owner === s.me ? b.code : null, is_owner: b.owner === s.me,
        members: b.members.length, recipes: b.recipes.length, owner_premium: MOCK.premium.includes(b.owner),
      })),
    createFamily: async (name) => {
      if (!MOCK.premium.includes(s.me)) throw new Error('premium_required');
      const id = newId();
      families.push({ id, name: name.trim(), owner: s.me, code: id.slice(-8).toUpperCase(), members: [s.me], recipes: [] });
      return id;
    },
    joinFamily: async (code) => {
      const b = families.find((x) => x.code === code.trim().toUpperCase());
      if (!b) throw new Error('family_not_found');
      if (!b.members.includes(s.me)) b.members.push(s.me);
      return b.id;
    },
    leaveFamily: async (bookId) => {
      const i = families.findIndex((b) => b.id === bookId);
      if (i < 0) return;
      if (families[i].owner === s.me) families.splice(i, 1);
      else {
        families[i].members = families[i].members.filter((m) => m !== s.me);
        families[i].recipes = families[i].recipes.filter((r) => r.added_by !== s.me);
      }
    },
    addToFamily: async (bookId, recipeId, note) => {
      const b = families.find((x) => x.id === bookId && x.members.includes(s.me));
      if (!b) throw new Error('family_not_found');
      if (!MOCK.premium.includes(b.owner)) throw new Error('premium_required');
      const r = s.recipes.find((x) => x.id === recipeId);
      if (!r || r.author_id !== s.me) throw new Error('recipe_not_found');
      const existing = b.recipes.find((x) => x.recipe_id === recipeId);
      if (existing) existing.note = note;
      else b.recipes.push({ recipe_id: recipeId, added_by: s.me, note });
    },
    familyRecipes: async (bookId): Promise<FamilyRecipe[]> => {
      const b = families.find((x) => x.id === bookId && x.members.includes(s.me));
      if (!b) return [];
      return b.recipes
        .map((fr) => ({ fr, r: s.recipes.find((x) => x.id === fr.recipe_id) }))
        .filter((x): x is { fr: (typeof b.recipes)[number]; r: State['recipes'][number] } => !!x.r)
        .map(({ fr, r }) => ({ note: fr.note, added_by_name: user(fr.added_by)?.display_name ?? '', recipe: card(r) }))
        .sort((a, b2) => a.recipe.title.localeCompare(b2.recipe.title));
    },
  };
  return api;
}

/** Les comptes proposés à l'écran de connexion du mode démo. */
export const DEMO_ACCOUNTS = ['amina_cuisine', 'tom.newbie', 'marie_prive']
  .map((username) => MOCK.users.find((u) => u.username === username)!)
  .filter(Boolean)
  .map((u) => ({ id: u.id, username: u.username, display_name: u.display_name, onboarded: u.onboarded }));
