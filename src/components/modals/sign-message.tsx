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
  StyleSheet,
  ViewStyle,
  View,
  Dimensions,
  Text
} from 'react-native';
import Modal from 'react-native-modal';
import { useTheme } from '@react-navigation/native';
import TransportBLE from '@ledgerhq/react-native-hw-transport-ble';
import FastImage from 'react-native-fast-image';

import { ModalTitle } from 'app/components/modal-title';
import { ModalWrapper } from 'app/components/modal-wrapper';
import { Switcher } from 'app/components/switcher';
import { CustomButton } from 'app/components/custom-button';
import { Passwordinput } from 'app/components/password-input';
import { ErrorMessage } from 'app/components/error-message';

import i18n from 'app/lib/i18n';
import { Signature, Account } from 'types';
import { LedgerController } from 'app/lib/controller/connect/ledger';
import { sha256 } from 'app/lib/crypto/sha256';
import { keystore } from 'app/keystore';
import { SchnorrControl } from 'app/lib/controller/elliptic';
import { fonts } from 'app/styles';
import { AccountTypes } from 'app/config';

type Prop = {
  style?: ViewStyle;
  visible: boolean;
  title: string;
  icon?: string;
  payload?: string;
  appTitle?: string;
  account: Account;
  needPassword?: boolean;
  onTriggered: () => void;
  onSign: (sig: Signature) => void;
};

const { width } = Dimensions.get('window');
export const SignMessageModal: React.FC<Prop> = ({
  style,
  visible,
  title,
  icon,
  payload,
  appTitle,
  account,
  needPassword,
  onTriggered,
  onSign
}) => {
  const { colors } = useTheme();
  const [isHash, setIsHash] = React.useState(false);
  const [loading, setLoading] = React.useState(false);
  const [hash, setHash] = React.useState('');
  const [passowrd, setPassowrd] = React.useState<string>('');
  const [error, setError] = React.useState<string>();

  const handleSign = React.useCallback(async() => {
    setLoading(true);
    setError(undefined);
    if (!payload || !hash) {
      return null;
    }

    try {
      let signature = '';

      if (account.type === AccountTypes.Ledger) {
        const transport = await TransportBLE.open(account.mac);
        const ledger = new LedgerController(transport);

        signature = await ledger.signHash(account.index, hash);
      } else {
        const bytes = Buffer.from(hash, 'hex');
        const keyPair = await keystore.getkeyPairs(account, passowrd);
        const schnorrControl = new SchnorrControl(keyPair.privateKey);

        signature = await schnorrControl.getSignature(bytes);
      }

      onSign({
        signature,
        message: payload,
        publicKey: account.pubKey
      });
    } catch (err) {
      setError((err as Error).message);
    }
    setPassowrd('');
    setLoading(false);
  }, [hash, account, payload, passowrd]);

  React.useEffect(() => {
    if (payload) {
      sha256(payload).then(setHash);
    }
  }, [payload]);

  if (!icon || !payload || !appTitle) {
    return null;
  }

  return (
    <Modal
      isVisible={visible}
      style={{
        justifyContent: 'flex-end',
        margin: 0,
        marginBottom: 1
      }}
      backdropColor={colors['modal']}
      onBackdropPress={onTriggered}
    >
      <ModalWrapper style={style}>
        <ModalTitle onClose={onTriggered}>
          {appTitle} {title}
        </ModalTitle>
        <View style={styles.wrapper}>
          <FastImage
            style={styles.icon}
            source={{ uri: icon }}
          />
          <ErrorMessage>
            {error}
          </ErrorMessage>
          <Text style={[styles.desc, {
            color: colors.border
          }]}>
            {i18n.t('sign_des')}
          </Text>
          <Switcher
            style={styles.switcher}
            enabled={isHash}
            onChange={setIsHash}
          >
            <Text style={[styles.wwitcherText, {
              color: colors.notification
            }]}>
              {isHash ? 'Hash' : 'Payload'}
            </Text>
          </Switcher>
          <View style={[styles.sigWrapper, {
            backgroundColor: colors.background
          }]}>
            <Text style={[styles.sig, {
              color: colors.text
            }]}>
              {isHash ? hash : payload}
            </Text>
          </View>
          {needPassword && account.type !== AccountTypes.Ledger ? (
            <Passwordinput
              style={{
                marginVertical: 15
              }}
              placeholder={i18n.t('pass_setup_input1')}
              onChange={setPassowrd}
            />
          ) : null}
          <CustomButton
            style={styles.signBtn}
            title={i18n.t('sign')}
            isLoading={loading}
            disabled={Boolean((needPassword && account.type !== AccountTypes.Ledger) && !passowrd)}
            onPress={handleSign}
          />
        </View>
      </ModalWrapper>
    </Modal>
  );
};

const styles = StyleSheet.create({
  wwitcherText: {
    fontSize: 13,
    fontFamily: fonts.Demi
  },
  wrapper: {
    alignItems: 'center',
    marginVertical: 30
  },
  desc: {
    fontSize: 17,
    fontFamily: fonts.Regular
  },
  switcher: {
    alignSelf: 'flex-end',
    marginVertical: 15
  },
  icon: {
    height: 30,
    width: 30,
    marginVertical: 15
  },
  sigWrapper: {
    alignItems: 'flex-start',
    width: '100%',
    borderRadius: 8
  },
  sig: {
    fontSize: 13,
    fontFamily: fonts.Regular,
    padding: 10,
    margin: 15,
    minHeight: 100
  },
  signBtn: {
    minWidth: width / 2,
    marginTop: 16
  },
  cancelBtn: {
    minWidth: width / 4
  }
});
