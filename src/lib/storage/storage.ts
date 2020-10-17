/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { AsyncStorage } from 'react-native';
import { buildObjectType } from './value-builder';

/**
 * Default class for working with browser Storage.
 * @example
 * import { BrowserStorage } from 'lib/storage'
 * new BrowserStorage().get('KEY')
 */
export class MobileStorage {

  /**
   * Set value by someting key.
   * @param {Object, String, Number, Array} value - Any value for set storage.
   * @returns {Promise<null | undefined>}
   * @example
   * import { BrowserStorage, buildObject } from 'lib/storage'
   * const storage = new BrowserStorage()
   * storage.set(
   *   buildObject('example-key', { example: 'set method'})
   * ).then(/ Do something... /)
   * // OR
   * storage.set([
   *   buildObject('key-1', new Object()),
   *   buildObject('key-2', new Object())
   *   //...
   * ]).then(/ Do something... /)
   */
  public set(value: buildObjectType | buildObjectType[]): Promise<void> {
    if (Array.isArray(value)) {
      const values = value.map((object) => [object.key, object.value]);

      return AsyncStorage.multiSet(values);
    }

    return AsyncStorage.setItem(value.key, value.value);
  }

  /**
   * Get value from storage by keys.
   * @param {String, Number} keys - key or keys.
   * @returns {Promise<Object | Array | String | Number>}
   * @example
   * import { BrowserStorage } from 'lib/storage'
   * const storage = new BrowserStorage()
   * storage.get(key).then(recievePaylod => / Do something... /)
   */
  public get(..._keys: string[]) {
    return AsyncStorage.multiGet(_keys);
  }

  /**
   * @returns {Object} - return all storage data values.
   * @example
   * import { BrowserStorage } from 'lib/storage'
   * const storage = new BrowserStorage()
   * storage.getAll(key).then(fullStorageObject => / Do something... /)
   */
  public getAll() {
    return AsyncStorage.getAllKeys();
  }

  /**
   * Remove one item from storage.
   * @param {String, Number} keys - key or keys.
   * @returns {Promise<null | undefined>}
   * @example
   * import { BrowserStorage } from 'lib/storage'
   * const storage = new BrowserStorage()
   * storage.rm('any-key-item').then(() => / Do something... /)
   */
  public rm(...keys: string[]) {
    AsyncStorage.multiRemove(keys);
  }

  /**
   * Clear all storage data.
   * @returns {Promise<null | undefined>}
   * @example
   * import { BrowserStorage } from 'lib/storage'
   * const storage = new BrowserStorage()
   * storage.clear().then(() => / Do something... /)
   */
  public clear() {
    AsyncStorage.clear();
  }

}