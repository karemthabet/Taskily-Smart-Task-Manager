import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/UI/Models/task_model.dart';

abstract class FirebaseServices {
  static CollectionReference<TaskModel> getTasksCollection() =>
      FirebaseFirestore.instance.collection("Tasks").withConverter<TaskModel>(
            fromFirestore: (snapshot, options) =>
                TaskModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );

  static Future<void> addTask(TaskModel task) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    DocumentReference<TaskModel> doc = tasksCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<void> deleteTask(String id) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    return tasksCollection.doc(id).delete();
  }

  static Future<void> updateTask(String id, Map<Object, Object?> data) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    return tasksCollection.doc(id).update(data);
  }

  static Future<List<TaskModel>> getTasks() async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    QuerySnapshot<TaskModel> tasksQuery = await tasksCollection.get();
    return tasksQuery.docs
        .map(
          (e) => e.data(),
        )
        .toList();
  }
}
