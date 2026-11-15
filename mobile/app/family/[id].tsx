import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Platform, StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import * as Print from 'expo-print';
import * as Sharing from 'expo-sharing';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { errorText, useStore } from '../../src/store';
import { color, font } from '../../src/theme';
import type { Family, FamilyRecipe, RecipeDetail } from '../../src/types';
import { confirm } from '../../src/ui/confirm';
import { BackButton, PrimaryButton } from '../../src/ui/controls';
import { Note, Screen, Title } from '../../src/ui/primitives';
import { Empty, RecipeTile, TileGrid } from '../../src/ui/social';

const esc = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

/** Le livre en HTML imprimable : une recette par page, crédits compris. */
function bookHtml(name: string, recipes: { detail: RecipeDetail; note: string }[], credit: (r: RecipeDetail) => string) {
  const pages = recipes.map(({ detail: r, note }) => `
    <section>
      <h2>${esc(r.title)}</h2>
      ${r.native_name && r.native_name !== r.title ? `<p class="native">${esc(r.native_name)}</p>` : ''}
      <p class="credit">${esc(credit(r))}${r.country_name ? ` · ${esc(r.country_name)}` : ''}</p>
      ${note ? `<p class="note">« ${esc(note)} »</p>` : ''}
      ${r.cover_url ? `<img src="${esc(r.cover_url)}" />${r.cover_credit ? `<p class="photo">${esc(r.cover_credit)}</p>` : ''}` : ''}
      <h3>Ingrédients</h3>
      <ul>${r.ingredients.map((l) => `<li>${esc(l.raw)}${l.optional ? ' <em>(facultatif)</em>' : ''}</li>`).join('')}</ul>
      <h3>Étapes</h3>
      <ol>${r.steps.map((st) => `<li>${esc(st.body)}</li>`).join('')}</ol>
    </section>`).join('');
  return `<!doctype html><html><head><meta charset="utf-8" /><style>
    body { font-family: Georgia, serif; color: #1F1410; margin: 40px; }
    h1 { font-size: 34px; color: #7C2A55; text-align: center; margin-top: 200px; }
    .sub { text-align: center; color: #8B7A6B; }
    section { page-break-before: always; }
    h2 { font-size: 26px; margin-bottom: 4px; }
    .native { font-style: italic; color: #8B7A6B; margin: 0; }
    .credit { color: #7C2A55; font-size: 13px; }
    .note { font-style: italic; background: #F3EAE0; padding: 8px 12px; }
    img { width: 100%; max-height: 320px; object-fit: cover; margin-top: 8px; }
    .photo { font-size: 10px; color: #8B7A6B; }
    h3 { color: #C65A1A; font-size: 15px; text-transform: uppercase; letter-spacing: 1px; }
    li { margin-bottom: 6px; line-height: 1.45; }
  </style></head><body>
    <h1>${esc(name)}</h1><p class="sub">Les recettes de la famille — couJina</p>
    ${pages}
  </body></html>`;
}

/** Un livre de famille : ses recettes, son code d'invitation, l'export en livre PDF. */
export default function FamilyBook() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const { t } = useI18n();
  const { toast } = useStore();
  const { api, version, bump } = useSession();
  const [book, setBook] = useState<Family | null | undefined>(undefined);
  const [recipes, setRecipes] = useState<FamilyRecipe[]>([]);
  const [exporting, setExporting] = useState(false);

  useEffect(() => {
    if (!api || !id) return;
    api.myFamilies().then((all) => setBook(all.find((b) => b.id === id) ?? null)).catch(() => setBook(null));
    api.familyRecipes(id).then(setRecipes).catch(() => setRecipes([]));
  }, [api, id, version]);

  const credit = (r: RecipeDetail) => {
    const creator = r.credit ?? r.author;
    const by = t('recipe.by', { name: creator.display_name || creator.username });
    return r.modified_by ? `${by} · ${t('recipe.modifiedBy', { name: r.modified_by.display_name || r.modified_by.username })}` : by;
  };

  const exportPdf = async () => {
    if (!api || !book) return;
    setExporting(true);
    try {
      const details = (await Promise.all(recipes.map(async (fr) => ({ detail: await api.recipe(fr.recipe.id), note: fr.note }))))
        .filter((x): x is { detail: RecipeDetail; note: string } => !!x.detail);
      const html = bookHtml(book.name, details, credit);
      if (Platform.OS === 'web') {
        // Sur le web, expo-print ignore le HTML et imprime la page en cours :
        // on ouvre le livre dans sa propre fenêtre et on imprime celle-là.
        const win = window.open('', '_blank');
        if (!win) throw new Error('popup_blocked');
        win.document.write(html);
        win.document.close();
        win.focus();
        win.print();
      } else {
        const { uri } = await Print.printToFileAsync({ html });
        await Sharing.shareAsync(uri, { mimeType: 'application/pdf', dialogTitle: book.name, UTI: 'com.adobe.pdf' });
      }
    } catch (e) {
      toast(errorText(e, t, t('common.wentWrong')));
    } finally {
      setExporting(false);
    }
  };

  const leave = () =>
    confirm(book?.is_owner ? t('family.deleteConfirm') : t('family.leaveConfirm'), { ok: t('family.leave'), cancel: t('common.cancel') }, () => {
      api?.leaveFamily(id!).then(() => {
        bump();
        router.back();
      }).catch((e) => toast(errorText(e, t, t('common.wentWrong'))));
    });

  if (book === undefined) return <Screen><BackButton onPress={() => router.back()} /><ActivityIndicator color={color.plum} /></Screen>;
  if (book === null) return <Screen><BackButton onPress={() => router.back()} /><Empty>{t('error.family_not_found')}</Empty></Screen>;

  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Title style={s.title}>{book.name}</Title>
      {book.invite_code ? <Text style={s.code} selectable>{t('family.code', { code: book.invite_code })}</Text> : null}
      {!book.owner_premium ? <Note style={s.gap}>{t('family.lapsed')}</Note> : null}

      <PrimaryButton label={t('family.export')} busy={exporting} disabled={!recipes.length} onPress={() => void exportPdf()} style={s.gap} />

      <View style={s.list}>
        {recipes.length ? (
          <TileGrid>
            {recipes.map((fr) => (
              <View key={fr.recipe.id} style={s.item}>
                <RecipeTile recipe={fr.recipe} style={s.fullTile} />
                <Text style={s.by}>{t('family.addedBy', { name: fr.added_by_name })}</Text>
                {fr.note ? <Text style={s.note}>« {fr.note} »</Text> : null}
              </View>
            ))}
          </TileGrid>
        ) : (
          <Empty>{t('family.bookEmpty')}</Empty>
        )}
      </View>

      <Text style={s.leave} onPress={leave}>{t('family.leave')}</Text>
    </Screen>
  );
}

const s = StyleSheet.create({
  title: { marginTop: 12 },
  code: { fontFamily: font.semibold, fontSize: 14, color: color.plum, marginTop: 8 },
  gap: { marginTop: 14 },
  list: { marginTop: 20 },
  item: { width: '48%', marginBottom: 12 },
  fullTile: { width: '100%', marginBottom: 12 },
  by: { fontFamily: font.regular, fontSize: 11, color: color.mutedWarm, marginTop: -10 },
  note: { fontFamily: font.regular, fontSize: 12, fontStyle: 'italic', color: color.inkSoft, marginTop: 2, marginBottom: 12 },
  leave: { fontFamily: font.semibold, fontSize: 13.5, color: color.ember, textAlign: 'center', marginVertical: 26 },
});
