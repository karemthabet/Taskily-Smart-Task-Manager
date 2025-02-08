import 'package:flutter/foundation.dart';
import 'package:todo_app/cashe/cash_data.dart';

class LanguageProvider extends ChangeNotifier {
String _selectedLanguage;
LanguageProvider({required String initialLanguage}):_selectedLanguage=initialLanguage;
  String get selectedLanguage => _selectedLanguage;


Future<void>   setSelectedLanguage(String language)async{
  if(_selectedLanguage!=language){
    _selectedLanguage=language;
   await CashData.setData(key: "lang", value: language);
    notifyListeners();
  }
}




}