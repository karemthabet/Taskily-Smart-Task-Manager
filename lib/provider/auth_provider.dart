import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/user_data_model.dart';
import 'package:todo_app/remot/firebase_services.dart';

class LocalAuthProvider with ChangeNotifier {
  UserDataModel? userDataModel;

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      await FirebaseServices.signIn(
        context: context,
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      print("Error during sign-in: $e");
    }
  }

  Future<void> register(String email, String password, BuildContext context, String name) async {
    try {
      userDataModel = UserDataModel(
        email: email,
        name: name,
      ); // ✅ إنشاء كائن `UserDataModel`

      await FirebaseServices.register(
        context: context,
        userDataModel: userDataModel!, // ✅ تمرير الكائن الصحيح
        password: password,
      );

      notifyListeners();
    } catch (e) {
      print("Error during registration: $e");
    }
  }
}
