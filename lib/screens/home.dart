import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:walif_task_managment_app/providers/settings_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _quote = 'Fetching quote...';

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    print('this is started');
    final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
    print(response.body);
    if (response.statusCode == 200) {
      final List quotes = json.decode(response.body);
      print(response.body);
      setState(() {
        _quote = quotes[0]['text']; // Display the first quote
      });
    } else {
      print('error');
      throw Exception('Failed to load quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Walif Task'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                return SwitchListTile(
                  title: Text('Enable Dark Mode'),
                  value: settingsProvider.isDarkMode,
                  onChanged: (value) {
                    settingsProvider.toggleDarkMode();
                  },
                );
              },
            ),
            ListTile(
              title: Text('Completed Tasks'),
              onTap: () {
                Navigator.pushNamed(context, '/completedTasks');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_quote),
          ),
          Center(
            child: Container(
              width: screensize.width * 0.98,
              height: screensize.height * 0.8,
              child: Expanded(child: TaskList(showCompleted: false)),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTask');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
