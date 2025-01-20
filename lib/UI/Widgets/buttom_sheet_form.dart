import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Widgets/custom_elevated_button.dart';
import 'package:todo_app/UI/Widgets/text_form_field.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/tasks_provider.dart';

class ButtomSheetForm extends StatefulWidget {
  const ButtomSheetForm({super.key});
  @override
  State<ButtomSheetForm> createState() => _ButtomSheetFormState();
}

class _ButtomSheetFormState extends State<ButtomSheetForm> {
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = context.read<TasksProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true, // This ensures the UI adjusts when the keyboard shows up
      body: Directionality(
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
                    hintText: "Enter your task name",
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
                    hintText: "Enter your task details",
                    controller: textEditingController2,
                    maxTextLines: 5,
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return "Please enter your task details, cannot be empty";
                      } else if (data.length < 5) {
                        return "Please enter more details about your task";
                      }
                      return null;
                    },
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
                              initialDate: selectedDate,
                              lastDate: DateTime.now().add(const Duration(days: 200)),
                              builder: (BuildContext context, Widget? child) {
                                final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                                return Theme(
                                  data: isDarkMode
                                      ? ThemeData.dark().copyWith(
                                          datePickerTheme: DatePickerThemeData(
                                            headerBackgroundColor: AppColors.primaryColor,
                                            headerForegroundColor: Colors.white,
                                            backgroundColor: Colors.grey[900],
                                          ),
                                        )
                                      : ThemeData.light().copyWith(
                                          datePickerTheme: const DatePickerThemeData(
                                            headerBackgroundColor: AppColors.primaryColor,
                                            headerForegroundColor: Colors.white,
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              setState(() {
                                selectedDate = DateTime(date.year, date.month, date.day);
                              });
                            }
                          },
                          title: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        ),
                      ),
                    ],
                  ),
                  CustomElevatedButton(
                    title: isLoading ? "Loading..." : "Add",
                    onPressed: () async {
                      if (key.currentState?.validate() == true) {
                        TaskModel newTask = TaskModel(
                          taskName: textEditingController1.text.trim(),
                          taskDetails: textEditingController2.text.trim(),
                          date: selectedDate,
                        );
                        setState(() {
                          isLoading = true;
                        });
                        await tasksProvider.addTask(newTask);
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                      }
                    },
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
