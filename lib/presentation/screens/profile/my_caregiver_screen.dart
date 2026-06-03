import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// My Caregiver Screen - Add or manage caregiver information
class MyCaregiverScreen extends StatefulWidget {
  const MyCaregiverScreen({super.key});

  @override
  State<MyCaregiverScreen> createState() => _MyCaregiverScreenState();
}

class _MyCaregiverScreenState extends State<MyCaregiverScreen> {
  final _caregiverNameController = TextEditingController();
  final _contactNumberController = TextEditingController();

  String _selectedRelationship = 'Parent';
  String _selectedReportFrequency = 'Daily';

  @override
  void dispose() {
    _caregiverNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

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
          'Add Caregiver',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Caregiver Name field
            _buildInputField(
              'Caregiver Name',
              'Enter caregiver name',
              _caregiverNameController,
            ),

            const SizedBox(height: 20),

            // Relationship to Patient
            _buildRelationshipField(),

            const SizedBox(height: 20),

            // Contact Number field
            _buildInputField(
              'Contact Number',
              '+920000000000',
              _contactNumberController,
            ),

            const SizedBox(height: 20),

            // Progress Report Frequency
            _buildReportFrequencyField(),

            const SizedBox(height: 40),

            // Action buttons
            Column(
              children: [
                _buildSaveButton(),
                const SizedBox(height: 16),
                _buildCancelButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF407CE2)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
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
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildRelationshipChip('Parent'),
            _buildRelationshipChip('Spouse'),
            _buildRelationshipChip('Child'),
            _buildRelationshipChip('Friend'),
            _buildRelationshipChip('Doctor'),
            _buildRelationshipChip('Other'),
          ],
        ),
      ],
    );
  }

  Widget _buildRelationshipChip(String relationship) {
    final isSelected = _selectedRelationship == relationship;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRelationship = relationship;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF407CE2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF407CE2) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          relationship,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildReportFrequencyField() {
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
        Column(
          children: [
            _buildRadioOption('Daily'),
            _buildRadioOption('Weekly'),
            _buildRadioOption('Only if dose missed'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String option) {
    final isSelected = _selectedReportFrequency == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportFrequency = option;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF407CE2)
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF407CE2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveCaregiver,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF407CE2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Text(
          'Save Changes',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Text(
          'Cancel',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _saveCaregiver() {
    // Validate and save caregiver data
    if (_caregiverNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter caregiver name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_contactNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter contact number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Caregiver added successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back
    Navigator.pop(context);
  }
}
