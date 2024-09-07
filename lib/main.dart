import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'providers/task_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home.dart';
import 'screens/add_task.dart';
import 'screens/completed_tasks.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  var initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher'); // Change this to a valid icon
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task Management App',
          theme: settingsProvider.isDarkMode
              ? ThemeData.dark()
              : ThemeData.light(),
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(),
            '/addTask': (context) => AddTaskScreen(),
            '/completedTasks': (context) => CompletedTasksScreen(),
          },
        );
      },
    );
  }
}
