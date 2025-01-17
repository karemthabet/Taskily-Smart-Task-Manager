import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Widgets/card_item.dart';
import 'package:todo_app/provider/tasks_provider.dart';

class ListTab extends StatefulWidget {
  const ListTab({super.key});

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  EasyInfiniteDateTimelineController? controller =
      EasyInfiniteDateTimelineController();
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 9, right: 9),
          child: EasyInfiniteDateTimeLine(
            showTimelineHeader: false,
            // selectionMode: const SelectionMode.autoCenter(),
            onDateChange: (newDate) {
              tasksProvider.changeSelectedDate(newDate);
            },

            controller: controller,
            firstDate: DateTime(2025),
            focusDate: tasksProvider.selectedDate,
            lastDate: DateTime(2040),
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
            itemCount: tasksProvider.taskModels.length,
            itemBuilder: (context, index) {
              return CardItem(task: tasksProvider.taskModels[index]);
            },
          ),
        ),
      ],
    );
  }
}
