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
  Text,
  TouchableOpacity,
  ViewStyle
} from 'react-native';
import { useTheme } from '@react-navigation/native';

import { LoadSVG } from 'app/components/load-svg';
import ContextMenu from 'react-native-context-menu-view';

import { Token, Account } from 'types';
import {
  toConversion,
  fromZil,
  nFormatter
} from 'app/filters';
import i18n from 'app/lib/i18n';
import { fonts } from 'app/styles';
import { keystore } from 'app/keystore';
import { toBech32Address } from 'app/utils/bech32';

export type Prop = {
  token: Token;
  account: Account;
  net: string;
  currency: string;
  canRemove: boolean;
  style?: ViewStyle;
  onPress?: () => void;
  onRemove?: (token: Token) => void;
  onSend?: (token: Token) => void;
  onView?: (token: Token) => void;
  onSwap?: (token: Token) => void;
};

export const TokenCard: React.FC<Prop> = ({
  token,
  net,
  account,
  canRemove,
  currency,
  style,
  onPress = () => null,
  onRemove = () => null,
  onSend = () => null,
  onView = () => null,
  onSwap = () => null
}) => {
  const settingsState = keystore.settings.store.useValue();
  const { colors } = useTheme();
  const actions = React.useMemo(() => [
    {
      title: i18n.t('send'),
      press: onSend
    },
    {
      title: i18n.t('show_on_viewblock'),
      systemIcon: 'circlebadge',
      press: onView
    },
    {
      title: i18n.t('trade'),
      systemIcon: 'circlebadge',
      disabled: token.symbol === 'ZIL',
      press: onSwap
    },
    {
      title: i18n.t('hide'),
      systemIcon: 'trash',
      destructive: true,
      disabled: canRemove,
      press: onRemove
    }
  ], [canRemove]);
  /**
   * ZIL(Default token) amount in float.
   */
  const amount = React.useMemo(
    () => fromZil(account.balance[net][token.symbol], token.decimals),
    [token, account, net]
  );
  /**
   * Converted to BTC/USD/ETH.
   */
  const conversion = React.useMemo(() => {
    const balance = account.balance[net][token.symbol];
    const zilRate = settingsState.rate[currency];
    const tokenRate = (token.rate || 0) * zilRate;

    return toConversion(balance, tokenRate, token.decimals);
  }, [token, account, net, settingsState, currency]);

  const hanldeSelect = React.useCallback(({ nativeEvent }) => {
    const { index } = nativeEvent;

    actions[index].press(token);
  }, [actions, token]);

  return (
    <ContextMenu
      style={[styles.container, style]}
      previewBackgroundColor="transparent"
      actions={actions}
      onPress={hanldeSelect}
    >
      <TouchableOpacity
        style={[styles.wrapper, {
          backgroundColor: colors['card1']
        }]}
        onPress={onPress}
      >
        <View style={styles.header}>
          <Text style={[styles.symbol, {
            color: colors.notification
          }]}>
            {token.symbol}
          </Text>
          <LoadSVG
            height="30"
            width="30"
            addr={toBech32Address(token.address[net])}
          />
        </View>
        <View>
          <Text style={[styles.zilAmount, {
            color: colors.text
          }]}>
            {nFormatter(amount)}
          </Text>
          <Text style={[styles.convertedAmount, {
            color: colors.notification
          }]}>
            {nFormatter(conversion)} {currency.toUpperCase()}
          </Text>
        </View>
      </TouchableOpacity>
    </ContextMenu>
  );
};

const styles = StyleSheet.create({
  container: {
    borderRadius: 8,
    width: '47%'
  },
  wrapper: {
    borderRadius: 8,
    minHeight: 90,
    maxHeight: 120,
    padding: 10
  },
  header: {
    width: '100%',
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between'
  },
  symbol: {
    fontFamily: fonts.Demi,
    fontSize: 14
  },
  zilAmount: {
    fontSize: 17,
    fontFamily: fonts.Bold
  },
  convertedAmount: {
    fontFamily: fonts.Regular,
    fontSize: 13
  }
});
