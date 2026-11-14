/**
 * Français / English — J7, SPEC.md §13.
 *
 * Three things, and they are deliberately not the same thing:
 *
 *   * THE INTERFACE speaks the active language, from the catalogues in
 *     `en.ts` and `fr.ts`.
 *   * THE CONTENT speaks it too, because the catalogue has been bilingual in
 *     the database since J5 — `p_lang` is threaded through every RPC rather
 *     than a second copy of the recipes living in the phone.
 *   * THE ORIGINAL NAME OF A DISH never moves. `native_name` is not a
 *     translation and has no translation (SPEC §4). A tajine zitoune is a
 *     tajine zitoune in both languages; that is the promise of the product,
 *     and it is the one string i18n must not touch.
 *
 * The language is stored on the ACCOUNT, not on the device: it follows the
 * person to their second phone. Null on the account means "follow the phone",
 * which is a different answer from "French" and has to stay distinguishable —
 * a household that never chose should track a phone switched to English.
 *
 * `AsyncStorage` holds the same value, and it is what the app boots on: the
 * first frame renders before any network call, and rendering it in the wrong
 * language for half a second is exactly the kind of detail this milestone is
 * about.
 */
import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { getLocales } from 'expo-localization';

import { en, type MessageKey, type Messages, type PluralKey } from './en';
import { fr } from './fr';

export type Lang = 'fr' | 'en';
/** What the user chose. `system` is an answer, not the absence of one. */
export type LangChoice = Lang | 'system';

const CATALOGUE: Record<Lang, Messages> = { en, fr };

const STORAGE_KEY = 'coujina.lang';

/** BCP 47 tags the phone reports, reduced to what the app has words for. */
export function deviceLang(): Lang {
  const tags = getLocales();
  for (const locale of tags) {
    const code = (locale.languageCode ?? locale.languageTag ?? '').slice(0, 2).toLowerCase();
    if (code === 'fr') return 'fr';
    if (code === 'en') return 'en';
  }
  // Neither: French, because the launch is French-speaking and the recipes
  // were written in French first. A default is a decision, not a fallback.
  return 'fr';
}

export type I18n = {
  /** The language actually being rendered. */
  lang: Lang;
  /** What was chosen, which may be `system`. */
  choice: LangChoice;
  /** What the phone itself says, so the settings screen can name it. */
  device: Lang;
  /** True until the stored choice has been read — one frame, usually. */
  loading: boolean;
  t: (key: MessageKey, vars?: Record<string, string | number>) => string;
  /** Counted messages: picks `key#one` or `key#other`, and passes `count`. */
  tn: (key: PluralKey, count: number, vars?: Record<string, string | number>) => string;
  /** For `toLocaleDateString` and friends. */
  locale: string;
  setChoice: (choice: LangChoice) => void;
};

const I18nContext = createContext<I18n | null>(null);

/** `{name}` → value. Missing variables are left visible rather than blanked. */
function fill(template: string, vars?: Record<string, string | number>): string {
  if (!vars) return template;
  return template.replace(/\{(\w+)\}/g, (whole, name: string) =>
    name in vars ? String(vars[name]) : whole,
  );
}

/**
 * One rule for both languages, and it is not the same rule.
 *
 * English: 1 is singular, everything else plural. French: 0 and 1 are both
 * singular ("1 article", "0 article"). Written out because a shared "n === 1"
 * would be wrong in French exactly at the moment a list empties.
 */
const isSingular = (lang: Lang, n: number) => (lang === 'fr' ? Math.abs(n) < 2 : n === 1);

export function I18nProvider({ children }: { children: ReactNode }) {
  const device = useMemo(deviceLang, []);
  const [choice, setChoiceState] = useState<LangChoice>('system');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    AsyncStorage.getItem(STORAGE_KEY)
      .then((stored) => {
        if (cancelled) return;
        if (stored === 'fr' || stored === 'en' || stored === 'system') setChoiceState(stored);
      })
      .catch(() => undefined)
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const setChoice = useCallback((next: LangChoice) => {
    setChoiceState(next);
    void AsyncStorage.setItem(STORAGE_KEY, next).catch(() => undefined);
  }, []);

  const value = useMemo<I18n>(() => {
    const lang: Lang = choice === 'system' ? device : choice;
    const messages = CATALOGUE[lang];

    const t = (key: MessageKey, vars?: Record<string, string | number>) =>
      fill(messages[key] ?? en[key] ?? key, vars);

    return {
      lang,
      choice,
      device,
      loading,
      t,
      tn: (key, count, vars) =>
        t(`${key}#${isSingular(lang, count) ? 'one' : 'other'}` as MessageKey, {
          count,
          ...vars,
        }),
      locale: lang === 'fr' ? 'fr-FR' : 'en-GB',
      setChoice,
    };
  }, [choice, device, loading, setChoice]);

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useI18n(): I18n {
  const i18n = useContext(I18nContext);
  if (!i18n) throw new Error('useI18n must be used inside <I18nProvider>');
  return i18n;
}

export type { MessageKey, Messages, PluralKey };
