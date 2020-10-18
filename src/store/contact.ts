/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { createDomain } from 'effector';
import { Contact } from 'types';

const ContactDomain = createDomain();
const initalState: Contact[] = [];
const store = ContactDomain.store(initalState);

export default {
  store
};
