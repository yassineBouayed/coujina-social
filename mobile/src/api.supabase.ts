/**
 * L'API contre Supabase. Chaque règle — qui voit quoi, le crédit d'une copie,
 * les interdits, les classements — vit en SQL (supabase/migrations) et y est
 * testée ; ce fichier ne fait que traduire les lignes en types de l'écran.
 */
import type { SupabaseClient } from '@supabase/supabase-js';

import type {
  Activity, Api, Challenge, Family, FamilyRecipe, ModerationItem, OpsWeek, Country, Cuisine, Flag, Me, Person, Profile, Ranked, RecipeCard, RecipeDetail, Suggestion, Visibility,
} from './types';
import { TERMS_VERSION } from './types';

type Lang = 'fr' | 'en';
type Row = Record<string, any>;

function check<T>(res: { data: T; error: { message: string } | null }): T {
  if (res.error) throw new Error(res.error.message);
  return res.data;
}

const personFrom = (row: Row, prefix: 'author' | 'credit' | 'modified', id: string | null): Person | null =>
  id
    ? {
        id,
        username: row[`${prefix}_username`] ?? '',
        display_name: row[`${prefix}_name`] ?? '',
        avatar_url: prefix === 'author' ? row.author_avatar ?? null : null,
        is_editorial: prefix === 'author' ? !!row.author_is_editorial : false,
      }
    : null;

export const cardFrom = (row: Row, lang: Lang): RecipeCard => ({
  id: row.id,
  title: row.title,
  native_name: row.native_name ?? null,
  cuisine: row.cuisine ?? null,
  country: row.country ?? null,
  country_name: (lang === 'fr' ? row.country_name_fr : row.country_name_en) ?? null,
  country_flag: row.country_flag ?? null,
  difficulty: row.difficulty,
  total_min: row.total_min ?? 0,
  cover_url: row.cover_url ?? null,
  cover_credit: row.cover_credit ?? null,
  cover_source_url: row.cover_source_url ?? null,
  moderation_reason: row.moderation_reason ?? null,
  video_url: row.video_url ?? null,
  visibility: row.visibility,
  flags: row.dietary_flags ?? [],
  copies_count: row.copies_count ?? 0,
  created_at: row.created_at,
  copied_from: row.copied_from ?? null,
  author: personFrom(row, 'author', row.author_id)!,
  credit: personFrom(row, 'credit', row.credit_author_id),
  modified_by: personFrom(row, 'modified', row.modified_by_id),
});

