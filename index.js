/**
 * @format
 */
import './shim';

require('react-native-browser-polyfill');

import { AppRegistry } from 'react-native';
import root from './src/root';
import { name as appName } from './app.json';

AppRegistry.registerComponent(appName, () => root);
