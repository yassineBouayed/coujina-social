import React, { useEffect, useState } from 'react';
import { ActivityIndicator } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';

import { useI18n } from '../../src/i18n';
import { useSession } from '../../src/session';
import { color } from '../../src/theme';
import { BackButton } from '../../src/ui/controls';
import { Screen } from '../../src/ui/primitives';
import { Empty } from '../../src/ui/social';

/** Le lien d'invitation `coujinasocial://u/<username>` : il ouvre le profil. */
export default function InviteLink() {
  const { username } = useLocalSearchParams<{ username: string }>();
  const router = useRouter();
  const { t } = useI18n();
  const { api } = useSession();
  const [missing, setMissing] = useState(false);

  useEffect(() => {
    if (!api || !username) return;
    api.profileByUsername(username).then((id) => {
      if (id) router.replace(`/user/${id}`);
      else setMissing(true);
    }).catch(() => setMissing(true));
  }, [api, username, router]);

  return (
    <Screen>
      <BackButton onPress={() => router.replace('/')} />
      {missing ? <Empty>{t('recipe.notFound')}</Empty> : <ActivityIndicator color={color.plum} />}
    </Screen>
  );
}
