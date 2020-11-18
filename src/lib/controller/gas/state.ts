/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { createDomain, createEvent } from 'effector';

import { GasState } from 'types';

export const gasStoreUpdate = createEvent<GasState>();
export const GasStoreReset = createEvent();

const GasDomain = createDomain();
const initalState: GasState = {
  gasPrice: '2000',
  gasLimit: '1'
};
export const gasStore = GasDomain
  .store<GasState>(initalState)
  .reset(GasStoreReset)
  .on(gasStoreUpdate, (_, value) => value);