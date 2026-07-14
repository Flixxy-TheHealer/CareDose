import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('CareDose',
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        color: AppColors.primary, size: 44),
                  ),
                  const SizedBox(height: 12),
                  const Text('Eleanor Smith',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('+91 98765 43210',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBadge('3', 'Medicines'),
                      _buildDivider(),
                      _buildStatBadge('92%', 'Adherence'),
                      _buildDivider(),
                      _buildStatBadge('14', 'Days Streak'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Settings sections
            _buildSection('Health Info', [
              _buildTile(Icons.calendar_today_outlined, 'Date of Birth',
                  'March 14, 1980'),
              _buildTile(Icons.bloodtype_outlined, 'Blood Group', 'O+'),
              _buildTile(Icons.person_outline, 'Gender', 'Female'),
            ]),
            const SizedBox(height: 16),
            _buildSection('Guardian & Emergency', [
              _buildTile(Icons.people_outline, 'Guardian Name', 'James Smith'),
              _buildTile(
                  Icons.phone_outlined, 'Guardian Contact', '+91 99876 54321'),
            ]),
            const SizedBox(height: 16),
            _buildSection('App Settings', [
              _buildToggleTile(
                  Icons.notifications_outlined, 'Dose Reminders', true),
              _buildToggleTile(
                  Icons.warning_amber_outlined, 'Low Stock Alerts', true),
              _buildTile(Icons.language_outlined, 'Language', 'English'),
            ]),
            const SizedBox(height: 16),
            _buildSection('Support', [
              _buildActionTile(Icons.help_outline, 'Help & FAQ'),
              _buildActionTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
              _buildActionTile(Icons.description_outlined, 'Terms of Service'),
            ]),
            const SizedBox(height: 16),
            // Sign out button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.danger),
                label: const Text('Sign Out',
                    style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.dangerBorder),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 36, width: 1, color: AppColors.border);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
            ),
            const Divider(height: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      trailing: Text(value,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary)),
      dense: true,
    );
  }

  Widget _buildToggleTile(IconData icon, String label, bool value) {
    return StatefulBuilder(builder: (ctx, setState) {
      return SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(label,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: (v) => setState(() => value = v),
        dense: true,
      );
    });
  }

  Widget _buildActionTile(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textSecondary, size: 20),
      onTap: () {},
      dense: true,
    );
  }
}
