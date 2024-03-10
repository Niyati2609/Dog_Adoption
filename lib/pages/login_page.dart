import 'package:dog_adoption/components/my_button.dart';
import 'package:dog_adoption/components/my_textfield.dart';
import 'package:dog_adoption/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        )
    );

    // signin
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text );
      if(context.mounted) Navigator.pop(context);
    }
    //display error
    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),

              // app name
              const Text(
                "D O G G O",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50,),

              // email textfield
              MyTextField(
                  hintText: "Enter email",
                  obscureText: false,
                  controller: emailController,
              ),
              const SizedBox(height: 10,),

              // password textfield
              MyTextField(
                hintText: "Enter password",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10,),
              const SizedBox(height: 10,),
              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot password?", style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                ],
              ),
              const SizedBox(height: 10,),

              // sign in button
              MyButton(
                  text: "Login",
                  onTap: login ,
              ),

              // sign up button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Register here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}