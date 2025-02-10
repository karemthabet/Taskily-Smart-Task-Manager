// SignIn.dart

// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Widgets/textfield_auth.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/remot/firebase_services.dart';
import 'package:todo_app/views/signup_screen/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static const String routeName = "signin";

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          "Sign In",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  height: 120,
                ),
                const SizedBox(height: 15),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Log in to your existing To Do account",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextfieldAuth(
                  textEditingController: emailController,
                  validator: (data) {
                    if (data == null || data.isEmpty) {
                      return 'Please enter an email address';
                    }
                    final emailRegExp = RegExp(
                        (r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
                    if (!emailRegExp.hasMatch(data)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  hintText: 'Enter your email',
                  prefix: const Icon(
                    Icons.email_outlined,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextfieldAuth(
                  textEditingController: passwordController,
                  validator: (data) {
                    if (data == null || data.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (data.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  obscureText: true,
                  hintText: 'Enter your password',
                  prefix: const Icon(
                    Icons.lock_clock_outlined,
                    color: Colors.black,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (emailController.text == "") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc:
                              'Email cannot be Empty', // النص الذي سيظهر في الـ Dialog
                          btnOkText: "OK", // نص زر OK
                          btnOkColor: Colors.red, // اللون الأحمر للزر
                          btnOkOnPress: () {
                            Navigator.of(context)
                                .popAndPushNamed(SignIn.routeName);
                          },
                          titleTextStyle: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          descTextStyle: const TextStyle(color: Colors.red),
                        ).show();
                      } else {
                        try {
                          FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            animType: AnimType.rightSlide,
                            title: '',
                            desc:
                                'check your email and add new password', // النص الذي سيظهر في الـ Dialog
                            btnOkText: "OK", // نص زر OK
                            btnOkColor:
                                AppColors.primaryColor, // اللون الأحمر للزر
                            btnOkOnPress: () {
                              Navigator.of(context)
                                  .popAndPushNamed(SignIn.routeName);
                            },
                            titleTextStyle: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            descTextStyle: const TextStyle(color: Colors.red),
                          ).show();
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc:
                                'Email cannot be Empty', // النص الذي سيظهر في الـ Dialog
                            btnOkText: "OK", // نص زر OK
                            btnOkColor: Colors.red, // اللون الأحمر للزر
                            btnOkOnPress: () {
                              Navigator.of(context)
                                  .popAndPushNamed(SignIn.routeName);
                            },
                            titleTextStyle: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            descTextStyle: const TextStyle(color: Colors.red),
                          ).show();
                        }
                      }
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Provider.of<LocalAuthProvider>(context, listen: false)
                          .signIn(
                        emailController.text,
                        passwordController.text,
                        context,
                      );
                    }
                  },
                  child: const Center(
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Don’t have an account?",
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SignUp.routeName);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          GoogleSignIn googleSignIn = GoogleSignIn();
                          googleSignIn.disconnect();
                          await FirebaseServices.signInWithGoogle(context);
                        },
                        icon: Icon(Icons.g_mobiledata, color: Colors.white),
                        label: Text("Google"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          minimumSize: Size(100, 40),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                         await  FirebaseServices.signInWithFacebook(context);
                        },
                        icon: Icon(Icons.facebook, color: Colors.white),
                        label: Text("Facebook"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          minimumSize: Size(100, 40),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
