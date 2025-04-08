import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/providers/task_provider.dart';
import 'providers/time_entry_provider.dart'; // Make sure this is correct
import 'providers/project_task_provider.dart'; // Make sure this is correct
import 'screens/project_task_managament_screen.dart'; // Make sure this is correct
import 'screens/home_screen.dart';
import 'screens/task_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider()),
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
      routes: {
        '/project-settings': (context) => ProjectTaskManagementScreen(),
        '/task-management': (context) => TaskManagementScreen(),
      },
    );
  }
}
