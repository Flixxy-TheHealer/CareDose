import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  String? _userName;

  String? get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
