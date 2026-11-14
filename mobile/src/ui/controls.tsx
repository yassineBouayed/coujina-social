/** Interactive controls: chips, toggles, steppers, checkboxes, buttons. */
import React, { type ReactNode } from 'react';
import {
  ActivityIndicator,
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  View,
  type StyleProp,
  type TextInputProps,
  type ViewStyle,
} from 'react-native';

import { useI18n } from '../i18n';
import { color, font, radius } from '../theme';

const pressed = ({ pressed: p }: { pressed: boolean }) => ({ opacity: p ? 0.65 : 1 });

/* --------------------------------------------------------------- buttons */

export function PrimaryButton({
  label,
  onPress,
  disabled,
  /** Shows a spinner in place of the label. Implies `disabled`. */
  busy,
  style,
}: {
  label: string;
  onPress: () => void;
  disabled?: boolean;
  busy?: boolean;
  style?: StyleProp<ViewStyle>;
}) {
  const off = disabled || busy;
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityState={{ disabled: !!off, busy: !!busy }}
      disabled={off}
      onPress={onPress}
      style={(p) => [s.primary, off ? s.buttonOff : pressed(p), style]}>
      {busy ? (
        <ActivityIndicator color="#fff" />
      ) : (
        <Text style={s.primaryLabel}>{label}</Text>
      )}
    </Pressable>
  );
}

export function SecondaryButton({
  label,
  onPress,
  disabled,
  busy,
  style,
}: {
  label: string;
  onPress: () => void;
  disabled?: boolean;
  busy?: boolean;
  style?: StyleProp<ViewStyle>;
}) {
  const off = disabled || busy;
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityState={{ disabled: !!off, busy: !!busy }}
      disabled={off}
      onPress={onPress}
      style={(p) => [s.secondary, off ? s.buttonOff : pressed(p), style]}>
      {busy ? (
        <ActivityIndicator color={color.plum} />
      ) : (
        <Text style={s.secondaryLabel}>{label}</Text>
      )}
    </Pressable>
  );
}

/* ------------------------------------------------------------------ input */

/**
 * The one text field in the app (repris de l'ancien projet). Capitalisation is
 * left to the caller — an e-mail must not be capitalised, a dish name must.
 */
export function TextField({
  value,
  onChangeText,
  placeholder,
  autoFocus,
  editable = true,
  /** `code` gives the six-character invite code its wide display treatment. */
  variant = 'text',
  /**
   * Prose, in the user's own words — a rewritten recipe step. Sentences get
   * their capitals back and the field grows: everything else the app asks for
   * is a term, a code or an address, and none of those want either.
   */
  multiline,
  keyboardType,
  autoComplete,
  textContentType,
  maxLength,
  autoCapitalize,
  autoCorrect,
  secureTextEntry,
  onSubmitEditing,
  accessibilityLabel,
  style,
}: {
  value: string;
  onChangeText: (next: string) => void;
  placeholder?: string;
  autoFocus?: boolean;
  editable?: boolean;
  variant?: 'text' | 'code';
  multiline?: boolean;
  keyboardType?: TextInputProps['keyboardType'];
  autoComplete?: TextInputProps['autoComplete'];
  textContentType?: TextInputProps['textContentType'];
  maxLength?: number;
  autoCapitalize?: TextInputProps['autoCapitalize'];
  autoCorrect?: boolean;
  secureTextEntry?: boolean;
  onSubmitEditing?: () => void;
  accessibilityLabel?: string;
  style?: StyleProp<ViewStyle>;
}) {
  const code = variant === 'code';
  return (
    <TextInput
      value={value}
      onChangeText={onChangeText}
      placeholder={placeholder}
      placeholderTextColor={color.muted}
      autoFocus={autoFocus}
      editable={editable}
      autoCapitalize={autoCapitalize ?? (code ? 'characters' : multiline ? 'sentences' : 'none')}
      autoCorrect={autoCorrect ?? !!multiline}
      keyboardType={keyboardType}
      autoComplete={autoComplete}
      textContentType={textContentType}
      maxLength={maxLength}
      secureTextEntry={secureTextEntry}
      multiline={multiline}
      onSubmitEditing={onSubmitEditing}
      returnKeyType={multiline ? 'default' : 'go'}
      accessibilityLabel={accessibilityLabel ?? placeholder}
      style={[s.field, code && s.fieldCode, multiline && s.fieldProse, !editable && s.fieldOff, style]}
    />
  );
}

/** Small pill button — "Shop now", "Send to list", "Copy". */
export function PillButton({
  label,
  onPress,
  background = color.plum,
  foreground = '#fff',
  border,
  disabled,
  style,
}: {
  label: string;
  onPress: () => void;
  background?: string;
  foreground?: string;
  border?: string;
  /** Greyed and inert while a gesture of the same screen is in flight. */
  disabled?: boolean;
  style?: StyleProp<ViewStyle>;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityState={{ disabled: !!disabled }}
      disabled={disabled}
      onPress={onPress}
      style={(p) => [
        s.pill,
        { backgroundColor: background, borderColor: border ?? background, borderWidth: border ? 1 : 0 },
        disabled ? s.buttonOff : pressed(p),
        style,
      ]}>
      <Text style={[s.pillLabel, { color: foreground }]}>{label}</Text>
    </Pressable>
  );
}

