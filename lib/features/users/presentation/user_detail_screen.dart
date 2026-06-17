import 'package:flutter/material.dart';
import 'package:swim_success/app/theme.dart';
import 'package:swim_success/features/users/data/models/user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.accent.withValues(alpha: 0.2),
              foregroundColor: AppTheme.accent,
              child: Text(
                _initials(user.name),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '@${user.username}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Contact',
            children: [
              _DetailTile(icon: Icons.email_outlined, label: 'Email', value: user.email),
              _DetailTile(icon: Icons.phone_outlined, label: 'Phone', value: user.phone),
              _DetailTile(icon: Icons.language, label: 'Website', value: user.website),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Address',
            children: [
              _DetailTile(
                icon: Icons.location_on_outlined,
                label: 'Street',
                value: user.address.street,
              ),
              _DetailTile(
                icon: Icons.apartment_outlined,
                label: 'Suite',
                value: user.address.suite,
              ),
              _DetailTile(
                icon: Icons.location_city_outlined,
                label: 'City',
                value: user.address.city,
              ),
              _DetailTile(
                icon: Icons.markunread_mailbox_outlined,
                label: 'Zipcode',
                value: user.address.zipcode,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Company',
            children: [
              _DetailTile(
                icon: Icons.business_outlined,
                label: 'Name',
                value: user.company.name,
              ),
              _DetailTile(
                icon: Icons.format_quote_outlined,
                label: 'Catchphrase',
                value: user.company.catchPhrase,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.accent,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
