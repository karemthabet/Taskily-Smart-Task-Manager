import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Widgets/buttom_sheet_form.dart';
import 'package:todo_app/UI/Widgets/scaffold_custom.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/tabs/list_tabs/list_tab.dart';
import 'package:todo_app/tabs/settings_tabs/settings_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String routeName = "home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> tabs = [const ListTab(), const SettingsTab()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


    return Directionality(
      textDirection: TextDirection.ltr,
      child: ScaffoldCustom(
        body: tabs[selectedIndex],
        appBar: AppBar(
         automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 25, top: 20),
            child: Text(
              selectedIndex == 0 ? "To Do App" : "", 
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        floatingActionButton: selectedIndex == 0
    ? FloatingActionButton(
        child: const Icon(Icons.add, size: 30),
        onPressed: () {
          final provider = Provider.of<TasksProvider>(context, listen: false);
          final selectedDate = provider.selectedDate;
          final today = DateTime.now();
          if (selectedDate.isBefore(DateTime(today.year, today.month, today.day))) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 400),
                content: Text('You Cannot Add new Tasks before Today',style: TextStyle(color: Colors.black,fontSize: 20),),
              ),
            );
            return;
          }
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) {
              return const ButtomSheetForm();
            },
          );
        },
      )
    : null,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 11,
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            onTap: (value) {
              selectedIndex = value;
              setState(() {});
            },
            currentIndex: selectedIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "list tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "settings tasks"),
            ],
          ),
        ),
      ),
    );
  }
}
