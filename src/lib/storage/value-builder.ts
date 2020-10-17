/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */

export type buildObjectType = {
  key: string;
  value: string;
};

/**
 * Through this class can build payload for write to browser Storage.
 * @example
 * import { buildObject, BrowserStorage } from 'lib/storage'
 * new BrowserStorage().set([
 *  buildObject('key', 'any payload or object or array')
 * ])
 */
export function buildObject(key: string, value: string | object): buildObjectType {
  let data = value;

  if (typeof value === 'object') {
    data = JSON.stringify(data);
  }

  return {
    key,
    value: String(data)
  };
}
