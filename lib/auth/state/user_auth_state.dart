import 'package:flutter/material.dart';

import '../../hive_helper.dart';
import '../../model/user.dart';

class AuthState extends ChangeNotifier {
  String? email;
  bool passwordVisible = false;
  String? password;

  bool registerPasswordVisible = false;
  bool confirmPasswordVisible = false;
  String? emailRegister;
  String? passwordRegister;
  String? passwordConfirm;

  void togglePasswordVisibilityOn() {
    passwordVisible = false;
    notifyListeners();
  }

  void togglePasswordVisibilityOff() {
    passwordVisible = true;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibilityOn() {
    confirmPasswordVisible = false;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibilityOff() {
    confirmPasswordVisible = true;
    notifyListeners();
  }

  void toggleRegisterPasswordVisibilityOn() {
    registerPasswordVisible = false;
    notifyListeners();
  }

  void toggleRegisterPasswordVisibilityOff() {
    registerPasswordVisible = true;
    notifyListeners();
  }

  onChangedEmail(String value) {
    email = value;
    notifyListeners();
  }

  void onChangedEmailRegister(String value) {
    emailRegister = value;
    notifyListeners();
  }

  onChangedPassword(String value) {
    password = value;
    notifyListeners();
  }

  onChangedRegisterPassword(String value) {
    passwordRegister = value;
    notifyListeners();
  }

  onChangedConfirmPassword(String value) {
    passwordConfirm = value;
    notifyListeners();
  }

  checkIfEmailExist(String? inputtedEmail) async {
    var result = await userBox.values.firstWhere(
        (element) => element.email == inputtedEmail,
        orElse: () =>
            User(userID: -1, email: '-1', isLogin: false, password: '-x1-x2'));
    if (result.userID == -1) {
      return false;
    } else {
      return true;
    }
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

  insertUser(User user) async {
    await userBox.add(user);
    loginAuth(user.email, user.password);
  }

  validateRegister(
      String? password, String? confirmPassword, String? email) async {
    if (email == null ||
        password == null ||
        confirmPassword == null ||
        password != confirmPassword ||
        await checkIfEmailExist(email)) {
      return false;
    } else {
      await insertUser(User(
          userID: userBox.length + 1,
          email: email,
          password: password,
          isLogin: false));
      return true;
    }
  }

  getUser(String email) async {
    var result =
        await userBox.values.firstWhere((element) => element.email == email);
    return result;
  }
}
