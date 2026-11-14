import { Alert, Platform } from 'react-native';

/** Une confirmation avant une action définitive, y compris sur le web. */
export function confirm(message: string, labels: { ok: string; cancel: string }, onOk: () => void) {
  if (Platform.OS === 'web') {
    if (globalThis.confirm?.(message)) onOk();
    return;
  }
  Alert.alert('', message, [
    { text: labels.cancel, style: 'cancel' },
    { text: labels.ok, style: 'destructive', onPress: onOk },
  ]);
}
