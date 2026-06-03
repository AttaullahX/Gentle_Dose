import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/patient_models.dart';
import 'patient_detail_screen.dart';

/// Caregiver Patients Screen - Shows list of patients under care
class CaregiverPatientsScreen extends StatefulWidget {
  const CaregiverPatientsScreen({super.key});

  @override
  State<CaregiverPatientsScreen> createState() =>
      _CaregiverPatientsScreenState();
}

class _CaregiverPatientsScreenState extends State<CaregiverPatientsScreen> {
  int _selectedNavIndex = 1; // Patients tab is selected

  // Sample patients data
  final List<Patient> patients = [
    Patient(
      id: '1',
      name: 'Mustafa Ali',
      condition: 'Hypertension',
      profileImage: AppAssets.profileImg,
      totalDoses: 5,
      takenDoses: 3,
      missedDoses: 2,
      medications: [
        Medication(
          name: 'Lisinopril',
          time: '8:00 AM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Amlodipine',
          time: '2:00 PM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Metformin',
          time: '6:00 PM',
          status: MedicationStatus.missed,
        ),
        Medication(
          name: 'Aspirin',
          time: '10:00 PM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Vitamin D',
          time: '8:00 AM',
          status: MedicationStatus.missed,
        ),
      ],
    ),
    Patient(
      id: '2',
      name: 'Sarah Johnson',
      condition: 'Diabetes',
      profileImage: AppAssets.profileImg,
      totalDoses: 4,
      takenDoses: 4,
      missedDoses: 0,
      medications: [
        Medication(
          name: 'Insulin',
          time: '7:00 AM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Metformin',
          time: '12:00 PM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Insulin',
          time: '6:00 PM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Glipizide',
          time: '9:00 PM',
          status: MedicationStatus.taken,
        ),
      ],
    ),
    Patient(
      id: '3',
      name: 'Robert Wilson',
      condition: 'Heart Disease',
      profileImage: AppAssets.profileImg,
      totalDoses: 6,
      takenDoses: 5,
      missedDoses: 1,
      medications: [
        Medication(
          name: 'Atorvastatin',
          time: '7:00 AM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Metoprolol',
          time: '9:00 AM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Lisinopril',
          time: '1:00 PM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Aspirin',
          time: '6:00 PM',
          status: MedicationStatus.missed,
        ),
        Medication(
          name: 'Clopidogrel',
          time: '8:00 PM',
          status: MedicationStatus.taken,
        ),
        Medication(
          name: 'Fish Oil',
          time: '10:00 PM',
          status: MedicationStatus.taken,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Patients',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
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

          // Patients List
          Expanded(child: _buildPatientsList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPatientsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return _buildPatientCard(patients[index]);
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: patient),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Progress: ${patient.progressText}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Missed count
            if (patient.missedDoses > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${patient.missedDoses} missed',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
                color: isSelected ? const Color(0xFF407CE2) : Colors.grey[400],
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
        Navigator.pushReplacementNamed(context, '/caregiver-home');
        break;
      case 'Patients':
        // Already on patients screen, do nothing
        break;
      case 'Profile':
        Navigator.pushReplacementNamed(context, '/caregiver-profile');
        break;
    }
  }
}
