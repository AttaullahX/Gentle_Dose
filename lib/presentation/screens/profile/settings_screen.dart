import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Settings Screen - App settings and preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          // Notification Setting
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: 'Notification',
            hasArrow: true,
            onTap: () {
              Navigator.pushNamed(context, '/notification-settings');
            },
          ),

          const SizedBox(height: 20),

          // Language Setting
          _buildSettingItem(
            icon: Icons.language_outlined,
            title: 'Language',
            hasArrow: true,
            onTap: () {
              Navigator.pushNamed(context, '/language-settings');
            },
          ),

          const SizedBox(height: 20),

          // Dark Mode Setting
          _buildSettingItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark mode',
            hasSwitch: true,
            switchValue: _darkMode,
            onSwitchChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    bool hasArrow = false,
    bool hasSwitch = false,
    bool switchValue = false,
    VoidCallback? onTap,
    Function(bool)? onSwitchChanged,
  }) {
    return GestureDetector(
      onTap: hasSwitch ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF407CE2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),

            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            // Arrow or Switch
            if (hasArrow)
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),

            if (hasSwitch)
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: const Color(0xFF407CE2),
                inactiveThumbColor: Colors.grey[300],
                inactiveTrackColor: Colors.grey[200],
              ),
          ],
        ),
      ),
    );
  }
}
