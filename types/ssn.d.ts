/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */

export interface SSN {
  name: string;
  api: string;
  address: string;
  id: number;
  time: number;
  ok: boolean;
}

export interface SSNState {
  selected: string;
  list: SSN[];
}
