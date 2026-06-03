import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/services/auth_service.dart';

/// Caregiver Home Screen - Shows patients and their medications/appointments
class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  String _selectedTab = 'Medications';
  int _selectedNavIndex = 0;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              '24 September 2025',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.65),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.onBackground,
              size: 28,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Tab buttons
          _buildTabButtons(),

          const SizedBox(height: 20),

          // Content based on selected tab
          Expanded(
            child: _selectedTab == 'Medications'
                ? _buildMedicationsContent()
                : _buildAppointmentsContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTabButtons() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _authService.caregiverPatientsStream(),
      builder: (context, snapshot) {
        final patients = snapshot.data ?? [];
        final total = patients.fold<int>(
          0,
          (sum, item) => sum + _asInt(item['totalMedications']),
        );
        final missed = patients.fold<int>(
          0,
          (sum, item) => sum + _asInt(item['missedMedications']),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  'Medications',
                  '$total Total / $missed Missed',
                  _selectedTab == 'Medications',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTabButton(
                  'Appointments',
                  '0 Total / 0 Missed',
                  _selectedTab == 'Appointments',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String title, String subtitle, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? Colors.white70
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsContent() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _authService.caregiverPatientsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final patients = (snapshot.data ?? []).map(_patientFromSummary).toList();
        if (patients.isEmpty) {
          return Center(
            child: Text(
              'No patients connected yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            return _buildPatientMedicationCard(patients[index]);
          },
        );
      },
    );
  }

  Widget _buildAppointmentsContent() {
    return Center(
      child: Text(
        'No appointments scheduled',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildPatientMedicationCard(Patient patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Patient avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(patient.profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Patient info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patient.progress,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),

          // Missed count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${patient.missedCount} missed',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.red[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBottomNavItem(
            AppAssets.homeMenu,
            AppAssets.homeMenuSelected,
            'Home',
            0,
          ),
          _buildBottomNavItem(
            AppAssets.patientsIcon,
            AppAssets.patientsIconSelected,
            'Patients',
            1,
          ),
          _buildBottomNavItem(
            AppAssets.profileMenu,
            AppAssets.profileMenuSelected,
            'Profile',
            2,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    String normalAsset,
    String selectedAsset,
    String label,
    int index,
  ) {
    final isSelected = _selectedNavIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedNavIndex = index;
          });
          _handleNavigation(label);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Image.asset(
                isSelected ? selectedAsset : normalAsset,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String label) {
    switch (label) {
      case 'Home':
        // Already on home, do nothing
        break;
      case 'Patients':
        Navigator.pushReplacementNamed(context, '/caregiver-patients');
        break;
      case 'Profile':
        Navigator.pushReplacementNamed(context, '/caregiver-profile');
        break;
    }
  }
}

// Model for patient data
class Patient {
  final String name;
  final String progress;
  final int missedCount;
  final String profileImage;

  Patient({
    required this.name,
    required this.progress,
    required this.missedCount,
    required this.profileImage,
  });
}

Patient _patientFromSummary(Map<String, dynamic> data) {
  final total = _asInt(data['totalMedications']);
  final completed = _asInt(data['completedMedications']);
  final missed = _asInt(data['missedMedications']);
  return Patient(
    name: (data['name'] ?? 'Patient').toString(),
    progress: 'Progress: $completed/$total Doses',
    missedCount: missed,
    profileImage: AppAssets.profileImg,
  );
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
