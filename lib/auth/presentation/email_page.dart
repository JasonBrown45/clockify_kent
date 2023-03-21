import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/page_route.dart';
import '../state/user_auth_state.dart';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(34, 57, 123, 1.0),
        body: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          child: Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 120, 30, 40),
                child: Image.asset('assets/images/clockify_logo.png'),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 320, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Consumer<AuthState>(
                        builder: (context, auth, child) {
                          return TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Input cannot be empty';
                              }
                              return null;
                            },
                            initialValue: auth.email,
                            onChanged: (text) {
                              auth.onChangedEmail(text);
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.email_rounded,
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          );
                        },
                      )),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<AuthState>(builder: (context, auth, child) {
                      return ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(8, 8))))),
                          child: const Text('SIGN IN'),
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            final message = ScaffoldMessenger.of(context);
                            var check =
                                await auth.checkIfEmailExist(auth.email);
                            if (check) {
                              navigator.push(createPasswordPageRoute());
                            } else {
                              message.showSnackBar(const SnackBar(
                                  content: Text(
                                      'Inputted E-Mail is wrong, or E-Mail does not exist on our database')));
                            }
                          });
                    }),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(createRegisterPageRoute());
              },
              child: const Text(
                'Create New Account?',
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white),
              ),
            ),
          ]),
        ));
  }
}
