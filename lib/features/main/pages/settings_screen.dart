import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _appVersion = '';
  bool _isLoadingVersion = true;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
        _isLoadingVersion = false;
      });
    } catch (e) {
      setState(() {
        _appVersion = 'Unknown';
        _isLoadingVersion = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'Settings',
          style: AppTheme.headlineMedium.copyWith(
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _buildSection(
              title: '',
              children: [
                _buildActionButton(
                  title: 'Rate App',
                  subtitle: 'Love the app? Let us know!',
                  icon: CupertinoIcons.star,
                  onPressed: _rateApp,
                ),
                _buildActionButton(
                  title: 'Share App',
                  subtitle: 'Share with fellow plant lovers',
                  icon: CupertinoIcons.share,
                  onPressed: _shareApp,
                ),
                _buildActionButton(
                  title: 'Privacy Policy',
                  icon: CupertinoIcons.doc_text,
                  onPressed: () => _launchURL('https://yourapp.com/privacy'),
                ),
                _buildActionButton(
                  title: 'Terms of Service',
                  icon: CupertinoIcons.doc_plaintext,
                  onPressed: () => _launchURL('https://yourapp.com/terms'),
                ),
                _buildVersionInfo(),
              ],
            ),
          ]
              .animate(interval: 100.milliseconds)
              .fadeIn(duration: AppTheme.animationNormal)
              .slideX(
                begin: 0.2,
                duration: AppTheme.animationNormal,
              ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Text(
            title,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: AppTheme.textLight.withOpacity(0.2),
              ),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: AppTheme.paddingMedium),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return CupertinoListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? CupertinoColors.destructiveRed
            : AppTheme.primaryGreen,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? CupertinoColors.destructiveRed : null,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(
        CupertinoIcons.chevron_forward,
        color: AppTheme.textLight,
      ),
      onTap: onPressed,
    );
  }

  Widget _buildVersionInfo() {
    return CupertinoListTile(
      title: const Text('Version'),
      trailing: _isLoadingVersion
          ? const CupertinoActivityIndicator()
          : Text(
              _appVersion,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textLight,
              ),
            ),
    );
  }

  Future<void> _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      final url = Uri.parse(
        'https://apps.apple.com/app/idYOUR_APP_ID',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Future<void> _shareApp() async {
    const text =
        'Check out My Green Corner - your digital plant care companion! '
        'Download now: https://apps.apple.com/app/idYOUR_APP_ID';

    await Share.share(text);
  }

  Future<void> _launchURL(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Could not open the link'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
