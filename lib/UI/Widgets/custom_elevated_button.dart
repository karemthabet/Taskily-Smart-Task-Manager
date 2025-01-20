import 'package:flutter/material.dart';
import 'package:todo_app/UI/utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key, required this.onPressed, required this.title});
  final void Function() onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed: onPressed,
      child:  Text(
        title,
        style:  TextStyle(
            color: Theme.of(context).brightness==Brightness.light?Colors.white:Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
