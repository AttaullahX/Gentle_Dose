import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';

/// Caregiver Information Screen - Add Caregiver
class CaregiverInfoScreen extends StatefulWidget {
  const CaregiverInfoScreen({super.key});

  @override
  State<CaregiverInfoScreen> createState() => _CaregiverInfoScreenState();
}

class _CaregiverInfoScreenState extends State<CaregiverInfoScreen> {
  final TextEditingController _caregiverNameController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  String _selectedRelationship = '';
  String _selectedFrequency = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Caregiver',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Caregiver Name field
            _buildTextField(
              label: 'Caregiver Name',
              placeholder: 'Enter caregiver name',
              controller: _caregiverNameController,
            ),

            const SizedBox(height: 24),

            // Relationship to Patient field
            _buildRelationshipField(),

            const SizedBox(height: 24),

            // Contact Number field
            _buildTextField(
              label: 'Contact Number',
              placeholder: '+8801XXXXXXX',
              controller: _contactNumberController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            // Progress Report Frequency field
            _buildFrequencyField(),

            const Spacer(),

            // Action buttons
            _buildActionButtons(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF9E9E9E),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship to Patient',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildRelationshipOption('Parent')),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Spouse')),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Child')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildRelationshipOption('Friend')),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Doctor')),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Other')),
          ],
        ),
      ],
    );
  }

  Widget _buildRelationshipOption(String relationship) {
    final isSelected = _selectedRelationship == relationship;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRelationship = relationship;
        });
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF407CE2) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF407CE2)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child: Text(
            relationship,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Report Frequency',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildFrequencyRadioOption('Daily'),
            const SizedBox(width: 24),
            _buildFrequencyRadioOption('Weekly'),
          ],
        ),
        const SizedBox(height: 8),
        _buildFrequencyRadioOption('Only if dose missed'),
      ],
    );
  }

  Widget _buildFrequencyRadioOption(String frequency) {
    final isSelected = _selectedFrequency == frequency;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = frequency;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF407CE2)
                    : const Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF407CE2),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            frequency,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Confirm button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to home screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF407CE2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Skip for now button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to home screen (skip caregiver setup)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF407CE2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Skip for now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF407CE2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _caregiverNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }
}
