import 'package:flutter/material.dart';
import 'package:todo_app/UI/Widgets/textfield_auth.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/views/sign%20in_screen/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const String routeName = "signup";

  @override
  State<SignUp> createState() => _SignInState();
}

class _SignInState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formkey,
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
                  "Let's Get Started!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create an account on To Do to get all features",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextfieldAuth(
                  textEditingController: namecontroller,
                  validator: (data) {
                    if (data == null || data.isEmpty) {
                      return 'Please enter Your name';
                    }

                    return null;
                  },
                  hintText: 'Enter your Name',
                  prefix: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  maxTextLines: null,
                ),
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
                      //Signup with firebase
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(SignIn.routeName);
                      },
                      child: const Text(
                        "Login here",
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
    );
  }
}
