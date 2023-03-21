import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../activity/presentation/activity_tab.dart';
import '../../model/user.dart';
import '../../routes/page_route.dart';
import '../state/user_auth_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, auth, child) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 30, 20, 0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color.fromRGBO(34, 57, 123, 1.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(createEmailPageRoute2());
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Text(
                  'Create New Account',
                  style: TextStyle(
                      color: Color.fromRGBO(34, 57, 123, 1.0),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null) {
                      return 'Input cannot be empty';
                    }
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return 'Email is not valid';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    auth.onChangedEmailRegister(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Input Your E-Mail',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(34, 57, 123, 1.0))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(34, 57, 123, 1.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(color: Colors.black),
                  obscureText: !auth.passwordVisible,
                  validator: (value) {
                    if (value == null) {
                      return 'Input cannot be empty';
                    }
                    if (value.length < 8) {
                      return 'Password length must be no less than 8 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    auth.onChangedRegisterPassword(value);
                  },
                  decoration: InputDecoration(
                      hintText: 'Create Your Password',
                      suffixIcon: IconButton(
                        icon: auth.passwordVisible
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          auth.passwordVisible
                              ? auth.togglePasswordVisibilityOn()
                              : auth.togglePasswordVisibilityOff();
                        },
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(34, 57, 123, 1.0))),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(34, 57, 123, 1.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'Input cannot be empty';
                    }
                    if (auth.passwordRegister == null) {
                      return 'Password field cannot be empty';
                    } else if (value != auth.passwordRegister) {
                      return 'Input must be equal to password field';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  obscureText: !auth.confirmPasswordVisible,
                  onChanged: (value) {
                    auth.onChangedConfirmPassword(value);
                  },
                  decoration: InputDecoration(
                      hintText: 'Confirm Your Password',
                      suffixIcon: IconButton(
                        icon: auth.confirmPasswordVisible
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          auth.confirmPasswordVisible
                              ? auth.toggleConfirmPasswordVisibilityOn()
                              : auth.toggleConfirmPasswordVisibilityOff();
                        },
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(34, 57, 123, 1.0))),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(34, 57, 123, 1.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 270, 20, 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0XFF45CDDC)),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(8, 8))))),
                    child: const Text(
                      'CREATE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final message = ScaffoldMessenger.of(context);
                      var dialog = showSuccessDialog(context);
                      bool registerResult = await auth.validateRegister(
                          auth.passwordRegister,
                          auth.emailRegister,
                          auth.passwordConfirm);
                      if (registerResult) {
                        await dialog;
                        User user = await auth.getUser(auth.emailRegister!);
                        navigator.push(MaterialPageRoute(
                            builder: (context) =>
                                ActivityBar(activeUser: user)));
                      } else {
                        message.showSnackBar(const SnackBar(
                            content: Text(
                                'Register failed, please check again your input')));
                      }
                    },
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  showSuccessDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Column(
              children: [
                Image.asset(
                  'assets/images/thumbs_up.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'SUCCESS',
                  style: TextStyle(
                      color: Color(0XFFA7A6C5),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            content: const Text("Your Account Has Been Succesfully Created",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0XFFA7A6C5),
                )),
          );
        }));
  }
}

/*
*/