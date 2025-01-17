import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/remot/firebase_services.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> taskModels = [];
  DateTime selectedDate = DateTime.now();
  Future<void> getTasksByDate() async {
    try {
      List<TaskModel> allTasks = await FirebaseServices.getTasksByData(
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day));
      taskModels = allTasks;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> addTask(TaskModel newTask) async {
    try {
      await FirebaseServices.addTask(newTask);
      changeSelectedDate(selectedDate);
      getTasksByDate();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  changeSelectedDate(DateTime newDate) async {
    try {
      selectedDate = newDate;
      await getTasksByDate();
    } catch (e) {
      print(e);
    }
  }
}
