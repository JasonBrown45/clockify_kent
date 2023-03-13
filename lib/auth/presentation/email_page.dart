import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../route/page_route.dart';
import '../state/user_auth_state.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(34, 57, 123, 1.0),
        body: SingleChildScrollView(
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
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Input ini kosong, mohon diisi';
                        }
                        return null;
                      },
                      initialValue: email,
                      onChanged: (text) {
                        email = text;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.email_rounded,
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(8, 8))))),
                      child: const Text('SIGN IN'),
                      onPressed: () {
                        var check =
                            Provider.of<AuthState>(context, listen: false)
                                .checkIfEmailExist(email);
                        if (check) {
                          Navigator.of(context)
                              .push(createPasswordPageRoute(email));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'E-mail yang dimasukkan tidak ada dalam database kami, atau E-Mail yang dimasukkan salah')));
                        }
                      },
                    ),
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
