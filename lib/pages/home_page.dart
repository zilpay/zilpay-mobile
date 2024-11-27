import 'package:blockies/blockies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/components/copy_content.dart';
import 'package:zilpay/components/hoverd_svg.dart';
import 'package:zilpay/components/tile_button.dart';
import 'package:zilpay/components/token_card.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import 'package:zilpay/mixins/colors.dart';
import '../theme/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    print('Data refreshed');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);
    final adaptivePaddingCard = AdaptiveSize.getAdaptivePadding(context, 12);
    const testAddress = "0x22d9...a1cD";

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.primaryPurple.withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Blockies(
                                seed: "dasdsadsadsa",
                                color: getWalletColor(0),
                                bgColor: theme.primaryPurple,
                                spotColor: theme.background,
                                size: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Wallet 1',
                                style: TextStyle(
                                  color: theme.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CopyAddressButton(
                                address: testAddress,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    HoverSvgIcon(
                      assetName: 'assets/icons/gear.svg',
                      width: 30,
                      height: 30,
                      color: theme.textPrimary,
                      onTap: () {
                        print('Settings tapped');
                      },
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: adaptivePadding),
                child: Row(
                  children: [
                    TileButton(
                      icon: SvgPicture.asset(
                        "assets/icons/send.svg",
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          theme.primaryPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                      backgroundColor: theme.cardBackground,
                      textColor: theme.primaryPurple,
                    ),
                    SizedBox(width: adaptivePaddingCard),
                    TileButton(
                      icon: SvgPicture.asset(
                        "assets/icons/receive.svg",
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          theme.primaryPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                      backgroundColor: theme.cardBackground,
                      textColor: theme.primaryPurple,
                    ),
                    SizedBox(width: adaptivePaddingCard),
                    TileButton(
                      icon: SvgPicture.asset(
                        "assets/icons/swap.svg",
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          theme.primaryPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                      backgroundColor: theme.cardBackground,
                      textColor: theme.primaryPurple,
                    ),
                    SizedBox(width: adaptivePaddingCard),
                    TileButton(
                      icon: SvgPicture.asset(
                        "assets/icons/buy.svg",
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          theme.primaryPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                      backgroundColor: theme.cardBackground,
                      textColor: theme.primaryPurple,
                    ),
                    SizedBox(width: adaptivePaddingCard),
                    TileButton(
                      icon: SvgPicture.asset(
                        "assets/icons/sell.svg",
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          theme.primaryPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                      backgroundColor: theme.cardBackground,
                      textColor: theme.primaryPurple,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: adaptivePadding, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HoverSvgIcon(
                      assetName: 'assets/icons/manage.svg',
                      width: 30,
                      height: 30,
                      color: theme.textSecondary,
                      onTap: () {
                        print('tokens manage');
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(adaptivePadding),
                  children: [
                    TokenCard(
                      tokenAmount: 1234.56,
                      dollarAmount: 2345.67,
                      tokenName: "Zilliqa",
                      tokenSymbol: "ZIL",
                      iconUrl:
                          "https://cryptologos.cc/logos/zilliqa-zil-logo.png",
                    ),
                    SizedBox(height: 12),
                    TokenCard(
                      tokenAmount: 100.0,
                      dollarAmount: 100.0,
                      tokenName: "ZilPay USD",
                      tokenSymbol: "ZPUSD",
                      iconUrl:
                          "https://cryptologos.cc/logos/usd-coin-usdc-logo.png",
                    ),
                    SizedBox(height: 12),
                    TokenCard(
                      tokenAmount: 0.5,
                      dollarAmount: 15.75,
                      tokenName: "gZIL",
                      tokenSymbol: "GZIL",
                      iconUrl: "https://zilswap.org/img/gzil.png",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
