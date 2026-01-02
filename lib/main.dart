import 'package:flutter/material.dart';
import 'package:showroom_mobil/screens/login_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Showroom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: const Color(0xFFE6B220),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0066B1),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}
