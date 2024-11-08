import 'package:flutter/material.dart';
import 'package:todo_app/UI/Screens/home.dart';
import 'package:todo_app/UI/Screens/splash.dart';

void main(){
  runApp(const TodoApp());
}
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
routes: {
  Splash.routeName:(context)=>const Splash(),
  Home.routeName:(context)=>const Home(),

},
initialRoute: Splash.routeName,

    );
  }
}