export function BackButton({ onPress, onDark }: { onPress: () => void; onDark?: boolean }) {
  const { t } = useI18n();
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel={t('common.goBack')}
      onPress={onPress}
      style={(p) => [s.back, onDark && s.backOnDark, pressed(p)]}>
      <Text style={s.backGlyph}>‹</Text>
    </Pressable>
  );
}

/* ----------------------------------------------------------------- chips */

export function Chip({
  label,
  selected,
  onPress,
  /** Onboarding chips are larger and carry a ✓ / + mark. */
  large,
  /** Offered elsewhere, and not on offer here — the second onboarding
      question does not repropose a cuisine the first has taken. */
  disabled,
}: {
  label: string;
  selected: boolean;
  onPress: () => void;
  large?: boolean;
  disabled?: boolean;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityState={{ selected, disabled: !!disabled }}
      disabled={disabled}
      onPress={onPress}
      style={(p) => [
        s.chip,
        large ? s.chipLarge : s.chipSmall,
        {
          borderColor: selected ? color.plum : color.borderStrong,
          backgroundColor: selected ? color.plum : color.surface,
        },
        disabled && s.chipOff,
        pressed(p),
      ]}>
      {large ? <Text style={[s.chipMark, selected && s.chipTextOn]}>{selected ? '✓' : '+'}</Text> : null}
      <Text
        style={[
          large ? s.chipTextLarge : s.chipText,
          selected ? s.chipTextOn : s.chipTextOff,
        ]}>
        {label}
      </Text>
    </Pressable>
  );
}

/* --------------------------------------------------------------- toggles */

export function Toggle({
  value,
  onPress,
  label,
}: {
  value: boolean;
  onPress: () => void;
  /** Read out by screen readers, since the switch itself carries no text. */
  label: string;
}) {
  return (
    <Pressable
      accessibilityRole="switch"
      accessibilityLabel={label}
      accessibilityState={{ checked: value }}
      onPress={onPress}
      style={(p) => [
        s.track,
        { backgroundColor: value ? color.plum : color.trackOff, justifyContent: value ? 'flex-end' : 'flex-start' },
        pressed(p),
      ]}>
      <View style={s.knob} />
    </Pressable>
  );
}

/* -------------------------------------------------------------- steppers */

/**
 * Servings stepper on the recipe screen — same idea, sand pill, white buttons.
 *
 * `disabled` is used while the sheet is being corrected (J13): the quantities
 * on screen are the ones being edited, and moving the scale under them would
 * either throw the corrections away or save numbers for a different table.
 */
export function ServingsStepper({
  value,
  onStep,
  disabled,
}: {
  value: number;
  onStep: (delta: number) => void;
  disabled?: boolean;
}) {
  const { t } = useI18n();
  return (
    <View style={[s.servings, disabled && s.buttonOff]}>
      <Pressable
        accessibilityRole="button"
        accessibilityLabel={t('servings.fewer')}
        accessibilityState={{ disabled: !!disabled }}
        disabled={disabled}
        onPress={() => onStep(-1)}
        style={(p) => [s.servingsBtn, pressed(p)]}>
        <Text style={s.servingsGlyph}>−</Text>
      </Pressable>
      <Text style={s.servingsValue}>{value}</Text>
      <Pressable
        accessibilityRole="button"
        accessibilityLabel={t('servings.more')}
        accessibilityState={{ disabled: !!disabled }}
        disabled={disabled}
        onPress={() => onStep(1)}
        style={(p) => [s.servingsBtn, pressed(p)]}>
        <Text style={s.servingsGlyph}>+</Text>
      </Pressable>
    </View>
  );
}

/** List checkbox. `picking` is the ember middle state used inside a session. */
export function Check({
  state,
  onPress,
  label,
  size = 23,
}: {
  state: 'todo' | 'picking' | 'done';
  onPress: () => void;
  label: string;
  size?: number;
}) {
  const fill = state === 'done' ? color.green : state === 'picking' ? color.ember : color.surface;
  const border = state === 'done' ? color.green : state === 'picking' ? color.ember : color.borderDark;
  return (
    <Pressable
      accessibilityRole="checkbox"
      accessibilityLabel={label}
      accessibilityState={{ checked: state === 'done' }}
      onPress={onPress}
      style={(p) => [
        s.check,
        { width: size, height: size, borderRadius: size > 24 ? 8 : 7, backgroundColor: fill, borderColor: border },
        pressed(p),
      ]}>
      <Text style={s.checkGlyph}>{state === 'done' ? '✓' : state === 'picking' ? '·' : ''}</Text>
    </Pressable>
  );
}

/* ---------------------------------------------------------------- layout */

