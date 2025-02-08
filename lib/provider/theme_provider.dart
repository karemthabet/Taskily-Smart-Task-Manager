import 'package:flutter/material.dart';
import 'package:todo_app/cashe/cash_data.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode appTheme;
  ThemeProvider({required ThemeMode initialAppTheme}):appTheme=initialAppTheme;
    ThemeMode get myAppTheme => appTheme;
    setAppTheme(ThemeMode newAppTheme){
      if(appTheme!=newAppTheme){
        appTheme=newAppTheme;
        CashData.setData(key: "theme", value:appTheme==ThemeMode.dark?"dark":"light" );
        notifyListeners();
      }


    }
 



}