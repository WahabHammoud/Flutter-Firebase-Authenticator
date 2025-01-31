import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_fixed/route%20handling/login_or_registed.dart';
import 'package:instagram_clone_fixed/screens/home_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //is user logged in
          if (snapshot.hasData) {
           return const HomeSceen();
          }

          //is user not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
