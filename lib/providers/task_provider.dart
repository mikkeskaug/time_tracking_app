import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  final String name;
  final String id;


  Task({required this.name, required this.id});

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,

  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    name: json['name'], id: '',
  );
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  void addTask(String name) {
    _tasks.add(Task(name: name, id: ''));
    _saveTasks();
    notifyListeners();
  }

  void removeTask(String taskName) {
    tasks.removeWhere((Task) => Task.name == taskName);
    _saveTasks();
    notifyListeners();
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tasksJsonList = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJsonList.map((jsonStr) {
      return Task.fromJson(Map<String, dynamic>.from(jsonDecode(jsonStr)));
    }).toList();
    notifyListeners();
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final taskJsonList = _tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('tasks', taskJsonList);
  }

  
}