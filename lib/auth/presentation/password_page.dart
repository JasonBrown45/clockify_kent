import 'package:clockify_kent/activity/presentation/activity_tab.dart';
import 'package:clockify_kent/auth/state/user_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../route/page_route.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool _passwordVisible = false;
  String? password;

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

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)?.settings.arguments.toString();
    return Scaffold(
      backgroundColor: const Color(0XFFF2F2F2),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 30, 20, 0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color.fromRGBO(34, 57, 123, 1.0),
            ),
            onPressed: () {
              Navigator.of(context).pop(createEmailPageRoute(email));
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Text(
            'Password',
            style: TextStyle(
                color: Color.fromRGBO(34, 57, 123, 1.0),
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(color: Colors.black),
            obscureText: !_passwordVisible,
            onChanged: (value) {
              password = value;
            },
            decoration: InputDecoration(
                hintText: 'Input Your Password',
                suffixIcon: IconButton(
                  icon: !_passwordVisible
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0XFF45CDDC)),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(8, 8))))),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                var check = await Provider.of<AuthState>(context, listen: false)
                    .loginAuth(password, email);
                if (!mounted) {
                  return;
                }
                if (check) {
                  User user = Provider.of<AuthState>(context, listen: false)
                      .getUser(email!);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityBar(activeUser: user)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Login gagal, periksa kembali password yang dimasukkan')));
                }
              },
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Center(
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                  color: Color(0XFFA7A6C5),
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black),
            ),
          ),
        ),
      ]),
    );
  }
}
