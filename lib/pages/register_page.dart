import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_adoption/components/my_button.dart';
import 'package:dog_adoption/components/my_textfield.dart';
import 'package:dog_adoption/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  void register() async{
    //loading
    showDialog(
        context: context,
        builder: (context) => Center(
            child: CircularProgressIndicator(),
        ),
    );

    //passwords match
    if(passwordController.text != confirmPwController.text){
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match", context);
    }
    else {
      //create user
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        createUserDocument(userCredential);

        if (context.mounted)  Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void>  createUserDocument(UserCredential? userCredential) async{
    if (userCredential != null && userCredential.user !=null ){
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username' : usernameController.text,
      });
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
                hintText: "Enter name",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10,),
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
              MyTextField(
                hintText: "Confirm password",
                obscureText: true,
                controller: confirmPwController,
              ),
              const SizedBox(height: 10,),

              // sign up button
              MyButton(
                text: "Register",
                onTap: register ,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login here",
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