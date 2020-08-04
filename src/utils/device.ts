
import { Dimensions, Platform } from 'react-native';

import { OS } from 'src/config';

export class Device {
	public static getDeviceWidth() {
		return Dimensions.get('window').width;
	}

	public static getDeviceHeight() {
		return Dimensions.get('window').height;
	}

	public static isIos() {
		return Platform.OS === OS.IOS;
	}

	public static isAndroid() {
		return Platform.OS === OS.ANDROID;
	}

	public static isIpad() {
		return this.getDeviceWidth() >= 1000 || this.getDeviceHeight() >= 1000;
	}

	public static isLandscape() {
		return this.getDeviceWidth() > this.getDeviceHeight();
	}

	public static isIphone5() {
		return this.getDeviceWidth() === 320;
	}

	public static isIphone5S() {
		return this.getDeviceWidth() === 320;
	}

	public static isIphone6() {
		return this.getDeviceWidth() === 375;
	}

	public static isIphone6Plus() {
		return this.getDeviceWidth() === 414;
	}

	public static isIphone6SPlus() {
		return this.getDeviceWidth() === 414;
	}

	public static isIphoneX() {
		return this.getDeviceWidth() >= 375 && this.getDeviceHeight() >= 812;
	}

	public static isIpadPortrait9_7() {
		return this.getDeviceHeight() === 1024 && this.getDeviceWidth() === 736;
	}
	public static isIpadLandscape9_7() {
		return this.getDeviceHeight() === 736 && this.getDeviceWidth() === 1024;
	}

	public static isIpadPortrait10_5() {
		return this.getDeviceHeight() === 1112 && this.getDeviceWidth() === 834;
	}
	public static isIpadLandscape10_5() {
		return this.getDeviceWidth() === 1112 && this.getDeviceHeight() === 834;
	}

	public static isIpadPortrait12_9() {
		return this.getDeviceWidth() === 1024 && this.getDeviceHeight() === 1366;
	}

	public static isIpadLandscape12_9() {
		return this.getDeviceWidth() === 1366 && this.getDeviceHeight() === 1024;
	}

	public static isSmallDevice() {
		return this.getDeviceHeight() < 600;
	}

	public static isMediumDevice() {
		return this.getDeviceHeight() < 736;
	}
}