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
  TouchableOpacity,
  Text,
  TextInput,
  Dimensions
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { useTheme } from '@react-navigation/native';
import FastImage from 'react-native-fast-image';

import CreateBackground from 'app/assets/images/get_started_0.webp';
import LockSVG from 'app/assets/icons/lock.svg';
import FingerPrintIconSVG from 'app/assets/icons/fingerprint.svg';

import { Button } from 'app/components/button';

import i18n from 'app/lib/i18n';
import { keystore } from 'app/keystore';
import { RootParamList } from 'app/navigator';
import { fonts } from 'app/styles';

type Prop = {
  navigation: StackNavigationProp<RootParamList>;
};

const { width, height } = Dimensions.get('window');
export const LockPage: React.FC<Prop> = ({ navigation }) => {
  const { colors } = useTheme();
  const authState = keystore.guard.auth.store.useValue();
  const [password, setPassword] = React.useState('');
  const [passwordError, setPasswordError] = React.useState(' ');

  const color = React.useMemo(
    () => passwordError.length > 2 ? colors['danger'] : colors.notification,
    [passwordError, colors]
  );

  const hanldeUnlock = React.useCallback(async() => {
    try {
      await keystore.guard.unlock(password);

      navigation.navigate('App', { screen: 'Home' });
    } catch (err) {
      setPasswordError(i18n.t('lock_error'));
    }
  }, [navigation, password]);
  const hanldeInputPassword = React.useCallback((value) => {
    setPassword(value);
    setPasswordError(' ');
  }, [setPassword]);
  const hanldeBiometricUnlock = React.useCallback(async() => {
    try {
      await keystore.guard.unlock();

      return navigation.navigate('App', { screen: 'Home' });
    } catch (err) {
      setPasswordError(i18n.t('biometric_error'));
    }
  }, [navigation]);

  React.useEffect(() => {
    if (authState.biometricEnable) {
      hanldeBiometricUnlock();
    }

    keystore.theme.updateColors();
  }, []);

  return (
    <KeyboardAwareScrollView style={[styles.container, {
      backgroundColor: colors.background
    }]}>
      <View style={[StyleSheet.absoluteFill, styles.backgroundImage]}>
        <FastImage
          source={CreateBackground}
          style={styles.imageStyles}
        />
      </View>
      <View style={styles.pageContainer}>
        <Text style={[styles.title, {
          color: colors.text
        }]}>
          {i18n.t('lock_title')}
        </Text>
        <View>
          <View style={[styles.inputWrapper, { borderBottomColor: color }]}>
            <LockSVG fill={color} />
            <TextInput
              style={[styles.textInput, {
                color: colors.text
              }]}
              secureTextEntry={true}
              placeholder={i18n.t('pass_setup_input1')}
              placeholderTextColor={color}
              onChangeText={hanldeInputPassword}
              onSubmitEditing={hanldeUnlock}
            />
            {authState.biometricEnable ? (
              <TouchableOpacity onPress={hanldeBiometricUnlock}>
                <FingerPrintIconSVG
                  width={40}
                  height={40}
                />
              </TouchableOpacity>
            ) : null}
          </View>
          <Text style={[styles.errorMessage, {
            color: colors['danger']
          }]}>
            {passwordError}
          </Text>
        </View>
        <View style={styles.btnsWrapper}>
          <Button
            title={i18n.t('lock_btn1')}
            color={colors.notification}
            onPress={() => navigation.navigate('Unauthorized', {
              screen: 'LetStart'
            })}
          />
          <Button
            title={i18n.t('lock_btn')}
            color={colors.primary}
            onPress={hanldeUnlock}
          />
        </View>
      </View>
    </KeyboardAwareScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1
  },
  backgroundImage: {
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 190
  },
  imageStyles: {
    width,
    height: height - 100,
    resizeMode: 'contain'
  },
  textInput: {
    fontSize: 17,
    lineHeight: 22,
    fontFamily: fonts.Demi,
    padding: 10,
    width: '80%'
  },
  errorMessage: {
    fontFamily: fonts.Demi,
    marginTop: 4,
    lineHeight: 22
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    borderBottomWidth: 1
  },
  pageContainer: {
    height,
    padding: 60,
    justifyContent: 'flex-end'
  },
  title: {
    fontFamily: fonts.Bold,
    fontSize: 30
  },
  btnsWrapper: {
    flexDirection: 'row',
    justifyContent: 'space-between'
  }
});

export default LockPage;
