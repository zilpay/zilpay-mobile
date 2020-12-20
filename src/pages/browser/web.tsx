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
  StyleSheet,
  Dimensions,
  View
} from 'react-native';
import LottieView from 'lottie-react-native';
import URL from 'url-parse';
import SafeAreaView from 'react-native-safe-area-view';
import { WebView } from 'react-native-webview';
import { WebViewProgressEvent } from 'react-native-webview/lib/WebViewTypes';

import { BrowserViewBar } from 'app/components/browser';
import {
  ConnectModal,
  SignMessageModal,
  ConfirmPopup
} from 'app/components/modals';

import { theme } from 'app/styles';
import { RouteProp } from '@react-navigation/native';
import { StackNavigationProp } from '@react-navigation/stack';
import { BrwoserStackParamList } from 'app/navigator/browser';
import { keystore } from 'app/keystore';
import { version } from '../../../package.json';
import { Messages } from 'app/config';
import { Message } from 'app/lib/controller/inject/message';
import { Transaction } from 'app/lib/controller/transaction';
import { MessagePayload, TxMessage } from 'types';
import i18n from 'app/lib/i18n';
import { toLi } from 'app/filters';

type Prop = {
  navigation: StackNavigationProp<BrwoserStackParamList>;
  route: RouteProp<BrwoserStackParamList, 'Web'>;
};

