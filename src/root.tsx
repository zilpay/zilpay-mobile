import * as React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { useFonts } from 'expo-font';

import { Fonts } from 'src/config';

const Stack = createStackNavigator();

export default function Root() {
  useFonts({
    [Fonts.Bold]: require('assets/fonts/SF-Pro-Display-Bold.otf'),
    [Fonts.Light]: require('assets/fonts/SF-Pro-Display-Light.otf'),
    [Fonts.Medium]: require('assets/fonts/SF-Pro-Display-Medium.otf'),
    [Fonts.Regilar]: require('assets/fonts/SF-Pro-Display-Regular.otf')
  });

  return (
    <NavigationContainer>
      <Stack.Navigator>
        {/* <Stack.Screen name="Home" component={HomeScreen} /> */}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
