/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { Contact } from 'types';

import { newRidgeState } from 'react-ridge-state';

const initalState: Contact[] = [];
export const contactsStore = newRidgeState<Contact[]>(initalState);

export function contactsStoreUpdate(payload: Contact[]) {
  contactsStore.set(() => payload);
}
export function contactsStoreReset() {
  contactsStore.reset();
}
