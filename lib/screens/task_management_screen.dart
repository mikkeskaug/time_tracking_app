import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final task = provider.tasks;

          if (task.isEmpty) {
            return Center(child: Text('No Tasks available.'));
          }

          return ListView.builder(
            itemCount: task.length,
            itemBuilder: (context, index) {
              final tasks = task[index];
              return ListTile(
                title: Text(tasks.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.removeTask(tasks.name);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTaskName = '';
              return AlertDialog(
                title: Text('Add New task'),
                content: TextField(
                  decoration: InputDecoration(labelText: 'Task Name'),
                  onChanged: (value) {
                    newTaskName = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (newTaskName.isNotEmpty) {
                        Provider.of<TaskProvider>(context, listen: false)
                            .addTask(newTaskName);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }
}