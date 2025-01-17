import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String taskName;
  String taskDetails;
  bool isDone;
  DateTime date;
  String id;
  TaskModel(
      {this.id = "",
      required this.taskName,
      required this.taskDetails,
      this.isDone = false,
      required this.date});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "taskName": taskName,
      "taskDetails": taskDetails,
      "isDone": isDone,
      "date": Timestamp.fromDate(date),
    };
  }

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json["id"],
            date: (json["date"]as Timestamp).toDate(),
            taskDetails: json["taskDetails"],
            taskName: json["taskName"],
            isDone: json["isDone"]);
}
