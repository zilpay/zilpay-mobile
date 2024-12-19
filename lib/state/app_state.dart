import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zilpay/src/rust/api/backend.dart';
import 'package:zilpay/src/rust/api/book.dart';
import 'package:zilpay/src/rust/api/connections.dart';
import 'package:zilpay/src/rust/api/settings.dart';
import 'package:zilpay/src/rust/api/wallet.dart';
import 'package:zilpay/src/rust/models/account.dart';
import 'package:zilpay/src/rust/models/background.dart';
import 'package:zilpay/src/rust/models/book.dart';
import 'package:zilpay/src/rust/models/connection.dart';
import 'package:zilpay/src/rust/models/wallet.dart';
import 'package:zilpay/theme/app_theme.dart';

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  List<AddressBookEntryInfo> _book = [];
  List<ConnectionInfo> _connections = [];

  late BackgroundState _state;
  int _selectedWallet = 0;
  final Brightness _systemBrightness =
      PlatformDispatcher.instance.platformBrightness;

  AppState({required BackgroundState state}) {
    WidgetsBinding.instance.addObserver(this);
    _state = state;
  }

  void setSelectedWallet(int index) {
    _selectedWallet = index;
    notifyListeners();
  }

  List<WalletInfo> get wallets {
    return _state.wallets;
  }

  List<ConnectionInfo> get connections {
    return _connections;
  }

  List<AddressBookEntryInfo> get book {
    return _book;
  }

  BackgroundState get state {
    return _state;
  }

  AppTheme get currentTheme {
    switch (_state.appearances) {
      case 0:
        return _systemBrightness == Brightness.dark
            ? DarkTheme()
            : LightTheme();
      case 1:
        return DarkTheme();
      case 2:
        return LightTheme();
      default:
        return _systemBrightness == Brightness.dark
            ? DarkTheme()
            : LightTheme();
    }
  }

  WalletInfo? get wallet {
    return _state.wallets[_selectedWallet];
  }

  AccountInfo? get account {
    if (wallet == null) {
      return null;
    }

    int index = wallet!.selectedAccount.toInt();

    return wallet!.accounts[index];
  }

  int get selectedWallet {
    return _selectedWallet;
  }

  Future<void> syncData() async {
    _state = await getData();
    await syncBook();
    await syncConnections();
    notifyListeners();
  }

  Future<void> syncBook() async {
    _book = await getAddressBookList();

    notifyListeners();
  }

  Future<void> syncConnections() async {
    _connections = await getConnectionsList();

    notifyListeners();
  }

  Future<void> initialize() async {
    // TODO: init theme form storage
  }

  Future<void> updateSelectedAccount(
      BigInt walletIndex, BigInt accountIndex) async {
    await selectAccount(walletIndex: walletIndex, accountIndex: accountIndex);
    await syncData();

    notifyListeners();
  }

  Future<void> setAppearancesCode(int code) async {
    await setTheme(appearancesCode: code);
    _state = await getData();
    notifyListeners();
  }
}
