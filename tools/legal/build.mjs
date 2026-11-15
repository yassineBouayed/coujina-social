/**
 * npm run legal:build — docs/legal/*.md -> mobile/src/legal.generated.ts
 *
 * Le texte juridique a UNE source, le Markdown de docs/legal, que le juriste
 * relit et corrige ; l'application en embarque une copie générée, lisible
 * hors ligne. Relancer après chaque correction.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const read = (f) => fs.readFileSync(path.join(ROOT, 'docs', 'legal', f), 'utf8');

const out = `// GÉNÉRÉ par \`npm run legal:build\` depuis docs/legal/*.md — ne pas modifier à la main.
export const LEGAL = {
  cgu: ${JSON.stringify(read('cgu.md'))},
  privacy: ${JSON.stringify(read('confidentialite.md'))},
} as const;
export type LegalDoc = keyof typeof LEGAL;
`;
fs.writeFileSync(path.join(ROOT, 'mobile', 'src', 'legal.generated.ts'), out);
console.log('-> mobile/src/legal.generated.ts');
