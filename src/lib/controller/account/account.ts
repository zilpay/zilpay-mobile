/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import type { AccountState, Account, KeyPair, RPCResponse } from 'types';

import { MobileStorage, buildObject } from 'app/lib/storage';
import WebView from 'react-native-webview';
import Big from 'big.js';
import {
  STORAGE_FIELDS,
  AccountTypes,
  ZILLIQA_KEYS,
  Messages,
  MAX_NAME_DIFFICULTY,
  NIL_ADDRESS,
  ZRC2Fields
} from 'app/config';
import {
  getAddressFromPublicKey,
  getPubKeyFromPrivateKey,
  tohexString
} from 'app/utils/address';
import { toBech32Address } from 'app/utils/bech32';
import { deppUnlink } from 'app/utils/deep-unlink';
import {
  accountStore,
  accountStoreReset,
  accountStoreUpdate,
  accountStoreSelect
} from './sate';
import { TokenControll } from 'app/lib/controller/tokens';
import { ZilliqaControl } from 'app/lib/controller/zilliqa';
import { NetworkControll } from 'app/lib/controller/network';
import { Message } from 'app/lib/controller/inject/message';
import { connectStore } from 'app/lib/controller/connect';
import { Methods } from 'app/lib/controller/zilliqa/methods';
import { dexStore } from 'app/lib/controller/dex';

Big.PE = 99;

export class AccountControler {
  public store = accountStore;
  private _storage: MobileStorage;
  private _token: TokenControll;
  private _zilliqa: ZilliqaControl;
  private _netwrok: NetworkControll;
  private _webView: WebView | undefined;
  private _origin: string | undefined;

  constructor(
    storage: MobileStorage,
    token: TokenControll,
    zilliqa: ZilliqaControl,
    netwrok: NetworkControll
  ) {
    this._storage = storage;
    this._token = token;
    this._zilliqa = zilliqa;
    this._netwrok = netwrok;
  }

  public get deContract() {
    const state = dexStore.get();
    return state.contract[this._netwrok.selected];
  }

  public get lastIndexPrivKey() {
    return this
      .store
      .get()
      .identities
      .filter((acc) => acc.type === AccountTypes.privateKey)
      .length;
  }

  public get lastIndexSeed() {
    return this
      .store
      .get()
      .identities
      .filter((acc) => acc.type === AccountTypes.Seed)
      .length;
  }

  public get lastIndexLedger() {
    return this
      .store
      .get()
      .identities
      .filter((acc) => acc.type === AccountTypes.Ledger)
      .length;
  }

  public updateWebView(webView: WebView | undefined, origin = '') {
    this._webView = webView;
    this._origin = origin;
  }

  public async sync(): Promise<AccountState> {
    try {
      const accounts = await this._storage.get<string>(
        STORAGE_FIELDS.ACCOUNTS
      );

      if (typeof accounts === 'string') {
        const parsed = JSON.parse(accounts);

        accountStoreUpdate(parsed);
      }
    } catch (err) {
      console.error('lib/accounts/sync', err);
      //
    }

    return this.store.get();
  }

  public async fromKeyPairs(acc: KeyPair, type: AccountTypes, name = ''): Promise<Account> {
    const pubKey = acc.publicKey;
    const base16 = getAddressFromPublicKey(pubKey);
    const bech32 = toBech32Address(base16);
    const balance = await this._tokenBalance(base16);

    return {
      base16,
      bech32,
      name,
      type,
      pubKey,
      balance,
      index: Number(acc.index)
    };
  }

  public getCurrentAccount() {
    const { identities, selectedAddress } = this.store.get();

    return identities[selectedAddress];
  }

  public reset() {
    accountStoreReset();

    return this.update(this.store.get());
  }

  public async removeAccount(account: Account) {
    const state = deppUnlink<AccountState>(this.store.get());

    state.identities = state.identities.filter(
      (acc) => account.base16 !== acc.base16
    );
    state.selectedAddress = state.identities.length - 1;

    await this.update(state);
  }

  public update(accountState: AccountState): Promise<void> {
    accountStoreUpdate(accountState);

    if (this._webView && this._origin) {
      const connections = connectStore.get();
      const isConnect = connections.some(
        (c) => c.domain.toLowerCase() === String(this._origin).toLowerCase()
      );
      const { base16, bech32 } = this.getCurrentAccount();
      this._webView.postMessage(new Message(Messages.init).serialize({
        isConnect,
        account: isConnect ? {
          base16,
          bech32
        } : null,
        isEnable: true,
        netwrok: this._netwrok.selected,
        http: this._netwrok.http
      }));
    }

    return this._storage.set(
      buildObject(STORAGE_FIELDS.ACCOUNTS, accountState)
    );
  }

