//Public
import 'package:flutter/material.dart';
import 'launchpage.dart';
import 'loginpage.dart';
import 'registerpage.dart';
import 'doctor_loginpage.dart';
//import 'patient_dashboard.dart';
//import 'doctorportal.dart';
import 'resetpasswordpage.dart';
//import 'appointments_page.dart';
//import 'healthsummary.dart';
//import 'schedule_apt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Patient

// Doctor

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LaunchPage(),
      routes: {
        "/login": (context) => const LoginPage(),
        "/register": (context) => const RegisterPage(),
        "/doctorLogin": (context) => const DoctorLoginPage(),
        "/resetPassword": (context) => const ResetPasswordPage(),
        // "/doctorportal.dart": (context) => const DoctorDashboard(doctorId: 'D001'),
      },
    ),
  );
}
