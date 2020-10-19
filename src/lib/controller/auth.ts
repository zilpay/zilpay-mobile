/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import { sha256, Encryptor, EncryptedType } from '../crypto';

export interface Auth {
  getEncrypted: () => EncryptedType;
  encryptVault: (decrypted: string) => Promise<EncryptedType>;
  decryptVault: () => Promise<string>;
}

export async function AuthControler(password: string, encryptedContent?: EncryptedType): Promise<Auth> {
  const encryptor = new Encryptor();
  const _hashSum = await sha256(password);
  let _encrypted = encryptedContent;

  return {
    getEncrypted() {
      if (!_encrypted) {
        throw new Error('encrypted has not initialized');
      }

      return _encrypted;
    },
    async encryptVault(decrypted: string) {
      _encrypted = await encryptor.encrypt(_hashSum, decrypted);

      return _encrypted;
    },
    decryptVault() {
      if (!_encrypted) {
        throw new Error('encrypted has not initialized');
      }

      return encryptor.decrypt(_hashSum, _encrypted);
    }
  };
}