const { width } = Dimensions.get('window');
export const WebViewPage: React.FC<Prop> = ({ route, navigation }) => {
  const inpageJS = keystore.inpage.store.useValue();
  const searchEngineState = keystore.searchEngine.store.useValue();
  const connectState = keystore.connect.store.useValue();
  const accountState = keystore.account.store.useValue();
  const networkState = keystore.network.store.useValue();
  const tokenState = keystore.token.store.useValue();

  const webViewRef = React.useRef<null | WebView>(null);

  const [url] = React.useState(new URL(route.params.url));
  const [loadingProgress, setLoadingProgress] = React.useState(0);
  const [canGoBack, setCanGoBack] = React.useState(false);
  const [canGoForward, setCanGoForward] = React.useState(false);

  const [appConnect, setAppConnect] = React.useState<MessagePayload>();
  const [signMessage, setSignMessage] = React.useState<MessagePayload>();
  const [transaction, setTransaction] = React.useState<TxMessage>();

  const isConnect = React.useMemo(() => {
    const { hostname } = new URL(route.params.url);

    return connectState.some(
      (app) => app.domain.toLowerCase() === hostname.toLowerCase()
    );
  }, [connectState, route.params.url]);
  const account = React.useMemo(
    () => accountState.identities[accountState.selectedAddress],
    [accountState]
  );

  const handleBack = React.useCallback(() => {
    if (!canGoBack) {
      return navigation.goBack();
    } else if (webViewRef && webViewRef.current) {
      webViewRef.current.goBack();
    }
  }, [canGoBack, webViewRef]);
  const handleGoForward = React.useCallback(() => {
    if (webViewRef && webViewRef.current) {
      webViewRef.current.goForward();
    }
  }, [canGoBack]);

  const handleLoaded = React.useCallback(({ nativeEvent }: WebViewProgressEvent) => {
    setLoadingProgress(nativeEvent.progress);
    setCanGoBack(nativeEvent.canGoBack);
    setCanGoForward(nativeEvent.canGoForward);
  }, [setLoadingProgress, setCanGoBack, setCanGoForward]);

  const handleMessage = React.useCallback(async({ nativeEvent }) => {
    if (!webViewRef.current) {
      return null;
    }

    try {
      const message = JSON.parse(nativeEvent.data);

      switch (message.type) {
        case Messages.init:
          const { base16, bech32 } = keystore.account.getCurrentAccount();
          const m = new Message(Messages.wallet, {
            origin: message.payload.origin,
            data: {
              isConnect,
              account: isConnect ? {
                base16,
                bech32
              } : null,
              isEnable: keystore.guard.isEnable,
              netwrok: keystore.network.selected
            }
          });
          webViewRef.current.postMessage(m.serialize);
          break;

        case Messages.appConnect:
          setAppConnect(message.payload);
          break;

        case Messages.reqProxy:
          const { method, params } = message.payload.data;
          webViewRef.current.postMessage(new Message(Messages.resProxy, {
            origin: message.payload.origin,
            uuid: message.payload.uuid,
            data: await keystore.zilliqa.throughPxoy(method, params)
          }).serialize);
          break;

        case Messages.signMessage:
          setSignMessage(message.payload);
          break;

        case Messages.signTx:
          setTransaction({
            params: message.payload.data,
            uuid: message.payload.uuid,
            origin: message.origin,
            icon: message.icon
          });
          break;

        default:
          break;
      }
    } catch (err) {
      console.error(err);
    }
  }, [webViewRef, isConnect, setAppConnect, setSignMessage, setTransaction]);

  const handleConnect = React.useCallback((value) => {
    if (value && appConnect && appConnect.title && appConnect.icon && appConnect.origin) {
      keystore.connect.add({
        title: appConnect.title,
        domain: new URL(appConnect.origin).hostname,
        icon: appConnect.icon
      });
    }

    if (webViewRef.current && appConnect) {
      const { base16, bech32 } = keystore.account.getCurrentAccount();
      const m = new Message(Messages.resConnect, {
        origin: appConnect.origin,
        uuid: appConnect.uuid,
        data: {
          confirm: value,
          account: value ? {
            base16,
            bech32
          } : null
        }
      });
      webViewRef.current.postMessage(m.serialize);
    }
    setAppConnect(undefined);
  }, [appConnect, webViewRef]);

  const handleSignMessage = React.useCallback((value) => {
    if (!webViewRef.current || !signMessage?.origin || !signMessage?.uuid) {
      return null;
    }

    const data: {
      reject: undefined | string;
      resolve: undefined | object;
    } = {
      reject: undefined,
      resolve: undefined
    };

    if (!value) {
      data.reject = 'User rejected';
    } else if (value) {
      data.resolve = value;
    }

    const m = new Message(Messages.signResult, {
      origin: signMessage.origin,
      uuid: signMessage.uuid,
      data
    });
    webViewRef.current.postMessage(m.serialize);
    setSignMessage(undefined);
  }, [webViewRef, signMessage, setSignMessage]);
  const handleTx = React.useCallback((value) => {
    if (!webViewRef.current || !transaction) {
      return null;
    }

    if (value) {
      // TODO: signing and send to node.
      setTransaction(undefined);
      return null;
    }

    const m = new Message(Messages.resConnect, {
      origin: transaction.origin,
      uuid: transaction.uuid,
      data: {
        reject: 'User rejected'
      }
    });
    webViewRef.current.postMessage(m.serialize);
    setTransaction(undefined);
  }, [transaction, webViewRef, setTransaction]);

  React.useEffect(() => {
    if (!inpageJS) {
      keystore.inpage.sync();
    }
  }, []);

  React.useEffect(() => {
    if (webViewRef.current) {
      const { base16, bech32 } = keystore.account.getCurrentAccount();
      const m = new Message(Messages.resConnect, {
        data: {
          isConnect,
          account: isConnect ? {
            base16,
            bech32
          } : null,
          isEnable: keystore.guard.isEnable,
          netwrok: keystore.network.selected
        }
      });
      webViewRef.current.postMessage(m.serialize);
    }
  }, [webViewRef, accountState, networkState]);

  if (!inpageJS) {
    return (
      <SafeAreaView style={{
        flex: 1,
        backgroundColor: '#09090c'
      }}>
        <LottieView
          source={require('app/assets/loader')}
          autoPlay
          loop
        />
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <BrowserViewBar
        url={url}
        canGoForward={canGoForward}
        onBack={handleBack}
        onGoForward={handleGoForward}
      />
      {loadingProgress !== 1 ? (
        <View style={[styles.loading, { width: width * loadingProgress }]}/>
      ) : null}
      <WebView
        ref={webViewRef}
        source={{
          uri: route.params.url
        }}
        applicationNameForUserAgent={`ZilPay/${version}`}
        incognito={searchEngineState.incognito}
        injectedJavaScriptBeforeContentLoaded={inpageJS}
        onMessage={handleMessage}
        onLoadProgress={handleLoaded}
      />
      <ConnectModal
        app={appConnect}
        visible={Boolean(appConnect)}
        onTriggered={() => handleConnect(false)}
        onReject={() => handleConnect(false)}
        onConfirm={() => handleConnect(true)}
      />
      <SignMessageModal
        title={i18n.t('sign_request')}
        visible={Boolean(signMessage)}
        icon={signMessage?.icon}
        appTitle={signMessage?.title}
        payload={String(signMessage?.data)}
        onTriggered={() => setSignMessage(undefined)}
        onReject={() => handleSignMessage(undefined)}
        onSign={handleSignMessage}
      />
      {transaction ? (
        <ConfirmPopup
          token={tokenState[0]}
          recipient={transaction.params.toAddr}
          amount={transaction.params.amount}
          account={account}
          data={transaction.params.data}
          code={transaction.params.code}
          gasCost={{
            gasLimit: transaction.params.gasLimit,
            gasPrice: toLi(transaction.params.gasPrice),
          }}
          title={i18n.t('confirm')}
          netwrok={networkState.selected}
          visible={Boolean(transaction)}
          onTriggered={() => handleTx(false)}
          onConfirm={() => handleTx(true)}
        />
      ) : null}
    </SafeAreaView>
  );
};
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.black
  },
  loading: {
    height: 3,
    backgroundColor: theme.colors.primary
  }
});

export default WebViewPage;
