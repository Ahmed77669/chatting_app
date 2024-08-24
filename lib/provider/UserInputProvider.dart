import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _nameUser = '';
  String _emailUser = '';
  // Map<String, dynamic> ?data_2 ;

  String get nameUser => _nameUser;
  String get emailUser => _emailUser;

  void setUserData(String name, String email) {
    _nameUser = name;
    _emailUser = email;
    notifyListeners();
  }
}
