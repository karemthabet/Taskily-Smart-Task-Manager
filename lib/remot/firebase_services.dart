// FirebaseServices.dart

// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Models/user_data_model.dart';
import 'package:todo_app/UI/Screens/home.dart';
import 'package:todo_app/UI/utils/constants%20_managers.dart';
import 'package:todo_app/UI/utils/diaglogs.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/views/sign%20in_screen/sign_in.dart';

abstract class FirebaseServices {
  static CollectionReference<TaskModel> getTasksCollection() => getUserCollection()
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Tasks")
      .withConverter<TaskModel>(
        fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
        toFirestore: (value, _) => value.toJson(),
      ); // aim to catch  tasks collection and create sub collection tasks in collection users
  static CollectionReference<UserDataModel> getUserCollection() =>
      FirebaseFirestore.instance
          .collection("Users")
          .withConverter<UserDataModel>(
            fromFirestore: (snapshot, _) =>
                UserDataModel.fromJson(snapshot.data()!),
            toFirestore: (value, _) => value.toJson(),
          ); // aim to catch  user collection

  static Future<void> addTask(TaskModel task) async {
    try {
      final tasksCollection = getTasksCollection(); //in collection
      final doc =
          tasksCollection.doc(); //create doc and generate auto id for doc
      task.id = doc.id; //assign auto id to task id
      await doc.set(task); //add task model to fire store
    } catch (e) {
      throw Exception("Error adding task: $e");
    }
  }

static Stream<List<TaskModel>> getTasksByData(DateTime selectedDate) async* {
  CollectionReference<TaskModel> tasksCollection = getTasksCollection();
  Stream<QuerySnapshot<TaskModel>> tasksQuery = tasksCollection
      .where("date", isEqualTo: Timestamp.fromDate(selectedDate))
      .snapshots();
  yield* tasksQuery.map((event) => event.docs
      .map(
        (e) => e.data(),
      )
      .toList());
}

  static Future<void> deleteTask(String id) async {
    try {
      final tasksCollection = getTasksCollection();
      await tasksCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }

 static Future<void> updateTask(String id, Map<String, dynamic> data) async {
  try {
    final tasksCollection = getTasksCollection(); // استخدام getTasksCollection بدلاً من getTasksByData
    await tasksCollection.doc(id).update(data);
  } catch (e) {
    throw Exception("Error updating task: $e");
  }
}

  static Future<List<TaskModel>> getTasks() async {
    try {
      final tasksCollection = getTasksCollection();
      final tasksQuery = await tasksCollection.get();
      return tasksQuery.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error fetching tasks: $e");
    }
  }

  static Future register(
      UserDataModel userDataModel, String password, context) async {
    try {
      Diaglogs.showLoading(context, message: "Wait...");
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userDataModel.email!,
        password: password,
      );
      userDataModel.id = credential.user!.uid; // حفظ الـ UID

      await getUserCollection().doc(userDataModel.id).set(userDataModel);

      Diaglogs.hide(context);
      Diaglogs.showMessage(context,
          body: "Account created! Please verify your email before logging in.",
          posActionTitle: "OK", posAction: () {
        Provider.of<TasksProvider>(context, listen: false).getTasksByDate();
        Navigator.pushReplacementNamed(context, SignIn.routeName);
      });
    } on FirebaseAuthException catch (e) {
      Diaglogs.hide(context);
      late String message;
      if (e.code == ConstantsManagers.weekPasswordCode) {
        message = 'The password provided is too weak.';
      } else if (e.code == ConstantsManagers.emailAlreadyUse) {
        message = 'The account already exists for that email.';
      }
      Diaglogs.showMessage(context,
          title: "Error Occurred",
          body: message,
          posActionTitle: "OK", posAction: () {
        Navigator.pop(context);
      });
    } catch (e) {
      Diaglogs.hide(context);
      Diaglogs.showMessage(context,
          title: "Error Occurred", body: e.toString());
    }
  }

  static Future signIn(
      UserDataModel userDataModel, String password, context) async {
    try {
      Diaglogs.showLoading(context, message: "Wait...");

      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userDataModel.email!,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload(); // تحديث حالة المستخدم
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (user.emailVerified) {
          Diaglogs.hide(context);
          Diaglogs.showMessage(context,
              body: "User logged in successfully",
              posActionTitle: "OK", posAction: () {
            Provider.of<TasksProvider>(context, listen: false).getTasksByDate();
            Navigator.popAndPushNamed(context, Home.routeName);
          });
        } else {
          Diaglogs.hide(context);
          Diaglogs.showMessage(context,
              title: "Email Verification Required",
              body:
                  "Your email is not verified. Please verify your email before logging in.",
              posAction: () async {
                await user!.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          "Verification email sent. Please check your inbox.")),
                );
                Navigator.pop(context);
              },
              negActionTitle: "OK",
              negAction: () {
                Navigator.pop(context);
              });
        }
      } else {
        Diaglogs.hide(context);
        Diaglogs.showMessage(context,
            title: "Error",
            body: "User data not found.",
            posActionTitle: "OK", posAction: () {
          Navigator.pop(context);
        });
      }
    } on FirebaseAuthException catch (e) {
      Diaglogs.hide(context);
      String message = "An error occurred";

      if (e.code == ConstantsManagers.invalidcredential) {
        message = "Wrong email or password";
      }

      Diaglogs.showMessage(context,
          title: " an  Error Occurred",
          body: message,
          posActionTitle: "OK", posAction: () {
        Navigator.pop(context);
      });
    } catch (e) {
      Diaglogs.hide(context);
      Diaglogs.showMessage(context,
          title: "Error Occurred", body: e.toString());
    }
  }

  static Future<UserDataModel?> getUser(String userId) async {
    try {
      DocumentSnapshot<UserDataModel> userDoc =
          await getUserCollection().doc(userId).get();

      return userDoc.data();
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
