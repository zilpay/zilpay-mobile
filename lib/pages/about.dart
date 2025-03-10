import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import '../theme/app_theme.dart';
import '../components/custom_app_bar.dart';
import '../state/app_state.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'ZilPay',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.currentTheme;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: adaptivePadding),
                  child: CustomAppBar(
                    title: 'About',
                    onBackPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildLogoSection(theme),
                          const SizedBox(height: 32),
                          _buildAppInfoSection(theme),
                          const SizedBox(height: 24),
                          _buildDeveloperSection(theme),
                          const SizedBox(height: 24),
                          _buildLegalSection(theme),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(AppTheme theme) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.cardBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/imgs/zilpay.svg',
              width: 80,
              height: 80,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ZilPay',
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your Secure Blockchain Wallet',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(AppTheme theme) {
    return _buildSectionContainer(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(theme, 'Application Info'),
          const SizedBox(height: 16),
          _buildInfoRow(theme, 'Version',
              '${_packageInfo.version} (${_packageInfo.buildNumber})'),
          _buildInfoRow(theme, 'Build Date', 'March 10, 2025'),
          _buildInfoRow(theme, 'Platform',
              Theme.of(context).platform.toString().split('.').last),
        ],
      ),
    );
  }

  Widget _buildDeveloperSection(AppTheme theme) {
    return _buildSectionContainer(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(theme, 'Developer'),
          const SizedBox(height: 16),
          _buildInfoRow(theme, 'Author', 'Rinat (hicaru)'),
          _buildInfoRow(theme, 'Website', 'https://zilpay.io'),
        ],
      ),
    );
  }

  Widget _buildLegalSection(AppTheme theme) {
    return _buildSectionContainer(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(theme, 'Legal'),
          const SizedBox(height: 16),
          _buildActionRow(
            theme,
            'Privacy Policy',
            'assets/icons/shield.svg',
            false,
            () => _launchUrl('https://zilpay.io/policy'),
          ),
          _buildActionRow(
            theme,
            'Terms of Service',
            'assets/icons/document.svg',
            false,
            () => _launchUrl('https://zilpay.io/terms'),
          ),
          _buildActionRow(
            theme,
            'Licenses',
            'assets/icons/licenses.svg',
            true,
            () => showLicensePage(
              context: context,
              applicationName: _packageInfo.appName,
              applicationVersion: _packageInfo.version,
              applicationIcon: SvgPicture.asset('assets/imgs/zilpay.svg',
                  width: 48, height: 48),
              applicationLegalese: "© 2025 ZilPay. All rights reserved.",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(AppTheme theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildSectionTitle(AppTheme theme, String title) {
    return Text(
      title,
      style: TextStyle(
        color: theme.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(AppTheme theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    AppTheme theme,
    String title,
    String iconPath,
    bool last,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.textSecondary.withValues(alpha: last ? 0 : 0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                theme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/icons/right_arrow.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                theme.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
