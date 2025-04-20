import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'General'),
          _SettingsItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {},
          ),
          _SettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          _SettingsItem(
            icon: Icons.color_lens_outlined,
            title: 'Theme',
            value: 'Light',
            onTap: () {},
          ),
          
          const _SectionHeader(title: 'Data'),
          _SettingsItem(
            icon: Icons.cloud_upload_outlined,
            title: 'Backup',
            onTap: () {},
          ),
          _SettingsItem(
            icon: Icons.cloud_download_outlined,
            title: 'Restore',
            onTap: () {},
          ),
          _SettingsItem(
            icon: Icons.delete_outline,
            title: 'Clear Data',
            onTap: () {},
          ),
          
          const _SectionHeader(title: 'About'),
          _SettingsItem(
            icon: Icons.info_outline,
            title: 'App Version',
            value: '1.0.0',
            onTap: null,
          ),
          _SettingsItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkGrey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;
  
  const _SettingsItem({
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title),
      trailing: value != null 
        ? Text(
            value!,
            style: const TextStyle(
              color: AppColors.darkGrey,
              fontSize: 14,
            ),
          )
        : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}