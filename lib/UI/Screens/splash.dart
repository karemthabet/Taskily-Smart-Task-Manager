import 'package:flutter/material.dart';
import 'package:todo_app/UI/utils/app_assets.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/views/sign%20in_screen/sign_in.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});
  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3),(){
// ignore: use_build_context_synchronously
Navigator.pushReplacementNamed(context,SignIn.routeName);

    });
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Image.asset(AppAssets.splashLogo)),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                'Supervised by Kareem Thabet',
                style: TextStyle(color: AppColors.primaryColor,fontSize:19,fontWeight: FontWeight.bold ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