export function createSupabaseApi(sb: SupabaseClient, userId: string, lang: Lang): Api {
  return {
    live: true,

    cuisines: async (): Promise<Cuisine[]> =>
      (check(await sb.from('cuisines').select('*').order('sort_order')) as Row[]).map((c) => ({
        slug: c.slug, name: lang === 'fr' ? c.name_fr : c.name_en, from: c.gradient_from, to: c.gradient_to,
      })),

    me: async (): Promise<Me | null> => {
      const [profile, cuisines, exclusions] = await Promise.all([
        sb.from('profiles').select('*').eq('id', userId).maybeSingle(),
        sb.from('profile_cuisines').select('cuisine_slug'),
        sb.from('profile_exclusions').select('flag'),
      ]);
      const p = check(profile) as Row | null;
      if (!p) return null;
      return {
        id: p.id, username: p.username, display_name: p.display_name, avatar_url: p.avatar_url ?? null,
        is_editorial: p.is_editorial, bio: p.bio ?? '', onboarded: !!p.onboarded_at,
        analytics_opt_out: !!p.analytics_opt_out,
        terms_version: p.terms_version ?? null,
        diet_consent: !!p.diet_consent_at,
        is_premium: !!p.premium_until && Date.parse(p.premium_until) > Date.now(),
        is_moderator: !!p.is_moderator,
        notify: { copies: p.notify_copies !== false, follows: p.notify_follows !== false, challenge: p.notify_challenge !== false },
        cuisines: ((check(cuisines) as Row[]) ?? []).map((r) => r.cuisine_slug),
        exclusions: ((check(exclusions) as Row[]) ?? []).map((r) => r.flag as Flag),
      };
    },

    onboard: async (cuisines, exclusions) => {
      check(await sb.rpc('profile_onboard', { p_cuisines: cuisines, p_exclusions: exclusions }));
    },

    updateProfile: async (patch) => {
      check(await sb.from('profiles').update({ ...patch, updated_at: new Date().toISOString() }).eq('id', userId));
    },

    feed: async (offset, kind) =>
      ((check(await sb.rpc('home_feed', { p_limit: 20, p_offset: offset, p_kind: kind })) as Row[]) ?? []).map((r) => cardFrom(r, lang)),

    trending: async (period, cuisine, respectDiet): Promise<Ranked[]> =>
      ((check(
        await sb.rpc('trending_recipes', { p_period: period, p_cuisine: cuisine, p_respect_diet: respectDiet, p_limit: 30 }),
      ) as Row[]) ?? []).map((r) => ({ rank: r.rank, period_copies: r.period_copies, recipe: cardFrom(r.recipe, lang) })),

    globe: async (): Promise<Country[]> =>
      ((check(await sb.rpc('globe_countries')) as Row[]) ?? []).map((c) => ({
        slug: c.slug, name: lang === 'fr' ? c.name_fr : c.name_en, flag: c.flag, cuisine: c.cuisine,
        lat: c.lat, lng: c.lng, recipe_count: c.recipe_count,
      })),

    countryRecipes: async (country) =>
      ((check(await sb.rpc('country_recipes', { p_country: country, p_limit: 50 })) as Row[]) ?? []).map((r) => cardFrom(r, lang)),

    recipe: async (id): Promise<RecipeDetail | null> => {
      const [card, extra, ingredients, steps] = await Promise.all([
        sb.from('recipe_cards').select('*').eq('id', id).maybeSingle(),
        sb.from('recipes').select('declared_flags').eq('id', id).maybeSingle(),
        sb.from('recipe_ingredients').select('raw, optional').eq('recipe_id', id).order('position'),
        sb.from('recipe_steps').select('body').eq('recipe_id', id).order('position'),
      ]);
      const row = check(card) as Row | null;
      if (!row) return null;
      return {
        ...cardFrom(row, lang),
        description: row.description ?? '',
        meal_type: row.meal_type ?? null,
        prep_min: row.prep_min ?? null,
        cook_min: row.cook_min ?? null,
        servings: row.servings ?? 4,
        declared_flags: ((check(extra) as Row | null)?.declared_flags ?? []) as Flag[],
        ingredients: (check(ingredients) as Row[]).map((l) => ({ raw: l.raw, optional: !!l.optional })),
        steps: (check(steps) as Row[]).map((s) => ({ body: s.body })),
      };
    },

    copy: async (id, visibility) => check(await sb.rpc('copy_recipe', { p_source: id, p_visibility: visibility })) as string,

    save: async (id, input, copiedFrom) =>
      check(
        await sb.rpc('recipe_save', {
          p_id: id,
          p_recipe: { ...input, lang },
          p_copied_from: copiedFrom,
        }),
      ) as string,

    setVisibility: async (id, visibility) =>
      check(await sb.rpc('recipe_set_visibility', { p_id: id, p_visibility: visibility })) as Visibility,

    remove: async (id) => {
      check(await sb.from('recipes').delete().eq('id', id));
    },

    profile: async (target): Promise<Profile | null> => {
      const rows = check(await sb.rpc('profile_summary', { p_user: target })) as Row[];
      const p = rows?.[0];
      return p ? { ...(p as Profile), avatar_url: p.avatar_url ?? null } : null;
    },

    userRecipes: async (target) =>
      ((check(await sb.rpc('user_recipes', { p_user: target, p_limit: 100 })) as Row[]) ?? []).map((r) => cardFrom(r, lang)),

    follow: async (target) => {
      check(await sb.from('follows').insert({ follower_id: userId, followee_id: target }));
    },
    unfollow: async (target) => {
      check(await sb.from('follows').delete().eq('follower_id', userId).eq('followee_id', target));
    },
    block: async (target) => {
      check(await sb.from('blocks').insert({ blocker_id: userId, blocked_id: target }));
      await sb.from('follows').delete().eq('follower_id', userId).eq('followee_id', target);
      await sb.from('follows').delete().eq('follower_id', target).eq('followee_id', userId);
    },
    report: async (target, reason) => {
      check(
        await sb.from('reports').insert({
          reporter_id: userId, recipe_id: target.recipeId ?? null, profile_id: target.profileId ?? null, reason,
        }),
      );
    },

    searchProfiles: async (query) =>
      ((check(await sb.rpc('search_profiles', { p_query: query, p_limit: 20 })) as Row[]) ?? []).map((p) => ({
        id: p.id, username: p.username, display_name: p.display_name, avatar_url: p.avatar_url ?? null, is_editorial: p.is_editorial,
      })),

    /**
     * Le fichier est lu en entier en mémoire puis envoyé : suffisant pour des
     * photos et des vidéos de trois minutes. Au-delà, il faudra l'envoi
     * reprenable (TUS) — voir ETAT.md.
     */
    upload: async (localUri, kind, mime) => {
      const ext = (mime?.split('/')[1] ?? (kind === 'video' ? 'mp4' : 'jpg')).replace('quicktime', 'mov').replace('jpeg', 'jpg');
      const path = `${userId}/${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 8)}.${ext}`;
      const body = await (await fetch(localUri)).arrayBuffer();
      check(
        await sb.storage.from('recipe-media').upload(path, body, {
          contentType: mime ?? (kind === 'video' ? 'video/mp4' : 'image/jpeg'),
          upsert: false,
        }),
      );
      return sb.storage.from('recipe-media').getPublicUrl(path).data.publicUrl;
    },

    deleteAccount: async () => {
      check(await sb.rpc('delete_my_account'));
      await sb.auth.signOut();
    },

    // La mesure ne doit jamais casser un écran : une erreur ici est avalée.
    track: async (name, recipeId) => {
      await sb.rpc('track_event', { p_name: name, p_recipe: recipeId ?? null }).then(() => undefined, () => undefined);
    },
    setAnalyticsOptOut: async (optOut) => {
      check(await sb.from('profiles').update({ analytics_opt_out: optOut }).eq('id', userId));
    },
    priceSurvey: async () => {
      const row = ((check(await sb.rpc('price_survey_due')) as Row[]) ?? [])[0];
      return { due: !!row?.due, price_cents: row?.price_cents ?? 399 };
    },
    answerPriceSurvey: async (answer, wants) => {
      check(await sb.rpc('answer_price_survey', { p_answer: answer, p_wants: wants }));
    },

    challenge: async (): Promise<Challenge | null> => {
      const rows = (check(await sb.rpc('current_challenge')) as Row[]) ?? [];
      const c = rows[0];
      return c ? { id: c.id, slug: c.slug, title: c.title, description: c.description, cuisine: c.cuisine ?? null } : null;
    },
    challengeEntries: async () =>
      ((check(await sb.rpc('challenge_entries', { p_limit: 30 })) as Row[]) ?? []).map((r) => cardFrom(r, lang)),
    joinChallenge: async (recipeId) => {
      check(await sb.rpc('recipe_join_challenge', { p_recipe: recipeId }));
    },
    whoToFollow: async (): Promise<Suggestion[]> =>
      ((check(await sb.rpc('who_to_follow', { p_limit: 10 })) as Row[]) ?? []).map((p) => ({
        id: p.id, username: p.username, display_name: p.display_name, avatar_url: p.avatar_url ?? null,
        is_editorial: p.is_editorial, shared_cuisines: p.shared_cuisines, public_recipes: p.public_recipes,
      })),
    activity: async (): Promise<Activity[]> =>
      ((check(await sb.rpc('my_activity', { p_limit: 50 })) as Row[]) ?? []).map((a) => ({
        kind: a.kind, at: a.at, is_new: a.is_new, recipe_id: a.recipe_id ?? null, recipe_title: a.recipe_title ?? null,
        actor: { id: a.actor_id, username: a.actor_username, display_name: a.actor_name, avatar_url: null, is_editorial: false },
      })),
    activityUnread: async () => (check(await sb.rpc('activity_unread')) as number) ?? 0,
    markActivitySeen: async () => {
      check(await sb.rpc('activity_mark_seen'));
    },
    profileByUsername: async (username) => (check(await sb.rpc('profile_by_username', { p_username: username })) as string | null) ?? null,

    acceptTerms: async (isOver15) => {
      check(await sb.rpc('accept_terms', { p_version: TERMS_VERSION, p_is_15_or_more: isOver15 }));
    },
    giveDietConsent: async () => {
      check(await sb.rpc('give_diet_consent'));
    },
    withdrawDietConsent: async () => {
      check(await sb.rpc('withdraw_diet_consent'));
    },
    setNotify: async (patch) => {
      const row: Row = {};
      if (patch.copies !== undefined) row.notify_copies = patch.copies;
      if (patch.follows !== undefined) row.notify_follows = patch.follows;
      if (patch.challenge !== undefined) row.notify_challenge = patch.challenge;
      check(await sb.from('profiles').update(row).eq('id', userId));
    },
    registerPushToken: async (token, platform) => {
      check(await sb.rpc('register_push_token', { p_token: token, p_platform: platform }));
    },

    moderationQueue: async () => (check(await sb.rpc('moderation_queue')) as ModerationItem[]) ?? [],
    hideRecipe: async (recipeId, reason) => {
      check(await sb.rpc('moderation_hide_recipe', { p_recipe: recipeId, p_reason: reason }));
    },
    dismissReport: async (reportId) => {
      check(await sb.rpc('moderation_dismiss', { p_report: reportId, p_note: '' }));
    },
    opsWeekly: async () => (check(await sb.rpc('ops_weekly', { p_weeks: 8 })) as OpsWeek[]) ?? [],

    myFamilies: async () => (check(await sb.rpc('my_families')) as Family[]) ?? [],
    createFamily: async (name) => check(await sb.rpc('family_create', { p_name: name })) as string,
    joinFamily: async (code) => check(await sb.rpc('family_join', { p_code: code })) as string,
    leaveFamily: async (bookId) => {
      check(await sb.rpc('family_leave', { p_book: bookId }));
    },
    addToFamily: async (bookId, recipeId, note) => {
      check(await sb.rpc('family_add_recipe', { p_book: bookId, p_recipe: recipeId, p_note: note }));
    },
    familyRecipes: async (bookId): Promise<FamilyRecipe[]> =>
      ((check(await sb.rpc('family_book_recipes', { p_book: bookId })) as Row[]) ?? []).map((r) => ({
        note: r.note ?? '', added_by_name: r.added_by_name ?? '', recipe: cardFrom(r.recipe, lang),
      })),
  };
}
