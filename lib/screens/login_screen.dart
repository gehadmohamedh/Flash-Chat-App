import 'package:flutter/material.dart';
import 'package:flash_chat/Components.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
//import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpiner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password ')),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                text: 'Log in ',
                onpress: () async {
                  showSpiner = true;
                  setState(() {});

                  try {
                    dynamic user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != Null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  }

                  setState(() {
                    showSpiner = false;
                  });
                },
                color: Colors.blueGrey.shade300)
          ],
        ),
      ),
    );
  }
}
