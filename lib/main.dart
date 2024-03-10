import 'package:dog_adoption/firebase_options.dart';
import 'package:dog_adoption/pages/home_page.dart';
import 'package:dog_adoption/pages/profile_page.dart';
import 'package:dog_adoption/pages/users_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dog_adoption/auth/login_or_register.dart';
import 'package:dog_adoption/theme/dark_mode.dart';
import 'package:dog_adoption/theme/light_mode.dart';

import 'auth/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/login_register_page':(context) => const LoginOrRegister(),
        '/home_page': (context) =>  HomePage(),
        '/profile_page': (context) =>  ProfilePage(),
        '/users_page': (context) => const UsersPage(),
      },
    );
  }
}