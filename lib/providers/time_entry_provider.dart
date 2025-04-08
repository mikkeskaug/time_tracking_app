import 'package:flutter/material.dart';
import '../models/time_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// This file defines a provider for managing time entries in a Flutter application.
class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];
  List<TimeEntry> get entries => _entries;
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveTimeEntry();
    notifyListeners();
  }
  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }

  void _loadTimeEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final entryJsonList = prefs.getStringList('timeentry') ?? [];
    _entries = entryJsonList.map((jsonStr) {
      return TimeEntry.fromJson(Map<String, dynamic>.from(jsonDecode(jsonStr)));
    }).toList();
    notifyListeners();
  }

  void _saveTimeEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final JsonList = _entries.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('entries', _entries.map((p) => jsonEncode(p.toJson())).toList());
  }
}