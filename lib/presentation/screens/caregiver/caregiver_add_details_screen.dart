import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Caregiver Add Details Screen - Simple form with name and contact
class CaregiverAddDetailsScreen extends StatefulWidget {
  const CaregiverAddDetailsScreen({super.key});

  @override
  State<CaregiverAddDetailsScreen> createState() =>
      _CaregiverAddDetailsScreenState();
}

class _CaregiverAddDetailsScreenState extends State<CaregiverAddDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set placeholder text for contact number
    _contactController.text = '+920000000000';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Details',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Caregiver Name Field
              _buildInputLabel('Caregiver Name'),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _nameController,
                hintText: 'Enter caregiver name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter caregiver name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Contact Number Field
              _buildInputLabel('Contact Number'),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _contactController,
                hintText: '+920000000000',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),

              const Spacer(),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF407CE2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey[500],
        ),
        filled: true,
        fillColor: Colors.grey[50],
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _handleConfirm() {
    if (_formKey.currentState!.validate()) {
      // Save caregiver details
      _saveCaregiverDetails();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Caregiver details saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to caregiver home screen
      Navigator.pushReplacementNamed(context, '/caregiver-home');
    }
  }

  void _saveCaregiverDetails() {
    // Here you would typically save the data to a database or shared preferences
    // For now, we'll just print the values
    print('Caregiver Name: ${_nameController.text}');
    print('Contact Number: ${_contactController.text}');
  }
}
