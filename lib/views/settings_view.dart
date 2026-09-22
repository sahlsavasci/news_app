import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/cache_config.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true;

  void _clearCache() {
    CacheConfig.customCacheManager.emptyCache();
    Get.rawSnackbar(
      message: 'Image cache cleared successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      borderRadius: 24,
      margin: const EdgeInsets.only(bottom: 32, left: 40, right: 40),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  void _clearHistory() {
    Get.rawSnackbar(
      message: 'Reading history cleared',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      borderRadius: 24,
      margin: const EdgeInsets.only(bottom: 32, left: 40, right: 40),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  void _showThemeDialog(SettingsController settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System Default'),
              leading: const Icon(Icons.brightness_auto),
              onTap: () {
                settings.setThemeMode('system');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Light'),
              leading: const Icon(Icons.light_mode),
              onTap: () {
                settings.setThemeMode('light');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dark'),
              leading: const Icon(Icons.dark_mode),
              onTap: () {
                settings.setThemeMode('dark');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionDialog(SettingsController settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Region', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('United States'),
              onTap: () {
                settings.setRegion('us');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Indonesia'),
              onTap: () {
                settings.setRegion('id');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Global (UK)'),
              onTap: () {
                settings.setRegion('gb');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader('Appearance & Display'),
          Obx(() => _buildListTile(
            title: 'Theme',
            subtitle: settings.themeMode.value.capitalizeFirst ?? 'System',
            icon: Icons.palette_outlined,
            onTap: () => _showThemeDialog(settings),
            context: context,
          )),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Preferences'),
          Obx(() => _buildListTile(
            title: 'Region / Edition',
            subtitle: settings.region.value.toUpperCase(),
            icon: Icons.public,
            onTap: () => _showRegionDialog(settings),
            context: context,
          )),
          const SizedBox(height: 1),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive breaking news alerts',
            icon: Icons.notifications_active_outlined,
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Typography'),
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.format_size, color: AppColors.primary),
                      ),
                      const SizedBox(width: 16),
                      const Text('Font Size', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ],
                  ),
                ),
                Obx(() => Slider(
                  value: settings.fontScale.value,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  label: '${(settings.fontScale.value * 100).toInt()}%',
                  activeColor: AppColors.primary,
                  onChanged: settings.setFontScale,
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('Data & Storage'),
          _buildListTile(
            title: 'Clear Image Cache',
            subtitle: 'Free up storage space',
            icon: Icons.cleaning_services_outlined,
            onTap: _clearCache,
            context: context,
          ),
          const SizedBox(height: 1),
          _buildListTile(
            title: 'Clear Reading History',
            subtitle: 'Reset saved local data',
            icon: Icons.history,
            onTap: _clearHistory,
            context: context,
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('About'),
          _buildListTile(
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {},
            context: context,
          ),
          const SizedBox(height: 1),
          _buildListTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {},
            context: context,
          ),
          const SizedBox(height: 1),
          _buildListTile(
            title: 'App Version',
            subtitle: '1.0.0 (Build 1)',
            icon: Icons.info_outline,
            onTap: () {},
            context: context,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)) : null,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
