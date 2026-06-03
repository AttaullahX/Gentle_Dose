import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../add_medication/add_medication_screen.dart';
import '../add_appointment/add_appointment_screen.dart';
import '../calendar/calendar_screen.dart';
import '../track/track_screen.dart';
import '../profile/profile_screen.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/medication.dart';
import '../../../core/models/appointment.dart';

/// Home Screen - Main dashboard with medications and appointments
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0; // 0 for Medications, 1 for Appointments
  String _selectedMedicationFilter = 'upcoming'; // completed, missed, upcoming
  String _selectedAppointmentFilter = 'upcoming'; // completed, missed, upcoming

  // Sample medications data
  List<Medication> medications = [
    Medication(
      id: '1',
      name: 'Aspirin',
      dosage: '500mg\n1 Tablet',
      time: 'Today, 10:00 AM',
      notes: 'Take after meal',
      status: MedicationStatus.upcoming,
    ),
    Medication(
      id: '2',
      name: 'Aspirin',
      dosage: '500mg\n1 Tablet',
      time: 'Today, 10:00 AM',
      notes: 'Take after meal',
      status: MedicationStatus.missed,
    ),
    Medication(
      id: '3',
      name: 'Aspirin',
      dosage: '500 mg\n1 Tablet',
      time: 'Today, 10:00 AM',
      notes: 'Take after meal',
      status: MedicationStatus.completed,
    ),
  ];

  // Sample appointments data
  List<Appointment> appointments = [
    Appointment(
      id: '1',
      title: 'Doctor Visit',
      doctor: 'Dr. Ahmad Khan',
      dateTime: 'Tue, Aug 28 - 10:30 am',
      location: 'City Hospital',
      reminder: '15 min before',
      notes: 'Regular checkup',
      status: AppointmentStatus.upcoming,
    ),
    Appointment(
      id: '2',
      title: 'Dental Checkup',
      doctor: 'Dr. Sarah Wilson',
      dateTime: 'Mon, Aug 27 - 2:00 pm',
      location: 'Dental Clinic',
      reminder: '30 min before',
      notes: 'Routine cleaning',
      status: AppointmentStatus.completed,
    ),
    Appointment(
      id: '3',
      title: 'Eye Exam',
      doctor: 'Dr. Michael Brown',
      dateTime: 'Sun, Aug 26 - 11:00 am',
      location: 'Vision Center',
      reminder: '15 min before',
      notes: 'Annual eye exam',
      status: AppointmentStatus.missed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Spacer(),
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
      ),
      body: Column(
        children: [
          // Tab buttons
          _buildTabButtons(),

          const SizedBox(height: 20),

          // Content based on selected tab
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildMedicationsTab()
                : _buildAppointmentsTab(),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFF407CE2),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            // Navigate based on selected tab
            if (_selectedTabIndex == 0) {
              // Navigate to add medication screen
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicationScreen(),
                ),
              );

              // If a medication was added, add it to the list
              if (result != null && result is Map<String, dynamic>) {
                _addNewMedication(result);
              }
            } else {
              // Navigate to add appointment screen
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAppointmentScreen(),
                ),
              );

              // If an appointment was added, add it to the list
              if (result != null && result is Map<String, dynamic>) {
                _addNewAppointment(result);
              }
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTabButtons() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabButton('Medications', 0),
          const SizedBox(width: 16),
          _buildTabButton('Appointments', 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF407CE2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationsTab() {
    return Column(
      children: [
        // Filter buttons
        _buildMedicationFilterButtons(),

        const SizedBox(height: 20),

        // Medications list
        Expanded(child: _buildMedicationsList()),
      ],
    );
  }

  Widget _buildMedicationFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildFilterButton('completed', 'completed')),
          const SizedBox(width: 12),
          Expanded(child: _buildFilterButton('missed', 'missed')),
          const SizedBox(width: 12),
          Expanded(child: _buildFilterButton('upcoming', 'upcoming')),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = _selectedMedicationFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMedicationFilter = value;
        });
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _getFilterColor(value) : Colors.grey[200],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      case 'missed':
        return const Color(0xFFF44336); // Red
      case 'upcoming':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF407CE2);
    }
  }

  Widget _buildMedicationsList() {
    // Filter medications based on selected filter
    List<Medication> filteredMedications = medications.where((medication) {
      return medication.status.displayName == _selectedMedicationFilter;
    }).toList();

    if (filteredMedications.isEmpty) {
      return _buildEmptyMedicationsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredMedications.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildMedicationCard(filteredMedications[index]),
        );
      },
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with medication name and edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${medication.name} - ${medication.dosage.split('\n')[0]}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.edit_outlined, color: Colors.grey[400], size: 20),
            ],
          ),

          const SizedBox(height: 12),

          // Dosage info
          Text(
            medication.dosage.split('\n')[1],
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // Time chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              medication.time,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
            ),
          ),

          const SizedBox(height: 16),

          // Notes and action button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                medication.notes,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              _buildActionButton(medication),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Medication medication) {
    String buttonText;
    Color buttonColor;
    Color textColor;
    Color iconColor;
    IconData buttonIcon;
    VoidCallback? onTap;
    bool isFilled;

    switch (medication.status) {
      case MedicationStatus.upcoming:
        buttonText = 'Mark as completed';
        buttonColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF4CAF50);
        iconColor = const Color(0xFF4CAF50);
        buttonIcon = Icons.check;
        isFilled = false; // Not filled initially
        onTap = () =>
            _updateMedicationStatus(medication.id, MedicationStatus.completed);
        break;
      case MedicationStatus.missed:
        buttonText = 'missed';
        buttonColor = const Color(0xFFF44336);
        textColor = Colors.white;
        iconColor = Colors.white;
        buttonIcon = Icons.close;
        isFilled = true; // Filled for missed
        onTap = null; // No action for missed medications
        break;
      case MedicationStatus.completed:
        buttonText = 'completed';
        buttonColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
        iconColor = Colors.white;
        buttonIcon = Icons.check;
        isFilled = true; // Filled for completed
        onTap = null; // No action for completed medications
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isFilled ? buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isFilled ? null : Border.all(color: buttonColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(width: 6),
            Icon(buttonIcon, color: iconColor, size: 16),
          ],
        ),
      ),
    );
  }

  void _updateMedicationStatus(
    String medicationId,
    MedicationStatus newStatus,
  ) {
    setState(() {
      final index = medications.indexWhere((med) => med.id == medicationId);
      if (index != -1) {
        medications[index] = medications[index].copyWith(status: newStatus);
      }
    });
  }

  void _addNewMedication(Map<String, dynamic> medicationData) {
    setState(() {
      // Get the first reminder time or default
      final reminderTimes = medicationData['reminderTimes'] as List<String>?;
      final firstTime = reminderTimes?.isNotEmpty == true
          ? reminderTimes!.first
          : '10:00 AM';

      final newMedication = Medication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: medicationData['name'] ?? 'Unknown',
        dosage: '${medicationData['dosage'] ?? 'Unknown dosage'}\n1 Tablet',
        time: 'Today, $firstTime',
        notes: medicationData['notes'] ?? 'No notes',
        status: MedicationStatus.upcoming,
      );
      medications.add(newMedication);
    });
  }

  void _addNewAppointment(Map<String, dynamic> appointmentData) {
    setState(() {
      final newAppointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: appointmentData['title'] ?? 'Appointment',
        doctor: appointmentData['doctor'] ?? 'Doctor',
        dateTime: appointmentData['dateTime'] ?? 'Date & Time',
        location: appointmentData['location'] ?? 'Location',
        reminder: appointmentData['reminder'] ?? '15 min before',
        notes: appointmentData['notes'] ?? 'No notes',
        status: AppointmentStatus.upcoming,
      );
      appointments.add(newAppointment);
    });
  }

  Widget _buildEmptyMedicationsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No medications found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first medication',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return Column(
      children: [
        // Filter buttons
        _buildAppointmentFilterButtons(),

        const SizedBox(height: 20),

        // Appointments list
        Expanded(child: _buildAppointmentsList()),
      ],
    );
  }

  Widget _buildAppointmentFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildAppointmentFilterButton('completed', 'completed'),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildAppointmentFilterButton('missed', 'missed')),
          const SizedBox(width: 12),
          Expanded(
            child: _buildAppointmentFilterButton('upcoming', 'upcoming'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentFilterButton(String value, String label) {
    final isSelected = _selectedAppointmentFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAppointmentFilter = value;
        });
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? _getAppointmentFilterColor(value)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Color _getAppointmentFilterColor(String filter) {
    switch (filter) {
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      case 'missed':
        return const Color(0xFFF44336); // Red
      case 'upcoming':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF407CE2);
    }
  }

  Widget _buildAppointmentsList() {
    // Filter appointments based on selected filter
    List<Appointment> filteredAppointments = appointments.where((appointment) {
      return appointment.status.displayName == _selectedAppointmentFilter;
    }).toList();

    if (filteredAppointments.isEmpty) {
      return _buildEmptyAppointmentsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(filteredAppointments[index]),
        );
      },
    );
  }

  Widget _buildEmptyAppointmentsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first appointment',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with appointment title and edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  appointment.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(Icons.edit_outlined, color: Colors.grey[400], size: 20),
            ],
          ),

          const SizedBox(height: 8),

          // Doctor name
          Text(
            appointment.doctor,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // Date & Time chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              appointment.dateTime,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
            ),
          ),

          const SizedBox(height: 12),

          // Location if available
          if (appointment.location.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  appointment.location,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

          if (appointment.location.isNotEmpty) const SizedBox(height: 12),

          // Reminder info
          Text(
            'Reminder: ${appointment.reminder}',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // Action button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildAppointmentActionButton(appointment)],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentActionButton(Appointment appointment) {
    String buttonText;
    Color buttonColor;
    Color textColor;
    Color iconColor;
    IconData buttonIcon;
    VoidCallback? onTap;
    bool isFilled;

    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        buttonText = 'Mark as completed';
        buttonColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF4CAF50);
        iconColor = const Color(0xFF4CAF50);
        buttonIcon = Icons.check;
        isFilled = false; // Not filled initially
        onTap = () => _updateAppointmentStatus(
          appointment.id,
          AppointmentStatus.completed,
        );
        break;
      case AppointmentStatus.missed:
        buttonText = 'missed';
        buttonColor = const Color(0xFFF44336);
        textColor = Colors.white;
        iconColor = Colors.white;
        buttonIcon = Icons.close;
        isFilled = true; // Filled for missed
        onTap = null; // No action for missed appointments
        break;
      case AppointmentStatus.completed:
        buttonText = 'completed';
        buttonColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
        iconColor = Colors.white;
        buttonIcon = Icons.check;
        isFilled = true; // Filled for completed
        onTap = null; // No action for completed appointments
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isFilled ? buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isFilled ? null : Border.all(color: buttonColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(width: 6),
            Icon(buttonIcon, color: iconColor, size: 16),
          ],
        ),
      ),
    );
  }

  void _updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus newStatus,
  ) {
    setState(() {
      final index = appointments.indexWhere((app) => app.id == appointmentId);
      if (index != -1) {
        appointments[index] = appointments[index].copyWith(status: newStatus);
      }
    });
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
            true,
          ),
          _buildBottomNavItem(
            AppAssets.calendarMenu,
            AppAssets.calendarMenuSelected,
            'Calendar',
            false,
          ),
          _buildBottomNavItem(
            AppAssets.trackMenu,
            AppAssets.trackMenuSelected,
            'Track',
            false,
          ),
          _buildBottomNavItem(
            AppAssets.profileMenu,
            AppAssets.profileMenuSelected,
            'Profile',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    String normalAsset,
    String selectedAsset,
    String label,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            _handleNavigation(label);
          }
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
      case 'Calendar':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalendarScreen(
              medications: medications,
              appointments: appointments,
            ),
          ),
        );
        break;
      case 'Track':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackScreen(
              medications: medications,
              appointments: appointments,
            ),
          ),
        );
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }
}
