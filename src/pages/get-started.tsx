/*
 * Project: ZilPay-wallet
 * Author: Rinat(lich666dead)
 * -----
 * Modified By: the developer formerly known as Rinat(lich666dead) at <lich666black@gmail.com>
 * -----
 * Copyright (c) 2020 ZilPay
 */
import React from 'react';
import {
  View,
  StyleSheet,
  Text,
  ScrollView,
  Dimensions,
  Image,
  ImageStyle,
  StyleProp
} from 'react-native';
import { SafeWrapper } from 'app/components/safe-wrapper';
import { StackNavigationProp } from '@react-navigation/stack';
import { useTheme } from '@react-navigation/native';

import i18n from 'app/lib/i18n';
import { UnauthorizedStackParamList } from 'app/navigator/unauthorized';
import { Button } from 'app/components/button';

import GetStartedFirst from 'app/assets/images/get_started_0.webp';
import GetStartedSecond from 'app/assets/images/get_started_1.webp';
import GetStartedThird from 'app/assets/images/get_started_2.webp';

import { fonts } from 'app/styles';

type Prop = {
  navigation: StackNavigationProp<UnauthorizedStackParamList>;
};

const { width, height } = Dimensions.get('window');
const imageStyles: StyleProp<ImageStyle> = {
  width: 'auto',
  height: '50%',
  resizeMode: 'contain'
};
const pages = [
  {
    img: <Image source={GetStartedFirst} style={imageStyles}/>,
    title: i18n.t('get_started_title_1'),
    description: i18n.t('get_started_description_1')
  },
  {
    img: <Image source={GetStartedSecond} style={imageStyles}/>,
    title: i18n.t('get_started_title_2'),
    description: i18n.t('get_started_description_2')
  },
  {
    img: <Image source={GetStartedThird} style={imageStyles}/>,
    title: i18n.t('get_started_title_3'),
    description: i18n.t('get_started_description_3')
  }
];

export const GetStartedPage: React.FC<Prop> = ({ navigation }) => {
  const { colors } = useTheme();
  const [sliderState, setSliderState] = React.useState({ currentPage: 0 });

  const setSliderPage = React.useCallback((event) => {
    const { currentPage } = sliderState;
    const { x } = event.nativeEvent.contentOffset;
    const indexOfNextScreen = Math.floor(x / width);

    if (indexOfNextScreen !== currentPage) {
      setSliderState({
        ...sliderState,
        currentPage: indexOfNextScreen,
      });
    }
  }, [sliderState, setSliderState]);

  const { currentPage: pageIndex } = sliderState;

  return (
    <SafeWrapper>
      <View style={styles.scrollView}>
        <ScrollView
          style={styles.scrollView}
          horizontal={true}
          scrollEventThrottle={16}
          pagingEnabled={true}
          showsHorizontalScrollIndicator={false}
          onScroll={setSliderPage}
        >
        {pages.map((page, index) => (
          <View
            key={index}
            style={[{ width, height }, styles.slideContainer]}
          >
            {page.img}
            <View style={styles.wrapper}>
              <Text style={[styles.header, {
                color: colors.text
              }]}>
                {page.title}
              </Text>
              <Text style={[styles.paragraph, {
                color: colors.text
              }]}>
                {page.description}
              </Text>
            </View>
          </View>
        ))}
        </ScrollView>
        <View style={styles.paginationWrapper}>
          {Array.from(Array(pages.length).keys()).map((_, index) => (
            <View
              key={index}
              style={[styles.paginationDots,
                (pageIndex === index ? null : {
                  ...styles.unDot,
                  borderColor: colors.background
                }), {
                backgroundColor: colors.primary
              }]}
            />
          ))}
        </View>
        <Button
          title={i18n.t('get_started')}
          color={colors.primary}
          onPress={() => navigation.navigate('Privacy')}
        />
      </View>
    </SafeWrapper>
  );
};

const styles = StyleSheet.create({
  scrollView: {
    flex: 1,
    maxHeight: height - 50
  },
  previewImage: {
    width,
    height: '50%'
  },
  slideContainer: {
  },
  wrapper: {
    justifyContent: 'center',
    alignItems: 'center',
    marginVertical: 90
  },
  header: {
    fontSize: 34,
    marginBottom: 20,
    fontFamily: fonts.Bold,
    textAlign: 'center'
  },
  paragraph: {
    fontSize: 17,
    lineHeight: 22,
    fontFamily: fonts.Regular,
    textAlign: 'center'
  },
  paginationWrapper: {
    position: 'absolute',
    bottom: '40%',
    left: 0,
    right: 0,
    justifyContent: 'center',
    alignItems: 'center',
    flexDirection: 'row'
  },
  paginationDots: {
    height: 8,
    width: 8,
    borderRadius: 10 / 2,
    marginLeft: 10
  },
  unDot: {
    borderStyle: 'solid',
    borderWidth: 1,
    backgroundColor: 'transparent'
  }
});

export default GetStartedPage;
