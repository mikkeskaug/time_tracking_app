import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Project {
  final String name;
  final String id;


  Project({required this.name, required this.id});

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,

  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    name: json['name'], id: '',
  );
}

class ProjectTaskProvider with ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  ProjectTaskProvider() {
    _loadProjects();
  }

  void addProject(String name) {
    _projects.add(Project(name: name, id: ''));
    _saveProjects();
    notifyListeners();
  }

  void removeProject(String projectName) {
    projects.removeWhere((project) => project.name == projectName);
    _saveProjects();
    notifyListeners();
  }

  void _loadProjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final projectJsonList = prefs.getStringList('projects') ?? [];
    _projects = projectJsonList.map((jsonStr) {
      return Project.fromJson(Map<String, dynamic>.from(jsonDecode(jsonStr)));
    }).toList();
    notifyListeners();
  }

  void _saveProjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final projectJsonList = _projects.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('projects', projectJsonList);
  }

  
}