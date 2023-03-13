import 'package:flutter/material.dart';

import '../../main.dart';
import '../../model/user.dart';

class AuthState extends ChangeNotifier {
  checkIfEmailExist(String? inputtedEmail) {
    var result = userBox.values.firstWhere(
        (element) => element.email == inputtedEmail,
        orElse: () =>
            User(userID: -1, email: '-1', isLogin: false, password: '-x1-x2'));
    if (result.userID == -1) {
      return false;
    } else {
      return true;
    }
  }

  insertUser(User user) async {
    await userBox.add(user);
    loginAuth(user.email, user.password);
  }

  getUser(String email) {
    var result = userBox.values.firstWhere((element) => element.email == email);
    return result;
  }

  loginAuth(String? password, String? email) async {
    var result = await userBox.values.firstWhere(
        (element) => element.email == email && element.password == password,
        orElse: () =>
            User(userID: -1, email: '-1', isLogin: false, password: '-x1-x2'));
    if (result.userID == -1) {
      return false;
    } else {
      result.isLogin == true;
      var index = result.key;
      await userBox.put(index, result);
      return true;
    }
  }

  validateRegister(String? password, String? email) {
    if (email == null || password == null || checkIfEmailExist(email)) {
      return false;
    } else {
      insertUser(User(
          userID: userBox.length,
          email: email,
          password: password,
          isLogin: false));
      return true;
    }
  }
}
