import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/option_selection/option_selection_screen.dart';
import 'presentation/screens/language_selection/language_selection_screen.dart';
import 'presentation/screens/onboarding/onboarding_1_screen.dart';
import 'presentation/screens/onboarding/onboarding_2_screen.dart';
import 'presentation/screens/onboarding/onboarding_3_screen.dart';
import 'presentation/screens/patient_info/patient_info_screen.dart';
import 'presentation/screens/caregiver_info/caregiver_info_screen.dart';
import 'presentation/screens/caregiver/caregiver_add_details_screen.dart';
import 'presentation/screens/caregiver/caregiver_home_screen.dart';
import 'presentation/screens/caregiver/caregiver_patients_screen.dart';
import 'presentation/screens/caregiver/caregiver_profile_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/add_medication/add_medication_screen.dart';
import 'presentation/screens/calendar/calendar_screen.dart';
import 'presentation/screens/track/track_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/profile/user_profile_screen.dart';
import 'presentation/screens/profile/my_caregiver_screen.dart';
import 'presentation/screens/profile/settings_screen.dart';
import 'presentation/screens/profile/notification_settings_screen.dart';
import 'presentation/screens/profile/language_settings_screen.dart';
import 'presentation/screens/profile/about_app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notification service
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  runApp(const GentleDoseApp());
}

class GentleDoseApp extends StatelessWidget {
  const GentleDoseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gentle Dose',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const OptionSelectionScreen(),
        '/language-selection': (context) => const LanguageSelectionScreen(),
        '/onboarding-1': (context) => const Onboarding1Screen(),
        '/onboarding-2': (context) => const Onboarding2Screen(),
        '/onboarding-3': (context) => const Onboarding3Screen(),
        '/patient-info': (context) => const PatientInfoScreen(),
        '/caregiver-info': (context) => const CaregiverInfoScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-medication': (context) => const AddMedicationScreen(),
        '/calendar': (context) =>
            CalendarScreen(medications: const [], appointments: const []),
        '/track': (context) =>
            TrackScreen(medications: const [], appointments: const []),
        '/profile': (context) => const ProfileScreen(),
        '/user-profile': (context) => const UserProfileScreen(),
        '/my-caregiver': (context) => const MyCaregiverScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notification-settings': (context) =>
            const NotificationSettingsScreen(),
        '/language-settings': (context) => const LanguageSettingsScreen(),
        '/about-app': (context) => const AboutAppScreen(),
        '/caregiver-add-details': (context) =>
            const CaregiverAddDetailsScreen(),
        '/caregiver-home': (context) => const CaregiverHomeScreen(),
        '/caregiver-patients': (context) => const CaregiverPatientsScreen(),
        '/caregiver-profile': (context) => const CaregiverProfileScreen(),
      },
    );
  }
}
