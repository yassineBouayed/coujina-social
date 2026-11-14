import React from 'react';
import { StyleSheet, Text } from 'react-native';
import { Tabs } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { color, font } from '../../src/theme';

/** Glyphes en attendant le jeu d'icônes de la charte. */
function Icon({ glyph, focused }: { glyph: string; focused: boolean }) {
  return <Text style={[s.icon, { color: focused ? color.plum : color.tabIdle }]}>{glyph}</Text>;
}

export default function TabsLayout() {
  const { t } = useI18n();
  const tab = (title: string, glyph: string) => ({
    title,
    tabBarIcon: ({ focused }: { focused: boolean }) => <Icon glyph={glyph} focused={focused} />,
  });

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: color.plum,
        tabBarInactiveTintColor: color.tabIdle,
        tabBarStyle: s.bar,
        tabBarLabelStyle: s.label,
        sceneStyle: { backgroundColor: color.screen },
      }}>
      <Tabs.Screen name="index" options={tab(t('tabs.home'), '◈')} />
      <Tabs.Screen name="explore" options={tab(t('tabs.explore'), '◍')} />
      <Tabs.Screen name="mine" options={tab(t('tabs.mine'), '❑')} />
      <Tabs.Screen name="top" options={tab(t('tabs.top'), '▲')} />
      <Tabs.Screen name="profile" options={tab(t('tabs.profile'), '☺')} />
    </Tabs>
  );
}

const s = StyleSheet.create({
  bar: { backgroundColor: color.screen, borderTopColor: color.border },
  label: { fontFamily: font.medium, fontSize: 10.5 },
  icon: { fontSize: 18 },
});
