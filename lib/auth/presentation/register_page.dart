import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../activity/presentation/activity_tab.dart';
import '../../model/user.dart';
import '../../route/page_route.dart';
import '../state/user_auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? emailRegister;
  String? passwordRegister;
  String? confirmPassword;

  void _togglePasswordVisibilityOn() {
    setState(() {
      _passwordVisible = false;
    });
  }

  void _togglePasswordVisibilityOff() {
    setState(() {
      _passwordVisible = true;
    });
  }

  void _toggleConfirmPasswordVisibilityOn() {
    setState(() {
      _confirmPasswordVisible = false;
    });
  }

  void _toggleConfirmPasswordVisibilityOff() {
    setState(() {
      _confirmPasswordVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  return 'Mohon isi field ini';
                }
                final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Email tidak valid';
                }
                return null;
              },
              onChanged: (value) {
                emailRegister = value;
              },
              decoration: const InputDecoration(
                  hintText: 'Input Your E-Mail',
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(34, 57, 123, 1.0))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(34, 57, 123, 1.0)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(color: Colors.black),
              obscureText: !_passwordVisible,
              validator: (value) {
                if (value == null) {
                  return 'Mohon isi field ini';
                }
                if (value.length < 8) {
                  return 'Password harus lebih dari 8 karakter';
                }
                return null;
              },
              onChanged: (value) {
                passwordRegister = value;
              },
              decoration: InputDecoration(
                  hintText: 'Create Your Password',
                  suffixIcon: IconButton(
                    icon: _passwordVisible
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      _passwordVisible
                          ? _togglePasswordVisibilityOn()
                          : _togglePasswordVisibilityOff();
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(34, 57, 123, 1.0))),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(34, 57, 123, 1.0)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return 'Mohon isi field ini';
                }
                if (passwordRegister == null) {
                  return 'Mohon isi terlebih dahulu field password';
                } else if (value != passwordRegister) {
                  return 'Input harus sama dengan password';
                }
                return null;
              },
              style: const TextStyle(color: Colors.black),
              obscureText: !_confirmPasswordVisible,
              onChanged: (value) {
                confirmPassword = value;
              },
              decoration: InputDecoration(
                  hintText: 'Confirm Your Password',
                  suffixIcon: IconButton(
                    icon: _confirmPasswordVisible
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      _confirmPasswordVisible
                          ? _toggleConfirmPasswordVisibilityOn()
                          : _toggleConfirmPasswordVisibilityOff();
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(34, 57, 123, 1.0))),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(34, 57, 123, 1.0)))),
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
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(8, 8))))),
                child: const Text(
                  'CREATE',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final registerResult =
                      Provider.of<AuthState>(context, listen: false)
                          .validateRegister(passwordRegister, emailRegister);
                  if (registerResult) {
                    await showDialog(
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
                            content: const Text(
                                "Your Account Has Been Succesfully Created",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0XFFA7A6C5),
                                )),
                          );
                        }));
                    if (!mounted) {
                      return;
                    }
                    User user = Provider.of<AuthState>(context, listen: false)
                        .getUser(emailRegister!);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ActivityBar(activeUser: user)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Register gagal, periksa kembali input yang dimasukkan')));
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
/*
*/