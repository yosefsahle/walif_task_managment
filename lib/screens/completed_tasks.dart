import 'package:flutter/material.dart';
import '../widgets/task_list.dart';

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: TaskList(showCompleted: true), // Only show completed tasks
    );
  }
}
