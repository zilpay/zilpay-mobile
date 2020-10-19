/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { MobileStorage, buildObject } from '../storage';
import { STORAGE_FIELDS } from '../../config';
import { AccountState } from 'types';

export class AccountControler {
  private _storage = new MobileStorage();

  public async get(): Promise<AccountState | unknown> {
    return this._storage.get(STORAGE_FIELDS.ACCOUNTS);
  }

  public update(accountState: AccountState): Promise<void> {
    return this._storage.set(
      buildObject(STORAGE_FIELDS.ACCOUNTS, accountState)
    );
  }

  // public add() {}

  // public importPrvKey() {}

  // public export() {}
}
