import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String selectedLanguage="en";
  changeSelectedLanguage(String value){
    selectedLanguage=value;
    notifyListeners();
  }

}