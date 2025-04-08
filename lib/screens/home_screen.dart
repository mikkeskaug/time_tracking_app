import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Projects'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/project-settings');
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Tasks'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/task-management');
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Time Tracking'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'Grouped by Projects'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Consumer<TimeEntryProvider>(
                builder: (context, provider, child) {
                  if (provider.entries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No time entries yet!',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first entry.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: provider.entries.length,
                        itemBuilder: (context, index) {
                          final entry = provider.entries[index];
                          final notes = entry.notes;
                          return Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              title: Text('${entry.projectId} - ${entry.totalTime} hours'),
                              subtitle: Text(
                                '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')} - Notes: $notes',
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  Provider.of<TimeEntryProvider>(context, listen: false).deleteTimeEntry(entry.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              Consumer<TimeEntryProvider>(
                builder: (context, provider, child) {
                  final grouped = <String, List<TimeEntry>>{};
                  for (var entry in provider.entries) {
                    grouped.putIfAbsent(entry.projectId, () => []).add(entry);
                  }

                  if (grouped.isEmpty) {
                    return Center(
                      child: Text(
                        'No entries to group.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: ListView(
                        children: grouped.entries.map((group) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.key,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                ...group.value.map((entry) {
                                  final totalTime = entry.totalTime.toString();
                                  final date = entry.date;
                                  final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                  final notes = entry.notes;
                                  return Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text('$totalTime hours'),
                                      subtitle: Text('$formattedDate - Notes: $notes'),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          tooltip: 'Add Entry',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}