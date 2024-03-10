import 'package:dog_adoption/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //signed in
          if(snapshot.hasData){
            return  HomePage();
          }

          //not signed in
          else{
            return const LoginOrRegister();
          }

        },
      )
    );
  }
}
