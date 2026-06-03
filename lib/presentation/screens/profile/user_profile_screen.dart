import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _contactController = TextEditingController();
  final _authService = AuthService();

  String _selectedGender = 'Male';
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _authService.getPatientProfile();
    if (data != null && mounted) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _ageController.text = data['age'] ?? '';
        _bloodGroupController.text = data['bloodGroup'] ?? '';
        _contactController.text = data['contactNumber'] ?? '';
        _selectedGender = data['gender'] ?? 'Male';
        _isFetching = false;
      });
    } else {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bloodGroupController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black,
          ),
        ),
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildInputField(
                    'Name',
                    'Enter your name',
                    _nameController,
                    isDark,
                    cs,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    'Age',
                    'Enter your age',
                    _ageController,
                    isDark,
                    cs,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildGenderField(isDark, cs),
                  const SizedBox(height: 20),
                  _buildInputField(
                    'Blood Group',
                    'e.g. O+',
                    _bloodGroupController,
                    isDark,
                    cs,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    'Contact Number',
                    '+92...',
                    _contactController,
                    isDark,
                    cs,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 40),
                  _buildSaveButton(cs),
                  const SizedBox(height: 16),
                  _buildCancelButton(isDark),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController ctrl,
    bool isDark,
    ColorScheme cs, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? const Color(0xFF6B7A99) : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E2533) : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF2A3144) : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF2A3144) : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary, width: 2),
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

  Widget _buildGenderField(bool isDark, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildGenderOption('Male', isDark, cs)),
            const SizedBox(width: 12),
            Expanded(child: _buildGenderOption('Female', isDark, cs)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, bool isDark, ColorScheme cs) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary
              : isDark
              ? const Color(0xFF1E2533)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : isDark
                ? const Color(0xFF2A3144)
                : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : isDark
                  ? const Color(0xFF6B7A99)
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Save Changes',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? const Color(0xFF2A3144) : Colors.grey[300]!,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Cancel',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF6B7A99) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter the name is Compulsory'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.savePatientProfile(
        name: _nameController.text,
        age: _ageController.text,
        gender: _selectedGender,
        bloodGroup: _bloodGroupController.text,
        contactNumber: _contactController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
