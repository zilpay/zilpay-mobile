import 'package:flutter/material.dart';

import 'services/auth_guard.dart';
import 'state/app_state.dart';

import 'pages/main_page.dart';
import 'pages/login_page.dart';
import 'pages/initial_page.dart';
import 'pages/history_page.dart';
import 'pages/browser_page.dart';
import 'pages/settings_page.dart';
import 'pages/new_wallet_options.dart';
import 'pages/gen_wallet_options.dart';
import 'pages/wallet_restore_options.dart';

class AppRouter {
  final AuthGuard authGuard;
  final AppState appState;

  AppRouter({required this.authGuard, required this.appState});

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/restore_options':
          return MaterialPageRoute(builder: (_) => RestoreWalletOptionsPage(), settings: settings);
      case '/gen_options':
          return MaterialPageRoute(builder: (_) => GenWalletOptionsPage(), settings: settings);
      case '/new_wallet_options':
          return MaterialPageRoute(builder: (_) => AddWalletOptionsPage(), settings: settings);
      case '/initial':
          return MaterialPageRoute(builder: (_) => InitialPage(), settings: settings);
      case '/login':
          return MaterialPageRoute(builder: (_) => LoginPage(), settings: settings);
    }

    if (!authGuard.ready) {
      return MaterialPageRoute(
        builder: (_) => InitialPage(),
        settings: RouteSettings(name: '/initial'),
      );
    } else if (!authGuard.enabled) {
      return MaterialPageRoute(
        builder: (_) => LoginPage(),
        settings: RouteSettings(name: '/login'),
      );
    }

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => MainPage(),
          settings: settings,
        );
      case '/history':
        return MaterialPageRoute(
          builder: (_) => HistoryPage(),
          settings: settings,
        );
      case '/browser':
        return MaterialPageRoute(
          builder: (_) => BrowserPage(),
          settings: settings,
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => SettingsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => MainPage(),
          settings: RouteSettings(name: '/'),
        );
    }
  }
}
