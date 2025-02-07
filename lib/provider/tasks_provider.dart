import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/remot/firebase_services.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> taskModels = [];
  DateTime selectedDate = DateTime.now();

Stream<List<TaskModel>> getTasksByDate() async* {
  try {
    yield* FirebaseServices.getTasksByData(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day));
  } catch (e) {
    log("Error fetching tasks: $e");
  }
}

Future<void> addTask(TaskModel newTask) async {
  try {
    await FirebaseServices.addTask(newTask).timeout(const Duration(milliseconds: 500));
    taskModels.add(newTask);
    notifyListeners();
  } catch (e) {
    log("Error adding task: $e");
  }
}

  Future<void> changeSelectedDate(DateTime newDate) async {
    try {
      selectedDate = newDate;
       getTasksByDate();
      notifyListeners();
    } catch (e) {
      log("Error changing date: $e");
    }
  }
}