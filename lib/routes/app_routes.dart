import 'package:flutter/material.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/history/history_screen.dart';
import '../features/home/home_screen.dart';
import '../features/inventory/inventory_screen.dart';
import '../features/medicine/add_medicine_screen.dart';
import '../features/profile/profile_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/';
  static const String addMedicine = '/medicine/add';
  static const String inventory = '/inventory';
  static const String history = '/history';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (_) => const LoginScreen(),
      otp: (_) => const OtpScreen(),
      home: (_) => const HomeScreen(),
      addMedicine: (_) => const AddMedicineScreen(),
      inventory: (_) => const InventoryScreen(),
      history: (_) => const HistoryScreen(),
      profile: (_) => const ProfileScreen(),
    };
  }
}
