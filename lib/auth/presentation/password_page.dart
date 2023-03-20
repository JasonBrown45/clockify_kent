import 'package:clockify_kent/activity/presentation/activity_tab.dart';
import 'package:clockify_kent/auth/state/user_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../route/page_route.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, auth, child) {
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
                  Navigator.of(context).pop(createEmailPageRoute());
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
                obscureText: !auth.passwordVisible,
                validator: (value) {
                  if (value == null) {
                    return 'Input cannot be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  auth.onChangedPassword(value);
                },
                decoration: InputDecoration(
                    hintText: 'Input Your Password',
                    suffixIcon: IconButton(
                      icon: !auth.passwordVisible
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final message = ScaffoldMessenger.of(context);
                    var check = await auth.loginAuth(auth.password, auth.email);
                    if (check) {
                      User user = await auth.getUser(auth.email!);
                      navigator.push(MaterialPageRoute(
                          builder: (context) => ActivityBar(activeUser: user)));
                    } else {
                      message.showSnackBar(const SnackBar(
                          content: Text(
                              'Login failed. please check again your password')));
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
      },
    );
  }
}
