/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { NativeModules } from 'react-native';

export function sha256(text: string): Promise<string> {
  return NativeModules.sha256(text);
}
