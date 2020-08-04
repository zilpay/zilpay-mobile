import * as React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { useFonts } from 'expo-font';

import { HomePage } from 'src/pages/home';
import { LockPage } from 'src/pages/lock';

import { fontStyles, theme } from 'src/styles';

const Stack = createStackNavigator();

export default function Root() {
  useFonts(fontStyles);

  return (
    <NavigationContainer theme={theme}>
      <Stack.Navigator headerMode="none">
        <Stack.Screen name="Home" component={HomePage} />
        <Stack.Screen name="Lock" component={LockPage} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
