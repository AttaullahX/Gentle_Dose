import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_assets.dart';
import 'onboarding_3_screen.dart';

/// Onboarding Screen 2 - "Track all your health tasks in one place"
class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip Button - Same position as onboarding 1
            Positioned(left: 335, top: 35, child: _buildSkipButton()),

            // Main Image - Same position as onboarding 1
            Positioned(left: 18, top: 140, child: _buildMainImage()),

            // Title Text - Same position as onboarding 1
            Positioned(
              left: 71,
              top: 540,
              width: 274,
              height: 60,
              child: _buildTitleText(),
            ),

            // Progress Indicators - Same position, but 2nd indicator active
            Positioned(left: 40, top: 705, child: _buildProgressIndicators()),

            // Next Button Circle - Same position as onboarding 1
            Positioned(left: 310, top: 679, child: _buildNextButton()),
          ],
        ),
      ),
    );
  }

  /// Skip Button - Navigate to main app
  Widget _buildSkipButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Skip to main app - Navigate directly from any onboarding screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/main', // Will need to implement main screen route
            (route) => false,
          );
        },
        child: Text(
          'Skip',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFA1A8B0),
          ),
        ),
      ),
    );
  }

  /// Main illustration image - Onboarding 2
  Widget _buildMainImage() {
    return SizedBox(
      width: 326,
      height: 389,
      child: Image.asset(
        AppAssets.onboarding2, // Changed to onboarding 2 image
        width: 326,
        height: 389,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Title text - Onboarding 2 text
  Widget _buildTitleText() {
    return Text(
      'Track all your health\ntasks in one place.',
      textAlign: TextAlign.left,
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.2,
      ),
    );
  }

  /// Progress indicators - 2nd indicator active
  Widget _buildProgressIndicators() {
    return Row(
      children: [
        // First indicator - Inactive
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        // Second indicator - Active (blue)
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.languageButtonColor, // #407CE2
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        // Third indicator - Inactive
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  /// Next button - Navigate to onboarding 3
  Widget _buildNextButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding3Screen()),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.languageButtonColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward,
              size: 24,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
