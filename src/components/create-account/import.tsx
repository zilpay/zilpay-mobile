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
  Text,
  TextInput,
  Dimensions,
  StyleSheet
} from 'react-native';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { useTheme } from '@react-navigation/native';

import { CustomButton } from 'app/components/custom-button';
import { CustomTextInput } from 'app/components/custom-text-input';
import { Passwordinput } from 'app/components/password-input';
import ProfileSVG from 'app/assets/icons/profile.svg';

import i18n from 'app/lib/i18n';
import { keystore } from 'app/keystore';
import { fonts } from 'app/styles';

type Prop = {
  biometricEnable: boolean;
  onImported: () => void;
};

const { height } = Dimensions.get('window');
const variants = [
  'Private Key',
  'Ledger'
];
export const ImportAccount: React.FC<Prop> = ({
  biometricEnable,
  onImported
}) => {
  const { colors } = useTheme();
  const accountState = keystore.account.store.useValue();

  const [loading, setLoading] = React.useState(false);
  const [selected] = React.useState(variants[0]); // TODO: add the ledger type.
  const [lastindex, setlastindex] = React.useState(keystore.account.lastIndexLedger);
  const [accName, setAccName] = React.useState(`Imported ${lastindex}`);
  const [ledgerIndex, setLedgerIndex] = React.useState(
    keystore.account.lastIndexLedger
  );
  const [privateKey, setPrivateKey] = React.useState<string | null>(null);
  const [privKeyErr, setPrivKeyErr] = React.useState('');
  const [password, setPassword] = React.useState<string | undefined>();
  const [passwordError] = React.useState(' '); // TODO: add password error.

  const disabled = React.useMemo(() => {
    if (variants[0] === selected) {
      return !privateKey || !accName;
    } else if (variants[1] === selected) {
      return isNaN(Number(ledgerIndex)) || !accName;
    }
  }, [privateKey, accName, ledgerIndex]);

  const handleimport = React.useCallback(async() => {
    setLoading(true);
    if (variants[0] === selected && privateKey) {
      try {
        await keystore.addPrivateKeyAccount(
          privateKey,
          accName,
          password
        );
        onImported();
      } catch (err) {
        setPrivKeyErr((err as Error).message);
      }
    }

    if (variants[1] === selected) {
      //
    }

    setLoading(false);
  }, [password, privateKey, selected, accName, onImported, setPrivKeyErr]);
  const hanldeLedgerChange = React.useCallback((num) => {
    const index = Number(num);

    if (!isNaN(index)) {
      setLedgerIndex(index);
    }
  }, [setLedgerIndex]);
  const hanldeChangePrivKey = React.useCallback((value) => {
    setPrivKeyErr('');
    setPrivateKey(value);
  }, [setPrivateKey, setPrivKeyErr]);

  React.useEffect(() => {
    if (selected === variants[0]) {
      setAccName(i18n.t('acc_name_key', {
        index: keystore.account.lastIndexPrivKey
      }));
    } else if (selected === variants[1]) {
      setAccName(i18n.t('acc_name_ledger', {
        index: keystore.account.lastIndexLedger
      }));
    }
  }, [selected, accountState, setlastindex]);

  return (
    <KeyboardAwareScrollView>
      <CustomTextInput
        Icon={ProfileSVG}
        defaultValue={accName}
        onChangeText={setAccName}
        style={{
          marginTop: 16
        }}
        placeholder={i18n.t('pass_setup_input0')}
        labelText={i18n.t('pass_setup_label0')}
      />
      <View style={styles.wrapper}>
        {variants[0] === selected ? (
          <View>
            <TextInput
              multiline={true}
              numberOfLines={10}
              style={[styles.text, {
                borderColor: colors.border,
                color: colors.text
              }]}
              autoCorrect={false}
              placeholder={i18n.t('import_private_key_placeholder')}
              placeholderTextColor={colors.border}
              onChangeText={hanldeChangePrivKey}
            />
            <Text style={[styles.errorMessage, {
              color: colors['danger']
            }]}>
              {privKeyErr}
            </Text>
            {!biometricEnable ? (
              <Passwordinput
                style={{ marginVertical: 15 }}
                passwordError={passwordError}
                placeholder={i18n.t('pass_setup_input1')}
                onChange={setPassword}
              />
            ) : null}
          </View>
        ) : null}
        {variants[1] === selected ? (
          <TextInput
            value={String(ledgerIndex)}
            keyboardType={'numeric'}
            autoCorrect={false}
            style={[styles.text, {
              borderColor: colors.border,
              color: colors.text
            }]}
            onChangeText={hanldeLedgerChange}
          />
        ) : null}
        <CustomButton
          style={{ marginTop: 15 }}
          title={i18n.t('import_account')}
          disabled={disabled}
          isLoading={loading}
          onPress={handleimport}
        />
      </View>
    </KeyboardAwareScrollView>
  );
};

const styles = StyleSheet.create({
  wrapper: {
    paddingHorizontal: 15,
    justifyContent: 'space-around'
  },
  errorMessage: {
    fontSize: 13,
    marginLeft: 5,
    fontFamily: fonts.Demi
  },
  text: {
    marginTop: 15,
    height: height / 5,
    borderWidth: 1,
    borderRadius: 8,
    padding: 20,
    fontFamily: fonts.Regular,
    fontSize: 16
  }
});