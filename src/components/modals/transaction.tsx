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
  ScrollView,
  ViewStyle
} from 'react-native';
import Modal from 'react-native-modal';
import Share from 'react-native-share';
import { useTheme } from '@react-navigation/native';
import Clipboard from '@react-native-community/clipboard';

import { ModalTitle } from 'app/components/modal-title';
import { ModalWrapper } from 'app/components/modal-wrapper';
import { ViewButton } from 'app/components/view-button';

import ProfileSVG from 'app/assets/icons/profile.svg';
import ViewBlockIconSVG from 'app/assets/icons/view-block.svg';
import ShareIconSVG from 'app/assets/icons/share.svg';

import { KeyValue } from 'app/components/key-value';

import i18n from 'app/lib/i18n';
import { keystore } from 'app/keystore';
import { StoredTx } from 'types';
import { fromZil, nFormatter, trim } from 'app/filters';
import { viewTransaction } from 'app/utils/view-block';
import { toBech32Address } from 'app/utils/bech32';
import { toChecksumAddress } from 'app/utils/address';
import { ADDRESS_FORMATS } from 'app/config';

type Prop = {
  style?: ViewStyle;
  visible: boolean;
  transaction?: StoredTx;
  onTriggered: () => void;
  onViewBlock: (url: string) => void;
};

export const TransactionModal: React.FC<Prop> = ({
  style,
  transaction,
  visible,
  onTriggered,
  onViewBlock
}) => {
  if (!transaction) {
    return null;
  }

  const { colors } = useTheme();
  const settingsState = keystore.settings.store.useValue();

  const toAddr = React.useMemo(() => {
    let address = transaction.toAddr;
    const [bech32, base16] = ADDRESS_FORMATS;

    if (settingsState.addressFormat === bech32) {
      address = toBech32Address(address);
    } else if (settingsState.addressFormat === base16) {
      address = toChecksumAddress(address);
    }

    return trim(address);
  }, [settingsState, transaction]);
  const amountValue = React.useMemo(() => {
    if (typeof transaction.success !== 'undefined' && !transaction.success) {
      return '0';
    }

    return `-${nFormatter(fromZil(transaction.amount, transaction.token.decimals))}`;
  }, [transaction]);

  const handleShare = React.useCallback(() => {
    const url = viewTransaction(transaction.hash, keystore.network.selected);
    const shareOptions = {
      url,
      title: `Transaction`
    };
    Share.open(shareOptions)
      .then(() => null)
      .catch(() => null);
  }, [transaction]);
  const hanldeCopy = React.useCallback(() => {
    Clipboard.setString(transaction.hash);
  }, [transaction]);
  const handleViewTx = React.useCallback(() => {
    const url = viewTransaction(transaction.hash, keystore.network.selected);

    onViewBlock(url);
  }, [onViewBlock]);

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
          {i18n.t('history_tx_details')}
        </ModalTitle>
        <ScrollView style={styles.wrapper}>
          <KeyValue title={i18n.t('method')}>
            {transaction.teg}
          </KeyValue>
          {transaction.info ? (
            <KeyValue title={i18n.t('sorting_item0')}>
              {i18n.t(transaction.info)}
            </KeyValue>
          ) : null}
          <KeyValue title={i18n.t('transfer_amount')}>
            {amountValue} {transaction.token.symbol}
          </KeyValue>
          <KeyValue title={i18n.t('nonce')}>
            #{transaction.nonce}
          </KeyValue>
          <KeyValue title={i18n.t('timestamp')}>
            {new Date(transaction.timestamp).toDateString()}
          </KeyValue>
          <KeyValue title={i18n.t('to_address')}>
            {toAddr}
          </KeyValue>
          <KeyValue title={i18n.t('from')}>
            {trim(transaction.from)}
          </KeyValue>
          <KeyValue
            title={i18n.t('tx_hash')}
            border={false}
          >
            0x{trim(transaction.hash)}
          </KeyValue>
        </ScrollView>
        <View style={styles.linkWrapper}>
          <ViewButton
            icon={ShareIconSVG}
            onPress={handleShare}
          >
            {i18n.t('share')}
          </ViewButton>
          <ViewButton
            icon={ProfileSVG}
            onPress={hanldeCopy}
          >
            {i18n.t('copy_hash')}
          </ViewButton>
          <ViewButton
            icon={ViewBlockIconSVG}
            onPress={handleViewTx}
          >
            {i18n.t('view_block')}
          </ViewButton>
        </View>
      </ModalWrapper>
    </Modal>
  );
};

const styles = StyleSheet.create({
  wrapper: {
    paddingTop: 20
  },
  linkWrapper: {
    paddingVertical: 20,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-evenly'
  }
});
