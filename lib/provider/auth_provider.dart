import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/user_data_model.dart';

import 'package:todo_app/remot/firebase_services.dart';

class LocalAuthProvider with ChangeNotifier {
  UserDataModel? userDataModel;



  Future signIn(String email, String password, context) async {
 userDataModel=   await FirebaseServices.signIn(
        UserDataModel(email: email), password, context);
        notifyListeners();
  }

 Future register(String email, String password, context, String name)async{
 userDataModel=  await FirebaseServices.register(
        UserDataModel(email: email, name: name), password, context);
        notifyListeners();
  }
}
