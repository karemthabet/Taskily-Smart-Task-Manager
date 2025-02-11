// FirebaseServices.dart

// ignore_for_file: unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Models/user_data_model.dart';
import 'package:todo_app/UI/Screens/home.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/UI/utils/constants%20_managers.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/views/sign%20in_screen/sign_in.dart';
import 'package:todo_app/views/signup_screen/sign_up.dart';

DateTime selectedDatee =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

abstract class FirebaseServices {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
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

  static Stream<List<TaskModel>> getTasksByData(
      {required DateTime? selectedDate}) async* {
    DateTime onlyDate = selectedDate ?? selectedDatee;
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();

    Stream<QuerySnapshot<TaskModel>> tasksQuery = tasksCollection
        .where("date", isEqualTo: Timestamp.fromDate(onlyDate))
        .snapshots();

    yield* tasksQuery.map((event) => event.docs.map((e) => e.data()).toList());
  }

  static Future<void> deleteTask(String id) async {
    try {
      final tasksCollection = getTasksCollection();
      await tasksCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }

  static Future<void> updateTask(
      {required String id, required Map<String, dynamic> data}) async {
    try {
      final tasksCollection = getTasksCollection();
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

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
    _googleSignIn.disconnect();
  }

  static Future<void> register({
    required UserDataModel userDataModel,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userDataModel.email!,
        password: password,
      );

      userDataModel.id = credential.user!.uid; // حفظ الـ UID

      await getUserCollection().doc(userDataModel.id).set(userDataModel);

      _showSuccessDialog(
        context: context,
        message: "Account created! Please verify your email before logging in.",
        onOkPress: () {
          Navigator.pushReplacementNamed(context, SignIn.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      late String message;
      if (e.code == ConstantsManagers.weekPasswordCode) {
        message = 'The password provided is too weak.';
      } else if (e.code == ConstantsManagers.emailAlreadyUse) {
        message = 'The account already exists for that email.';
      } else {
        message = 'No internet connection. Please check your connection and try again.';
      }

      _showErrorDialog(
        context: context,
        message: message,
        onOkPress: () {
          Navigator.popAndPushNamed(context, SignUp.routeName);
        },
      );
    } catch (e) {
      _showWarningDialog(
        context: context,
        message:
            "No internet connection. Please check your connection and try again.",
        onOkPress: () {
          Navigator.popAndPushNamed(context, SignUp.routeName);
        },
      );
    }
  }

  static Future<bool> checkInternetConnection(BuildContext context) async {
    var connectivityResult =
        await InternetConnectionChecker.instance.hasConnection;
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  static Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (user.emailVerified) {
          _showSuccessDialog(
            context: context,
            message: "User logged in successfully",
            onOkPress: () {
              Provider.of<TasksProvider>(context, listen: false)
                  .getTasksByDate();
              Navigator.popAndPushNamed(context, Home.routeName);
            },
          );
        } else {
          _showInfoDialog(
            context: context,
            message:
                "Your email is not verified. Please verify your email before logging in.",
            onOkPress: () =>
                Navigator.popAndPushNamed(context, SignIn.routeName),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == ConstantsManagers.invalidcredential) {
        _showErrorDialog(
          context: context,
          message: "Wrong email or password",
          onOkPress: () => Navigator.popAndPushNamed(context, SignIn.routeName),
        );
      } else {
        _showWarningDialog(
          context: context,
          message: "Check your internet",
          onOkPress: () => Navigator.popAndPushNamed(context, SignIn.routeName),
        );
      }
    } catch (e) {
      {
        _showErrorDialog(
          context: context,
          message: "An unexpected error occurred",
          onOkPress: () => Navigator.popAndPushNamed(context, SignIn.routeName),
        );
      }
    }
  }

  static Future<void> forgotPassword({
    required TextEditingController emailController,
    required BuildContext context,
  }) async {
    if (emailController.text.isEmpty) {
      _showErrorDialog(
        context: context,
        message: "Please enter your email address",
        onOkPress: () =>
            Navigator.of(context).popAndPushNamed(SignIn.routeName),
      );
      return;
    }

    if (!emailRegExp.hasMatch(emailController.text)) {
      _showErrorDialog(
        context: context,
        message: "Please enter a valid email address",
        onOkPress: () =>
            Navigator.of(context).popAndPushNamed(SignIn.routeName),
      );
      return;
    }

    if (!await checkInternetConnection(context)) {
      _showWarningDialog(
        context: context,
        message: "Check your internet connection",
        onOkPress: () =>
            Navigator.of(context).popAndPushNamed(SignIn.routeName),
      );
      return;
    }

    _showLoadingDialog(context);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);

      Navigator.popAndPushNamed(context, SignIn.routeName);

      _showInfoDialog(
        context: context,
        message: "Please check your email to reset your password",
        onOkPress: () =>
            Navigator.of(context).popAndPushNamed(SignIn.routeName),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.popAndPushNamed(context, SignIn.routeName);

      String errorMessage = "An unexpected error occurred";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Check your internet connection";
      }

      _showWarningDialog(
        context: context,
        message: errorMessage,
        onOkPress: () =>
            Navigator.of(context).popAndPushNamed(SignIn.routeName),
      );
    } catch (e) {
      Navigator.popAndPushNamed(context, SignIn.routeName);

      _showErrorDialog(
        context: context,
        message: "Check your internet connection",
        onOkPress: () =>
            Navigator.of(context).popAndPushNamed(SignIn.routeName),
      );
    }
  }

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        _showSuccessDialog(
          context: context,
          message: "User logged in successfully",
          onOkPress: () {
            Provider.of<TasksProvider>(context, listen: false).getTasksByDate();
            Navigator.popAndPushNamed(context, Home.routeName);
          },
        );
      }
    } catch (e) {
      if (!await checkInternetConnection(context)) {
        _showWarningDialog(
          context: context,
          message:
              "No internet connection. Please check your connection and try again.",
          onOkPress: () => Navigator.popAndPushNamed(context, SignIn.routeName),
        );
        return;
      }
      _showWarningDialog(
        context: context,
        message:
            "No internet connection. Please check your connection and try again.",
        onOkPress: () => Navigator.popAndPushNamed(context, SignIn.routeName),
      );
    }
  }

  static void _showSuccessDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onOkPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: "Success",
      desc: message,
      btnOkOnPress: onOkPress,
      btnOkColor: AppColors.primaryColor,
    ).show();
  }

  static void _showInfoDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onOkPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: "Info",
      desc: message,
      btnOkOnPress: onOkPress,
      btnOkColor: AppColors.primaryColor,
    ).show();
  }

  static void _showWarningDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onOkPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: "Warning",
      desc: message,
      btnOkOnPress: onOkPress,
      btnOkColor: AppColors.primaryColor,
    ).show();
  }

  static void _showLoadingDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text("Please wait...", style: TextStyle(fontSize: 16)),
        ],
      ),
    ).show();
  }

  static void _showErrorDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onOkPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: "Error",
      desc: message,
      btnOkOnPress: onOkPress,
      btnOkColor: Colors.red,
    ).show();
  }
}