  public updateAccountName(account: Account) {
    const accounts = this.store.get();

    if (account.name.length > MAX_NAME_DIFFICULTY) {
      return null;
    }

    accounts.identities = accounts.identities.map((acc) => {
      if (acc.base16 === account.base16) {
        return account;
      }

      return acc;
    });

    accountStoreUpdate(accounts);

    return this._storage.set(
      buildObject(STORAGE_FIELDS.ACCOUNTS, accounts)
    );
  }

  public async add(account: Account) {
    const accounts = await this._checkAccount(account);

    accounts
      .identities
      .push(account);
    accounts
      .selectedAddress = accounts.identities.length - 1;

    await this.update(accounts);

    return accounts;
  }

  public async fromPrivateKey(privatekey: string, name: string): Promise<Account> {
    const pubKey = getPubKeyFromPrivateKey(privatekey);
    const type = AccountTypes.privateKey;
    const base16 = getAddressFromPublicKey(pubKey);
    const bech32 = toBech32Address(base16);
    const balance = await this._tokenBalance(base16);
    const index = this.lastIndexPrivKey;

    return {
      base16,
      bech32,
      name,
      pubKey,
      type,
      balance,
      index
    };
  }

  public async selectAccount(index: number) {
    const { identities } = this.store.get();

    if (identities.length <= index) {
      return null;
    }

    accountStoreSelect(index);

    await this.update(this.store.get());
  }

  public async balanceUpdate() {
    const accounts = this.store.get();
    const account = accounts.identities[accounts.selectedAddress];

    if (accounts.identities.length > 0) {
      account.balance = await this._tokenBalance(account.base16);

      await this.update(deppUnlink(accounts));
    }
  }

  private async _checkAccount(account: Account) {
    const accounts = await this.sync();
    const isUnique = accounts.identities.some(
      (acc) => (acc.base16 === account.base16)
    );
    const isIndex = accounts.identities.some(
      (acc) => (acc.index === account.index) && (acc.type === account.type)
    );

    if (isUnique) {
      throw new Error('Account must be unique');
    } else if (isIndex) {
      throw new Error('Incorect index and account type');
    }

    return accounts;
  }

  private async _tokenBalance(base16: string) {
    const net = this._netwrok.selected;
    const zrc2Identities = this._token.store.get();
    const [ZIL] = zrc2Identities;
    const tokens = zrc2Identities.map((t) => [t.symbol, '0']);
    const entries = ZILLIQA_KEYS.map((n) => [n, Object.fromEntries(tokens)]);
    const balances = Object.fromEntries(entries);

    const address = tohexString(base16);
    const addr = String(base16).toLowerCase();
    const dexContract = tohexString(this.deContract);
    const balanceIdentities = zrc2Identities.map((token) => {
      if (token.address[net] === NIL_ADDRESS) {
        return this._zilliqa.provider.buildBody(
          Methods.getBalance,
          [address]
        );
      }

      return this._zilliqa.provider.buildBody(
        Methods.GetSmartContractSubState,
        [tohexString(token.address[net]), ZRC2Fields.Balances, [addr]]
      );
    });
    const tokensIdentities = zrc2Identities.filter(
      (t) => ZIL.symbol !== t.symbol && Boolean(t.address[net])
    );
    const tokensRates = tokensIdentities.map((token) => {
      const tokenAddress = token.address[net].toLowerCase();
      return this._zilliqa.provider.buildBody(
        Methods.GetSmartContractSubState,
        [dexContract, ZRC2Fields.Pools, [tokenAddress]]
      );
    });

    const identities = [...balanceIdentities, ...tokensRates];

    try {
      const replies: RPCResponse[] = await this._zilliqa.sendJson(...identities);
      const pools = replies.slice(balanceIdentities.length);
      const balanceList = replies.slice(0, balanceIdentities.length);
      const zrc2Balances = balanceList.map((res, index) => {
        const token = this._token.store.get()[index];

        let balance = [token.symbol, '0'];
        if (res.result && token.address[net] === NIL_ADDRESS) {
          balance = [token.symbol, res.result.balance];
        } else if (res.result) {
          const bal = res.result[ZRC2Fields.Balances][addr];
          balance = [token.symbol, bal];
        }

        return balance;
      });

      await this._token.updateRate(pools);

      balances[net] = Object.fromEntries(zrc2Balances);

      return balances;
    } catch (err) {
      return balances;
    }
  }
}
