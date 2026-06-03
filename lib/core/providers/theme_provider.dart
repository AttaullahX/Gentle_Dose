import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    notifyListeners();
  }

  // ─── LIGHT THEME ───────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF407CE2),
          secondary: Color(0xFF1446A1),
          surface: Colors.white,
          background: Color(0xFFF8F9FA),
          onPrimary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        cardColor: Colors.white,
        dividerColor: Color(0xFFE0E0E0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF407CE2), width: 2),
          ),
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.black87),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF407CE2)
                : Colors.grey[300],
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF407CE2).withOpacity(0.4)
                : Colors.grey[200],
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF407CE2),
          unselectedItemColor: Colors.grey,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      );

  // ─── DARK THEME ────────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5B9BFF),       // Brighter blue for dark bg
          secondary: Color(0xFF7EB3FF),
          surface: Color(0xFF1E2533),        // Card / surface color
          background: Color(0xFF12161F),     // Deep navy background
          onPrimary: Colors.white,
          onSurface: Color(0xFFE8EDF5),      // Soft white text
          onBackground: Color(0xFFE8EDF5),
          error: Color(0xFFFF6B6B),
        ),
        scaffoldBackgroundColor: const Color(0xFF12161F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1F2E),
          foregroundColor: Color(0xFFE8EDF5),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFFE8EDF5)),
        ),
        cardColor: const Color(0xFF1E2533),
        dividerColor: const Color(0xFF2A3144),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E2533),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: const Color(0xFF2A3144)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: const BorderSide(color: Color(0xFF2A3144)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF5B9BFF), width: 2),
          ),
          hintStyle: const TextStyle(color: Color(0xFF6B7A99)),
          labelStyle: const TextStyle(color: Color(0xFFE8EDF5)),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF5B9BFF)
                : const Color(0xFF3A4155),
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF5B9BFF).withOpacity(0.4)
                : const Color(0xFF2A3144),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1F2E),
          selectedItemColor: Color(0xFF5B9BFF),
          unselectedItemColor: Color(0xFF6B7A99),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE8EDF5)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE8EDF5)),
          bodyMedium: TextStyle(color: Color(0xFFB8C4D9)),
          titleLarge: TextStyle(color: Color(0xFFE8EDF5), fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Color(0xFFE8EDF5), fontWeight: FontWeight.w500),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B9BFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF5B9BFF),
            side: const BorderSide(color: Color(0xFF2A3144)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      );
}
