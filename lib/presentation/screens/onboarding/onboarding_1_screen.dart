import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_assets.dart';
import 'onboarding_2_screen.dart';

/// Onboarding Screen 1 - "Gentle reminders keep you on time"
class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip Button - More left shift
            Positioned(left: 335, top: 35, child: _buildSkipButton()),

            // Main Image - Position: X=18, Y=140, Dimensions: W=326, H=389
            Positioned(left: 18, top: 140, child: _buildMainImage()),

            // Title Text - Shifted to middle
            Positioned(
              left: 71, // Shifted more to center from 30
              top: 560,
              width: 274,
              height: 60,
              child: _buildTitleText(),
            ),

            // Progress Indicators - More right shift
            Positioned(left: 40, top: 705, child: _buildProgressIndicators()),

            // Next Button Circle - More left shift
            Positioned(left: 310, top: 679, child: _buildNextButton()),
          ],
        ),
      ),
    );
  }

  /// Skip Button with exact Figma specs
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
            fontWeight: FontWeight.w400, // Regular
            color: const Color(0xFFA1A8B0), // Exact color from specs
          ),
        ),
      ),
    );
  }

  /// Main illustration image
  Widget _buildMainImage() {
    return SizedBox(
      width: 326, // W=326 as per specs
      height: 389, // H=389 as per specs
      child: Image.asset(
        AppAssets.onboarding1,
        width: 326,
        height: 389,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Title text with exact specs
  Widget _buildTitleText() {
    return Text(
      'Gentle reminders keep\nyou on time',
      textAlign:
          TextAlign.left, // Left aligned to fit in the positioned container
      style: GoogleFonts.poppins(
        fontSize: 22, // Exact size as per specs
        fontWeight: FontWeight.w700, // Bold as per specs
        color: Colors.black,
        height: 1.2,
      ),
    );
  }

  /// Progress indicators with smaller size
  Widget _buildProgressIndicators() {
    return Row(
      children: [
        // Active indicator - Smaller size
        Container(
          width: 20, // Reduced from 29
          height: 3, // Reduced from 4
          decoration: BoxDecoration(
            color: AppColors.languageButtonColor, // #407CE2
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6), // Reduced spacing
        // Inactive indicators
        Container(
          width: 20, // Reduced from 29
          height: 3, // Reduced from 4
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6), // Reduced spacing
        Container(
          width: 20, // Reduced from 29
          height: 3, // Reduced from 4
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  /// Next button circle with arrow
  Widget _buildNextButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding2Screen()),
          );
        },
        child: Container(
          width: 56, // W=56 as per specs
          height: 56, // H=56 as per specs
          decoration: BoxDecoration(
            color: AppColors.languageButtonColor, // #407CE2
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ), // Center the arrow (16+24+16 = 56)
            child: Icon(
              Icons.arrow_forward,
              size: 24, // W=24, H=24 as per specs
              color: const Color(0xFFFFFFFF), // Arrow color: #FFFFFF
            ),
          ),
        ),
      ),
    );
  }
}
