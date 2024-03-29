/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { ADDRESS_FORMATS } from 'app/config';
import { newRidgeState } from 'react-ridge-state';
import { Settings } from 'types';
import { DEFAULT_CURRENCIES } from 'app/config/currency';

const [usd, eth, btc] = DEFAULT_CURRENCIES;

const initalState: Settings = {
  addressFormat: ADDRESS_FORMATS[0],
  rate: {
    [usd]: 0,
    [eth]: 0,
    [btc]: 0
  },
  formated: true
};
export const settingsStore = newRidgeState<Settings>(initalState);

export function settingsStoreUpdate(payload: Settings) {
  settingsStore.set(() => ({
    ...initalState,
    ...payload
  }));
}
export function settingsStoreSetAddressFormat(addressFormat: string) {
  settingsStore.set((prevState) => ({
    ...prevState,
    addressFormat
  }));
}
export function settingsToggleFormat() {
  settingsStore.set((prevState) => ({
    ...prevState,
    formated: !prevState.formated
  }));
}
export function settingsStoreReset() {
  settingsStore.reset();
}
