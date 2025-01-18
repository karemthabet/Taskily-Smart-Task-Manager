import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/UI/Widgets/textfield_auth.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/views/signup_screen/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static const String routeName = "signin";

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text("Sign In"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Image(
                    image: AssetImage("assets/images/logo.png"),
                    height: 120,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
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
                  // Email TextField with Validator
                  TextfieldAuth(
                    textEditingController: emailcontroller,
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Please enter an email address';
                      }
                      final emailRegExp = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
                    maxTextLines: null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // Password TextField with Validator
                  TextfieldAuth(
                    textEditingController: passwordcontroller,
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Please enter a password';
                      }
                      // Password should be at least 8 characters
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
                    maxTextLines: null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (formkey.currentState?.validate() == true) {
                        //Login with firebase
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
                  const Text(
                    "or sign up using",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.facebook_outlined,
                          size: 40,
                          color: Color(0xFF1877F2),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              Color(0xFFE1306C),
                              Color(0xFFF77737),
                              Color(0xFFC13584)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.instagram,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          size: 40,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account?",
                        style: TextStyle(color: Colors.black),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
