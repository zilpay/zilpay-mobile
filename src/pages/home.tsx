import React from 'react';
import { View, StyleSheet } from 'react-native';
// import { useTheme } from '@react-navigation/native';

import { colors } from 'src/styles';

export const HomePage = () => {
  // const { colors } = useTheme();

  return (
    <View style={styles.container} />
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.primary
  }
});
