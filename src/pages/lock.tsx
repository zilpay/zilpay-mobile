import React from 'react';
import { View, StyleSheet } from 'react-native';

import { colors } from 'src/styles';

export const LockPage = () => {

  return (
    <View style={styles.container} />
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.secondary
  }
});
