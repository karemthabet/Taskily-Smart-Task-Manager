import 'package:flutter/material.dart';

class CustomTextCard extends StatefulWidget {
  const CustomTextCard(
      {super.key,
      required this.hintText,
      this.controller,
      required this.maxTextLines,
      required this.validator});
  final String hintText;
  final TextEditingController? controller;
  final int maxTextLines;
  final String? Function(String?)? validator;

  @override
  State<CustomTextCard> createState() => _CustomTextCardState();
}

class _CustomTextCardState extends State<CustomTextCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        validator: widget.validator,
        cursorColor: Colors.grey,
        maxLines: widget.maxTextLines,
        controller: widget.controller,
        style: Theme.of(context).textTheme.titleSmall,
        decoration: InputDecoration(
          errorStyle:const TextStyle(color: Colors.red) ,
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
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
          fillColor: const Color.fromARGB(43, 12, 45, 40),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
