import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Widgets/card_item.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/provider/tasks_provider.dart';

class ListTab extends StatefulWidget {
  const ListTab({super.key});

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  EasyInfiniteDateTimelineController? controller =
      EasyInfiniteDateTimelineController();
late Stream<List<TaskModel>> _tasksFuture;

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      _tasksFuture = context.read<TasksProvider>().getTasksByDate();
    });
  });
}

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = context.watch<TasksProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 9, right: 9),
          child: EasyInfiniteDateTimeLine(
            key: ValueKey(tasksProvider.selectedDate),
            showTimelineHeader: false,
            onDateChange: (newDate) {
              tasksProvider.changeSelectedDate(newDate);
              setState(() {
                _tasksFuture = tasksProvider.getTasksByDate();
              });
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
       StreamBuilder<List<TaskModel>>(
  stream: _tasksFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (snapshot.hasError) {
      return Expanded(
          child: Center(child: Text("Error: ${snapshot.error}")));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Expanded(
        child: Center(
          child:  Text(
              "No Tasks Today",style: TextStyle(color: AppColors.primaryColor),),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return CardItem(task: snapshot.data![index]);
          },
        ),
      );
    }
  },
)
      ],
    );
  }
}
