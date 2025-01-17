import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Widgets/card_item.dart';
import 'package:todo_app/remot/firebase_services.dart';

class ListTab extends StatefulWidget {
  const ListTab({super.key});

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  List<TaskModel> tasks = [];
  EasyInfiniteDateTimelineController? controller =
      EasyInfiniteDateTimelineController();
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      getTasks();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 9, right: 9),
          child: EasyInfiniteDateTimeLine(
            showTimelineHeader: false,
            // selectionMode: const SelectionMode.autoCenter(),
            onDateChange: (newDate) {
              selectedDate = newDate;
              setState(() {});
            },

            controller: controller,
            firstDate: DateTime(2024),
            focusDate: selectedDate,
            lastDate: DateTime(2025),
            dayProps: EasyDayProps(
              todayStyle: DayStyle(
                dayStrStyle: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onError,
                ),
                monthStrStyle: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onError,
                ),
                dayNumStyle: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onError,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 4),
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              activeDayStyle: DayStyle(
                dayStrStyle: const TextStyle(fontSize: 15, color: Colors.black),
                monthStrStyle:
                    const TextStyle(fontSize: 15, color: Colors.black),
                dayNumStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 192, 246, 68),
                    borderRadius: BorderRadius.circular(20)),
              ),
              //

              inactiveDayStyle: DayStyle(
                dayStrStyle: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onError,
                ),
                monthStrStyle: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onError,
                ),
                dayNumStyle: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onError,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return CardItem(task: tasks[index]);
            },
          ),
        ),
      ],
    );
  }

  getTasks() async {
    List<TaskModel> allTasks = await FirebaseServices.getTasks();
    tasks = allTasks;
    setState(() {});
  }
}
