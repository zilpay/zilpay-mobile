/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */

import React from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  Dimensions,
  Text,
  Button
} from 'react-native';
import { NavigationScreenProp, NavigationState } from 'react-navigation';

import { theme } from 'app/styles';

import CreateBackground from 'app/assets/get_started_1.svg';

import i18n from 'app/lib/i18n';

type Prop = {
  navigation: NavigationScreenProp<NavigationState>;
};

const { width } = Dimensions.get('window');
export const InitSuccessfullyPage: React.FC<Prop> = ({ navigation }) => {
  const hanldeOK = React.useCallback(() => {
    navigation.navigate('Home');
  }, [navigation]);

  return (
    <SafeAreaView style={styles.container}>
      <View style={[StyleSheet.absoluteFill, styles.backgroundImage]}>
        <CreateBackground
          width={width + width / 4}
          height={width + width / 4}
        />
      </View>
      <View style={styles.wrapper}>
        <Text style={styles.title}>
          {i18n.t('successfully_title')}
        </Text>
        <Button
          color={theme.colors.primary}
          title={i18n.t('successfully_btn')}
          onPress={hanldeOK}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.black
  },
  backgroundImage: {
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: '40%'
  },
  wrapper: {
    height: '90%',
    alignItems: 'center',
    justifyContent: 'flex-end'
  },
  title: {
    fontWeight: 'bold',
    color: theme.colors.white,
    lineHeight: 41,
    fontSize: 34,
    textAlign: 'center',
    marginBottom: 100
  }
});

export default InitSuccessfullyPage;