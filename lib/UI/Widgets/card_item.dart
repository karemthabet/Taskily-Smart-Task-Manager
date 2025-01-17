import 'package:flutter/material.dart';
import 'package:todo_app/UI/Models/task_model.dart';
import 'package:todo_app/UI/Screens/edit_screen.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/remot/firebase_services.dart';
class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.task});
  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 8),
            Text("Delete", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      secondaryBackground:Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Edit", style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.edit, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Confirm Delete",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              content: Text(
                "Are you sure you want to delete this task?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); //No Deleted this item
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    FirebaseServices.deleteTask(task.id);
                    Navigator.of(context).pop(true); //Delete this Item
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
          );
        } 
        else
         {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return EditScreen(
                task: task,
              );
            },
          ));
          return false;
        }
      },direction:task.isDone?  DismissDirection.startToEnd :DismissDirection.horizontal,
      child: Card(
        color: Theme.of(context).colorScheme.onPrimary,
        margin: const EdgeInsets.only(right: 15, left: 15, top: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: ListTile(
            leading: VerticalDivider(
              thickness: 4,
              endIndent: 2,
              indent: 2,
              color:
                  task.isDone ? AppColors.greenColor : AppColors.primaryColor,
            ),
            title: Text(
              task.taskName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: task.isDone
                        ? AppColors.greenColor
                        : AppColors.primaryColor,
                  ),
            ),
            subtitle: Text(
              task.taskDetails,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: task.isDone
                ? Text("Done!",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.greenColor,
                        ))
                : GestureDetector(
                    onTap: () {
                      FirebaseServices.updateTask(task.id, {
                        "isDone": true,
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      child: const Icon(
                        Icons.check,
                        size: 30,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
