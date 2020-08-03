import RNFS from 'react-native-fs';

import { Device } from './device';

export class InjectScript {
    public entryScrip: string | null = null;
	// Cache inpage.js so that it is immediately available
    public async init() {
		this.entryScrip = Device.isIos()
			? await RNFS.readFile(`${RNFS.MainBundlePath}/inpage.js`, 'utf8')
			: await RNFS.readFileAssets(`inpage.js`);

		return this.entryScrip;
	}
	   public async get() {
		// Return from cache
		if (this.entryScrip) return this.entryScrip;

		// If for some reason it is not available, get it again
		return this.init();
	}
}
