import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_view.dart'; // <-- 1. IMPORT THE PACKAGE

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photographer Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          secondary: Colors.white,
          surface: Colors.black,
          background: Colors.black,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserrat(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: GoogleFonts.montserrat(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          headlineLarge: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          titleMedium: GoogleFonts.openSans(fontSize: 18, color: Colors.white),
          bodyLarge: GoogleFonts.openSans(fontSize: 16, color: Colors.white70),
          bodyMedium: GoogleFonts.openSans(fontSize: 14, color: Colors.white70),
          labelLarge: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      home: const HomeView(),
    );
  }
}