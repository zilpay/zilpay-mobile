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
  TouchableOpacity,
  Dimensions
} from 'react-native';
import { useTheme } from '@react-navigation/native';

import ArrowIconSVG from 'app/assets/icons/arrow.svg';
import WalletIconSVG from 'app/assets/icons/wallet.svg';

import { TokensModal } from 'app/components/modals';
import { LoadSVG } from 'app/components/load-svg';

import i18n from 'app/lib/i18n';
import { keystore } from 'app/keystore';
import { fromZil, nFormatter, toConversion, toLocaleString } from 'app/filters';
import { Token, Account } from 'types';
import styles from './styles';
import { toBech32Address } from 'app/utils/bech32';

type Prop = {
  tokens: Token[];
  account: Account;
  selected: number;
  netwrok: string;
  onSelect: (index: number) => void;
};

const { width } = Dimensions.get('window');
export const TransferToken: React.FC<Prop> = ({
  tokens,
  selected,
  account,
  netwrok,
  onSelect
}) => {
  const { colors } = useTheme();
  const settingsState = keystore.settings.store.useValue();
  const currencyState = keystore.currency.store.useValue();

  const [tokenModal, setTokenModal] = React.useState(false);

  const token = React.useMemo(
    () => tokens[selected],
    [tokens, selected]
  );
  const converted = React.useMemo(() => {
    const { decimals, symbol } = token;
    const balanceValue = account.balance[netwrok][symbol];
    const rate = settingsState.rate[currencyState] * (token.rate || 0);
    const convert = toConversion(balanceValue, rate, decimals);

    return `${nFormatter(convert)} ${currencyState}`;
  }, [token, selected, netwrok, currencyState]);
  const balance = React.useMemo(() => {
    const { symbol, decimals } = token;
    const amount = fromZil(
      account.balance[netwrok][symbol],
      decimals
    );

    return nFormatter(amount);
  }, [netwrok, account, token]);

  return (
    <React.Fragment>
      <TouchableOpacity
        style={styles.item}
        onPress={() => setTokenModal(true)}
      >
        <WalletIconSVG />
        <View style={[styles.itemInfo, {
          borderWidth: 0
        }]}>
          <Text style={[styles.label, {
            color: colors.border
          }]}>
            {i18n.t('token')}
          </Text>
          <View style={{ flexDirection: 'row' }}>
            <LoadSVG
              height="30"
              width="30"
              addr={toBech32Address(token.address[netwrok])}
            />
            <View style={{ marginLeft: 5 }}>
              <View style={[styles.infoWrapper, { width: width - 120 }]}>
                <Text style={[styles.nameAmountText, {
                  color: colors.text
                }]}>
                  {token.symbol}
                </Text>
                <Text style={[styles.nameAmountText, {
                  color: colors.text
                }]}>
                  {balance} {token.symbol}
                </Text>
              </View>
              <View style={[styles.infoWrapper, {
                marginBottom: 15,
                width: width - 120
              }]}>
                <Text style={[styles.addressAmount, {
                  color: colors.border
                }]}>
                  {token.name}
                </Text>
                <Text style={[styles.addressAmount, {
                  color: colors.border
                }]}>
                  {converted}
                </Text>
              </View>
            </View>
          </View>
        </View>
        <ArrowIconSVG
          fill={colors.notification}
          style={styles.arrowIcon}
        />
      </TouchableOpacity>
      <TokensModal
        title={i18n.t('transfer_modal_title0')}
        visible={tokenModal}
        network={netwrok}
        account={account}
        tokens={tokens}
        selected={selected}
        onTriggered={() => setTokenModal(false)}
        onSelect={onSelect}
      />
    </React.Fragment>
  );
};
