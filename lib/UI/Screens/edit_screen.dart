import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Widgets/custom_elevated_button.dart';
import 'package:todo_app/UI/Widgets/scaffold_custom.dart';
import 'package:todo_app/UI/Widgets/text_form_field.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/remot/firebase_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.task});
  final TaskModel task;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  GlobalKey<FormState> key = GlobalKey();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController(text: widget.task.taskName);
    textEditingController2 = TextEditingController(text: widget.task.taskDetails);
      DateTime selectedDate = DateTime.now();

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ScaffoldCustom(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.edittask,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Scaffold(
          resizeToAvoidBottomInset: true,  // Ensure screen resizes when keyboard appears
          body: SingleChildScrollView(  // Wrap the body with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      "assets/images/todo-512.webp",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextCard(
                    hintText: "Enter your new task name",
                    controller: textEditingController1,
                    maxTextLines: 1,
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return "Please enter your task name, cannot be empty";
                      } else if (data.length < 2) {
                        return "Please enter a valid task name";
                      }
                      return null;
                    },
                  ),
                  CustomTextCard(
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return "Please enter your task details, cannot be empty";
                      } else if (data.length < 10) {
                        return "Please enter more details about your task";
                      }
                      return null;
                    },
                    hintText: "Enter your new task details",
                    controller: textEditingController2,
                    maxTextLines: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Select Date:",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: CustomElevatedButton(
                          onPressed: () async {
                            var date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: selectedDate,
                              lastDate: DateTime.now().add(const Duration(days: 200)),
                              builder: (BuildContext context, Widget? child) {
                                final isDarkMode =
                                    Theme.of(context).brightness == Brightness.dark;
                                return Theme(
                                  data: isDarkMode
                                      ? ThemeData.dark().copyWith(
                                          datePickerTheme: DatePickerThemeData(
                                            headerBackgroundColor: AppColors.primaryColor,
                                            headerForegroundColor: Colors.white,
                                            backgroundColor: Colors.grey[900],
                                          ),
                                          textTheme: const TextTheme(
                                            titleLarge: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : ThemeData.light().copyWith(
                                          datePickerTheme: const DatePickerThemeData(
                                            headerBackgroundColor: AppColors.primaryColor,
                                            headerForegroundColor: Colors.white,
                                            backgroundColor: Colors.white,
                                          ),
                                          textTheme: const TextTheme(
                                            titleLarge: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          },
                          title: selectedDate != null
                              ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                              : "Select Date",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  CustomElevatedButton(
                    onPressed: () async {
                      await FirebaseServices.updateTask(widget.task.id, {
                        "taskName": textEditingController1.text,
                        "taskDetails": textEditingController2.text,
                        "date": selectedDate.toString(),
                      });
                      Navigator.pop(context);
                      // log (selectedDate);
                    },
                    title: AppLocalizations.of(context)!.savechanges,
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
