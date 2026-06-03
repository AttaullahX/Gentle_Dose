import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../onboarding/onboarding_1_screen.dart';

/// Language Selection Screen
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ), // X=30 as per Figma
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center align to match your UI
            children: [
              const SizedBox(height: 286), // Y=286 as per Figma specs
              // Title: "Choose your Language"
              Text(
                'Choose your Language',
                style: AppTextStyles.languageTitle,
                textAlign: TextAlign.center, // Center align as per your UI
              ),

              const SizedBox(
                height: 2,
              ), // Exact 2px spacing between English and Urdu text
              // Subtitle: Urdu text
              Text(
                'اپنی زبان کا انتخاب کریں',
                style: AppTextStyles.languageSubtitle,
                textAlign: TextAlign.center, // Center align as per your UI
              ),

              const SizedBox(
                height: 32,
              ), // Reduced spacing to match your UI better
              // English Button - perfectly centered like your UI
              Center(
                child: _buildLanguageButton(language: 'English', value: 'en'),
              ),

              const SizedBox(height: 15), // Exact 15px spacing between buttons
              // Urdu Button - perfectly centered like your UI
              Center(
                child: _buildLanguageButton(language: 'اردو', value: 'ur'),
              ),

              const Spacer(), // Fill remaining space
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required String language,
    required String value,
  }) {
    final bool isSelected = selectedLanguage == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });

        // Navigate to onboarding screen after selection
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding1Screen()),
          );
        });
      },
      child: Container(
        width: 250, // Width to match your UI
        height:
            50, // Proper height to match your UI (not 127 - that was wrong!)
        decoration: BoxDecoration(
          color: isSelected ? AppColors.languageButtonColor : Colors.white,
          borderRadius: BorderRadius.circular(32), // 32px corner radius
          border: Border.all(
            color: AppColors.languageButtonColor,
            width: 1,
          ), // 1px stroke as per Figma
        ),
        child: Center(
          child: Text(
            language,
            style: isSelected
                ? AppTextStyles.languageButtonSelectedText
                : AppTextStyles.languageButtonText,
          ),
        ),
      ),
    );
  }
}
