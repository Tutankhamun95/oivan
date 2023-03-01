import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oivan/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkModel extends ChangeNotifier {
  final List<User> _users = [];
  List<User> get users => _users;

  void addUsers(User user) async {
    late SharedPreferences sharedPreferences;

    final isExist = _users.contains(user);
    if (isExist) {
      _users.remove(user);
    } else {
      _users.add(user);
    }
    sharedPreferences = await SharedPreferences.getInstance();

    String userData = jsonEncode(_users);

    sharedPreferences.setString('userData', userData);

    // Map<String, dynamic> omak = jsonDecode(userData);

    notifyListeners();
  }

  bool isExist(User user) {
    final isExist = _users.contains(user);
    return isExist;
  }
}