export function Row({ children, style }: { children: ReactNode; style?: StyleProp<ViewStyle> }) {
  return <View style={[s.row, style]}>{children}</View>;
}

const s = StyleSheet.create({
  primary: {
    backgroundColor: color.plum,
    borderRadius: radius.lg,
    paddingVertical: 17,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 55,
  },
  primaryLabel: { fontFamily: font.semibold, fontSize: 15.5, color: '#fff' },
  buttonOff: { opacity: 0.45 },

  field: {
    borderWidth: 1,
    borderColor: color.borderDark,
    backgroundColor: color.surface,
    borderRadius: radius.lg,
    paddingVertical: 15,
    paddingHorizontal: 15,
    fontFamily: font.medium,
    fontSize: 15.5,
    color: color.ink,
  },
  fieldCode: {
    fontFamily: font.display,
    fontSize: 24,
    letterSpacing: 5,
    textAlign: 'center',
    paddingVertical: 17,
  },
  fieldProse: {
    minHeight: 82,
    paddingTop: 13,
    fontFamily: font.regular,
    fontSize: 14.5,
    lineHeight: 21,
    textAlignVertical: 'top',
  },
  fieldOff: { opacity: 0.5 },
  secondary: {
    borderWidth: 1,
    borderColor: color.borderDark,
    backgroundColor: color.surface,
    borderRadius: radius.lg,
    paddingVertical: 16,
    paddingHorizontal: 18,
    alignItems: 'center',
  },
  secondaryLabel: { fontFamily: font.semibold, fontSize: 15, color: color.ink },

  pill: { borderRadius: radius.pill, paddingVertical: 10, paddingHorizontal: 13 },
  pillLabel: { fontFamily: font.semibold, fontSize: 12.5 },

  back: {
    width: 34,
    height: 34,
    borderRadius: radius.pill,
    borderWidth: 1,
    borderColor: color.borderStrong,
    backgroundColor: color.surface,
    alignItems: 'center',
    justifyContent: 'center',
  },
  backOnDark: { width: 36, height: 36, borderWidth: 0, backgroundColor: 'rgba(255,255,255,0.9)' },
  backGlyph: { fontFamily: font.semibold, fontSize: 17, color: color.ink, marginTop: -2 },

  chip: { flexDirection: 'row', alignItems: 'center', gap: 7, borderRadius: radius.pill },
  chipLarge: { borderWidth: 1.5, paddingVertical: 12, paddingHorizontal: 15 },
  chipSmall: { borderWidth: 1, paddingVertical: 9, paddingHorizontal: 13 },
  chipOff: { opacity: 0.4 },
  chipMark: { fontFamily: font.medium, fontSize: 15, color: color.inkMuted },
  chipText: { fontFamily: font.medium, fontSize: 13 },
  chipTextLarge: { fontFamily: font.medium, fontSize: 14 },
  chipTextOn: { color: '#fff' },
  chipTextOff: { color: color.inkMuted },

  track: { width: 48, height: 28, borderRadius: radius.pill, padding: 3, flexDirection: 'row', alignItems: 'center' },
  knob: { width: 22, height: 22, borderRadius: radius.pill, backgroundColor: '#fff' },

  stepper: { flexDirection: 'row', alignItems: 'center', gap: 9 },
  stepBtn: {
    width: 27,
    height: 27,
    borderRadius: radius.pill,
    borderWidth: 1,
    borderColor: color.borderStrong,
    backgroundColor: color.screen,
    alignItems: 'center',
    justifyContent: 'center',
  },
  stepGlyph: { fontFamily: font.semibold, fontSize: 15, color: color.ink, marginTop: -1 },
  stepValue: {
    fontFamily: font.semibold,
    fontSize: 13.5,
    color: color.ink,
    minWidth: 46,
    textAlign: 'center',
  },

  servings: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 14,
    backgroundColor: color.sand,
    borderRadius: radius.pill,
    paddingVertical: 6,
    paddingHorizontal: 10,
  },
  servingsBtn: {
    width: 30,
    height: 30,
    borderRadius: radius.pill,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  servingsGlyph: { fontFamily: font.semibold, fontSize: 17, color: color.ink, marginTop: -2 },
  servingsValue: { fontFamily: font.semibold, fontSize: 16, color: color.ink, minWidth: 18, textAlign: 'center' },

  levels: { flexDirection: 'row', backgroundColor: color.sand, borderRadius: radius.pill, padding: 3 },
  levelBtn: { paddingVertical: 7, paddingHorizontal: 10, borderRadius: radius.pill },
  levelLabel: { fontFamily: font.semibold, fontSize: 11.5, color: color.mutedWarm },
  levelLabelOn: { color: '#fff' },

  check: { borderWidth: 1.5, alignItems: 'center', justifyContent: 'center' },
  checkGlyph: { fontFamily: font.semibold, fontSize: 12, color: '#fff', marginTop: -1 },

  row: { flexDirection: 'row', alignItems: 'center' },
});
