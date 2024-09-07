import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Field with Validator
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Title'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty'; // Validation message
                  }
                  return null;
                },
              ),
              // Description Field with Validator
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description cannot be empty'; // Validation message
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Due Date: ${_dueDate.toLocal()}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDueDate,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!
                        .save(); // Save only if validation is successful
                    Task newTask = Task(
                      title: _title,
                      description: _description,
                      dueDate: _dueDate,
                    );
                    Provider.of<TaskProvider>(context, listen: false)
                        .addTask(newTask);
                    Navigator.pop(context); // Return to previous screen
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Date Picker
  Future<void> _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }
}
