//
//  Bip39.swift
//  zilpayMobile
//
//  Created by Rinat on 19.10.2020.
//

import Foundation
//import TrezorCrypto

@objc(Mnemonic)

class Mnemonic: NSObject, RCTBridgeModule {

  static func moduleName() -> String!{
    return "Mnemonic";
  }
  
  static func requireMainQueueSetup () -> Bool {
    return true;
  }

//  @objc
//  func generateRandom(strength: Int = 128) -> Mnemonic {
//    let rawString = mnemonic_generate(Int32(strength))!
//    let value = String(cString: rawString)
//
//    let seed = Mnemonic.deriveSeed(mnemonic: value, passphrase: "")
//    return Mnemonic(value: value, seed: seed)
//  }

//  @objc
//  func isValid(_ string: String) -> Bool {
//    return mnemonic_check(string) != 0
//  }
}
