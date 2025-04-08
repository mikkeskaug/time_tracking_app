import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';
import '../providers/task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String projectId = '';
  String taskId = '';
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
            DropdownButtonFormField<String>(
                value: Provider.of<ProjectTaskProvider>(context).projects.any((p) => p.name == projectId) ? projectId : null,
                onChanged: (String? newValue) {
                setState(() {
                    projectId = newValue!;
                });
                },
                decoration: InputDecoration(labelText: 'Project'),
                items: Provider.of<ProjectTaskProvider>(context)
                    .projects
                    .map<DropdownMenuItem<String>>((project) {
                return DropdownMenuItem<String>(
                    value: project.name,
                    child: Text(project.name),
                );
                }).toList(),
            ),
            DropdownButtonFormField<String>(
                value: Provider.of<TaskProvider>(context).tasks.any((t) => t.name == taskId) ? taskId : null,
                onChanged: (String? newValue) {
                setState(() {
                    taskId = newValue!;
                });
                },
                decoration: InputDecoration(labelText: 'Task'),
                items: Provider.of<TaskProvider>(context)
                    .tasks
                    .map<DropdownMenuItem<String>>((task) {
                return DropdownMenuItem<String>(
                    value: task.name,
                    child: Text(task.name),
                );
                }).toList(),
            ),
            ListTile(
              title: Text("Date: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDate,

            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                }
                if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                }
                return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                }
                return null;
                },
                onSaved: (value) => notes = value!,
            ),
            ElevatedButton(
                onPressed: () {
                if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<TimeEntryProvider>(context, listen: false)
                        .addTimeEntry(TimeEntry(
                        id: DateTime.now().toString(), // Simple ID generation
                        projectId: projectId,
                        taskId: taskId,
                        totalTime: totalTime,
                        date: date,
                        notes: notes,
                        ));
                    Navigator.pop(context);
                }
                },
                child: Text('Save'),
            )
            ],
        ),
        ),
    );
  }
}