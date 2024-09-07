import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../main.dart'; // Import flutterLocalNotificationsPlugin from main.dart

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasksFromStorage();
  }

  // Get uncompleted tasks
  List<Task> get uncompletedTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  // Get completed tasks
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  void addTask(Task task) {
    _tasks.add(task);
    saveTasksToStorage();
    notifyListeners();
    scheduleTaskNotification(
        task); // Schedule a notification when task is added
  }

  void editTask(int index, Task updatedTask) {
    _tasks[index] = updatedTask;
    saveTasksToStorage();
    notifyListeners();
    flutterLocalNotificationsPlugin.cancel(updatedTask.hashCode);
    scheduleTaskNotification(updatedTask);
  }

  void deleteTask(int index) {
    flutterLocalNotificationsPlugin.cancel(_tasks[index].hashCode);
    _tasks.removeAt(index);
    saveTasksToStorage();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    saveTasksToStorage();
    notifyListeners(); // This will refresh the task list when the state changes
    if (_tasks[index].isCompleted) {
      showCompletionNotification(
          _tasks[index]); // Show notification when task is completed
    }
  }

  void saveTasksToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksJson =
        _tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('tasks', tasksJson);
  }

  void loadTasksFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList('tasks');
    if (tasksJson != null) {
      _tasks =
          tasksJson.map((task) => Task.fromJson(jsonDecode(task))).toList();
    }
    notifyListeners();
  }

  Future<void> scheduleTaskNotification(Task task) async {
    var androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Tasks',
      importance: Importance.high,
      priority: Priority.high,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    var scheduledNotificationDateTime =
        task.dueDate.subtract(Duration(hours: 1));

    await flutterLocalNotificationsPlugin.schedule(
      task.hashCode,
      'Task Reminder',
      '${task.title} is due soon!',
      scheduledNotificationDateTime,
      generalNotificationDetails,
    );
  }

  Future<void> showCompletionNotification(Task task) async {
    var androidDetails = AndroidNotificationDetails(
      'completed_task_channel',
      'Completed Tasks',
      importance: Importance.high,
      priority: Priority.high,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      task.hashCode,
      'Task Completed',
      'Great job! You completed "${task.title}".',
      generalNotificationDetails,
    );
  }
}
