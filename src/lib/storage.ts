// import SecureStorage from 'react-native-secure-storage';
import { ACCESS_CONTROL, ACCESSIBLE, AUTHENTICATION_TYPE } from 'react-native-secure-storage';

/**
 * Default Storage encrypt and decrypt some data
 * more information [react-native-secure-storage](https://www.npmjs.com/package/react-native-secure-storage)
 */
export class Storage {
  private config: {
    accessControl: string;
    accessible: string;
    authenticationPrompt: string;
    service: string;
    authenticateType: string;
  };
  constructor() {
    this.config = {
      accessControl: ACCESS_CONTROL.BIOMETRY_ANY_OR_DEVICE_PASSCODE,
      accessible: ACCESSIBLE.WHEN_UNLOCKED,
      authenticationPrompt: 'auth with yourself',
      service: 'ZilPay',
      authenticateType: AUTHENTICATION_TYPE.BIOMETRICS,
    };
  }
}
