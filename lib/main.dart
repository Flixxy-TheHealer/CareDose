import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
void main() {
  runApp(const CareDoseApp());
}
class CareDoseApp extends StatelessWidget {
  const CareDoseApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareDose',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A56DB),
          primary: const Color(0xFF1A56DB),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
