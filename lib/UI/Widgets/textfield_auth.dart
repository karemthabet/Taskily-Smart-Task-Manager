import 'package:flutter/material.dart';
import 'package:todo_app/UI/utils/app_colors.dart';

class TextfieldAuth extends StatefulWidget {
  const TextfieldAuth({
    super.key,
    required this.hintText,
    this.prefix,
    this.suffex,
    this.textEditingController,
    this.maxTextLines,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  });

  final String hintText;
  final Widget? prefix;
  final Widget? suffex;
  final TextEditingController? textEditingController;
  final int? maxTextLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<TextfieldAuth> createState() => _TextfieldAuthState();
}

class _TextfieldAuthState extends State<TextfieldAuth> {
   bool showPassword=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        maxLines: widget.maxTextLines ?? 1,
        controller: widget.textEditingController ,
        cursorColor: AppColors.primaryColor,
        obscureText: widget.obscureText && !showPassword, // Toggle password visibility without clearing text
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          fillColor: const Color(0xFFF1F1F1),
          filled: true,
          errorStyle: const TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: widget.prefix != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.prefix,
                )
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    showPassword == true ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                )
              : null, // Don't show the eye icon if obscureText is false
        ),
      ),
    );
  }
}
