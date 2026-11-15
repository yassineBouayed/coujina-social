/**
 * Un rendu Markdown minimal pour les textes juridiques : titres, paragraphes,
 * listes, tableaux simples et **gras**. Pas de dépendance : ces textes
 * changent rarement et sont écrits pour lui.
 */
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

import { color, font, radius } from '../theme';

function Inline({ text, style }: { text: string; style: object }) {
  const parts = text.split(/(\*\*[^*]+\*\*)/g).filter(Boolean);
  return (
    <Text style={style}>
      {parts.map((p, i) =>
        p.startsWith('**') ? <Text key={i} style={s.bold}>{p.slice(2, -2)}</Text> : <Text key={i}>{p.replace(/\*([^*]+)\*/g, '$1')}</Text>,
      )}
    </Text>
  );
}

export function Markdown({ source }: { source: string }) {
  const blocks: React.ReactNode[] = [];
  const lines = source.split(/\r?\n/);
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (!line.trim()) continue;
    if (line.startsWith('# ')) {
      blocks.push(<Text key={i} style={s.h1}>{line.slice(2)}</Text>);
    } else if (line.startsWith('## ')) {
      blocks.push(<Text key={i} style={s.h2}>{line.slice(3)}</Text>);
    } else if (/^\s*- /.test(line)) {
      const indent = line.search(/\S/) > 0;
      blocks.push(
        <View key={i} style={[s.bullet, indent && s.bulletIndent]}>
          <Text style={s.dot}>•</Text>
          <Inline text={line.replace(/^\s*- /, '')} style={s.p} />
        </View>,
      );
    } else if (line.startsWith('|')) {
      // Un tableau : chaque ligne devient une carte « colonne : valeur ».
      const header = line.split('|').slice(1, -1).map((c) => c.trim());
      i += 1; // la ligne de séparation
      while (i + 1 < lines.length && lines[i + 1].startsWith('|')) {
        i += 1;
        const cells = lines[i].split('|').slice(1, -1).map((c) => c.trim());
        blocks.push(
          <View key={i} style={s.row}>
            {cells.map((c, j) => (
              <Inline key={j} text={j === 0 ? `**${c}**` : `${header[j]} : ${c}`} style={j === 0 ? s.p : s.small} />
            ))}
          </View>,
        );
      }
    } else {
      blocks.push(<Inline key={i} text={line} style={s.p} />);
    }
  }
  return <View>{blocks}</View>;
}

const s = StyleSheet.create({
  h1: { fontFamily: font.display, fontSize: 24, lineHeight: 28, color: color.ink, marginBottom: 10 },
  h2: { fontFamily: font.semibold, fontSize: 16, color: color.plum, marginTop: 18, marginBottom: 6 },
  p: { fontFamily: font.regular, fontSize: 14, lineHeight: 21, color: color.inkSoft, marginBottom: 8 },
  small: { fontFamily: font.regular, fontSize: 13, lineHeight: 19, color: color.inkFaint, marginBottom: 2 },
  bold: { fontFamily: font.semibold, color: color.ink },
  bullet: { flexDirection: 'row', gap: 8, paddingRight: 8 },
  bulletIndent: { paddingLeft: 16 },
  dot: { fontFamily: font.regular, fontSize: 14, lineHeight: 21, color: color.plum },
  row: { padding: 10, borderRadius: radius.md, backgroundColor: color.sand, marginBottom: 8 },
});
