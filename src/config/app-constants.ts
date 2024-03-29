/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { ZilliqaNetwork } from 'types';

export const ORDERS = {
  TRANSAK_URL: 'https://global.transak.com/',
  FAUCET: 'https://dev-wallet.zilliqa.com/faucet'
};

export enum ZRC2Fields {
  Balances = 'balances',
  TotalSupply = 'total_supply',
  Pools = 'pools',
  Allowances = 'allowances',
  LiquidityFee = 'liquidity_fee',
  ProtocolFee = 'protocol_fee',
  RewardsPool = 'rewards_pool'
}

export const API_RATE = 'https://api.zilpay.io/api/v1';
export const NIL_ADDRESS = '0x0000000000000000000000000000000000000000';
export const NIL_ADDRESS_BECH32 = 'zil1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq9yf6pz';
export const UD_CONTRACT_ADDRESS = '0x9611c53be6d1b32058b2747bdececed7e1216793';
export const SCAM_TOKEN = '0xe66593414Ba537e965b5e0eB723a58b4d1fACc89';
export const APP_EXPLORER = '0xf27a87c0a82f7ddb1daed81904fcbee253d9fc29';
export const PASSWORD_DIFFICULTY = 6;
export const MAX_NAME_DIFFICULTY = 15;
export const NONCE_DIFFICULTY = 10;
export const BLOCK_INTERVAL = 20000;
export const MAX_TX_QUEUE = 20;
export const MIN_POSTERS_CAHCE = 10;

export const ZILLIQA: ZilliqaNetwork = {
  mainnet: {
    PROVIDER: 'https://api.zilliqa.com',
    WS: 'wss://api-ws.zilliqa.com',
    MSG_VERSION: 1
  },
  testnet: {
    PROVIDER: 'https://dev-api.zilliqa.com',
    WS: 'wss://dev-ws.zilliqa.com',
    MSG_VERSION: 1
  },
  private: {
    PROVIDER: 'http://127.0.0.1:4200',
    WS: 'ws://127.0.0.1:4200',
    MSG_VERSION: 1
  }
};
export const ZILLIQA_KEYS = Object.keys(ZILLIQA);
const [mainnet, testnet] = ZILLIQA_KEYS;
export const DEFAULT_SSN = 'Main';
export const SSN_ADDRESS = {
  [mainnet]: '0xa7c67d49c82c7dc1b73d231640b2e4d0661d37c1',
  [testnet]: '0x05c2ddec2e4449160436130cb4f9b84de9f7ee5b'
};

export const MNEMONIC_PACH = "m/44'/313'/0'/0/index";
