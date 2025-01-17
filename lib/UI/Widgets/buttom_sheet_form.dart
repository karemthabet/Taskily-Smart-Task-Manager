import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Widgets/custom_elevated_button.dart';
import 'package:todo_app/UI/Widgets/text_form_field.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/remot/firebase_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtomSheetForm extends StatefulWidget {
  const ButtomSheetForm({super.key});
  @override
  State<ButtomSheetForm> createState() => _ButtomSheetFormState();
}

class _ButtomSheetFormState extends State<ButtomSheetForm> {
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.add_New_Task,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomTextCard(
                  hintText: "enter your task name",
                  controller: textEditingController1,
                  maxTextLines: 1,
                  validator: (data) {
                    if (data == null || data.isEmpty) {
                      return "please enter your task name, cannot be empty";
                    } else if (data.length < 2) {
                      return "please enter valid task name";
                    }
                    return null;
                  },
                ),
                CustomTextCard(
                  validator: (data) {
                    if (data == null || data.isEmpty) {
                      return "please enter your task details, cannot be empty";
                    } else if (data.length < 10) {
                      return "please enter more details about your task";
                    }
                    return null;
                  },
                  hintText: "enter your task details",
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
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: CustomElevatedButton(
                        onPressed: () async {
                          var date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: selectedDate ?? DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 200)),
                            builder: (BuildContext context, Widget? child) {
                              final isDarkMode =
                                  Theme.of(context).brightness == Brightness.dark;
                              return Theme(
                                data: isDarkMode
                                    ? ThemeData.dark().copyWith(
                                        datePickerTheme: DatePickerThemeData(
                                          headerBackgroundColor:
                                              AppColors.primaryColor,
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
                                        datePickerTheme:
                                            const DatePickerThemeData(
                                          headerBackgroundColor:
                                              AppColors.primaryColor,
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
                CustomElevatedButton(
                  title: "Add",
                  onPressed: () {
                    if (key.currentState?.validate() == true) {
                      addTask();
                      setState(() {});
      
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future addTask() async {
    try {
      TaskModel newTask = TaskModel(
          taskName: textEditingController1.text.trim(),
          taskDetails: textEditingController2.text.trim(),
          date: selectedDate);
      await FirebaseServices.addTask(newTask);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error:${e.toString()}"),
      ));
    }
  }
}
