import React from 'react';
import { useLocalSearchParams, useRouter } from 'expo-router';

import { LEGAL } from '../../src/legal.generated';
import { BackButton } from '../../src/ui/controls';
import { Markdown } from '../../src/ui/Markdown';
import { Screen } from '../../src/ui/primitives';

/** Les CGU ou la politique de confidentialité, embarquées : lisibles hors ligne. */
export default function LegalScreen() {
  const { doc } = useLocalSearchParams<{ doc: string }>();
  const router = useRouter();
  const source = doc === 'privacy' ? LEGAL.privacy : LEGAL.cgu;
  return (
    <Screen>
      <BackButton onPress={() => router.back()} />
      <Markdown source={source} />
    </Screen>
  );
}
