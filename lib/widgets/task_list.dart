import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../screens/edit_task.dart';

class TaskList extends StatelessWidget {
  final bool showCompleted;

  TaskList({required this.showCompleted});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = showCompleted
            ? taskProvider.completedTasks
            : taskProvider.uncompletedTasks;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.amber),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTaskScreen(
                                  task: task,
                                  index: index,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<TaskProvider>(context, listen: false)
                                .deleteTask(index);
                          },
                        ),
                      ],
                    ),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        Provider.of<TaskProvider>(context, listen: false)
                            .toggleTaskCompletion(index);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            );
          },
        );
      },
    );
  }
}
