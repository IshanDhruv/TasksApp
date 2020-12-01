import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tasks_app/services/auth.dart';

import '../home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Tasks App",
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 50),
            Text(
              "A simple app to help complete your tasks and projects",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 50),
            SignInButton(
              Buttons.GoogleDark,
              text: "Sign in with Google",
              onPressed: () {
                signInWithGoogle().then((result) {
                  if (result != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen(user: result);
                        },
                      ),
                    );
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
