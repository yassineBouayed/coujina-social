/** The single global toast. Every confirmation in the loop goes through it. */
import React, { useEffect, useRef } from 'react';
import { Animated, Easing, StyleSheet, Text } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { color, font, radius } from '../theme';
import { useStore } from '../store';

export function Toast() {
  const { state } = useStore();
  const insets = useSafeAreaInsets();
  const t = useRef(new Animated.Value(0)).current;
  const message = state.toast;

  useEffect(() => {
    Animated.timing(t, {
      toValue: message ? 1 : 0,
      duration: message ? 280 : 160,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
  }, [message, t]);

  if (!message) return null;

  return (
    <Animated.View
      pointerEvents="none"
      accessibilityLiveRegion="polite"
      style={[
        s.toast,
        { bottom: insets.bottom + 92 },
        { opacity: t, transform: [{ translateY: t.interpolate({ inputRange: [0, 1], outputRange: [14, 0] }) }] },
      ]}>
      <Text style={s.text}>{message}</Text>
    </Animated.View>
  );
}

const s = StyleSheet.create({
  toast: {
    position: 'absolute',
    left: 16,
    right: 16,
    backgroundColor: color.ink,
    borderRadius: radius.lg,
    paddingVertical: 14,
    paddingHorizontal: 16,
    shadowColor: color.ink,
    shadowOpacity: 0.4,
    shadowRadius: 20,
    shadowOffset: { width: 0, height: 12 },
    elevation: 8,
  },
  text: { fontFamily: font.medium, fontSize: 13.5, lineHeight: 19, color: '#fff' },
});
