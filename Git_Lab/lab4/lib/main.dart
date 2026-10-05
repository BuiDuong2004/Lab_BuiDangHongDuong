import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_basics_demo.dart';
import 'app_structure_demo.dart';
import 'debug_fixes_demo.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundament...'),
        backgroundColor: const Color(0xFFA8B6FF).withOpacity(0.1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuItem(
            context,
            title: 'Exercise 1 – Core Widgets Demo',
            targetScreen: const CoreWidgetsDemo(),
          ),
          _buildMenuItem(
            context,
            title: 'Exercise 2 – Input Controls Demo',
            targetScreen: const InputControlsDemo(),
          ),
          _buildMenuItem(
            context,
            title: 'Exercise 3 – Layout Demo',
            targetScreen: const LayoutBasicsDemo(),
          ),
          _buildMenuItem(
            context,
            title: 'Exercise 4 – App Structure & Theme',
            targetScreen: const AppStructureDemo(),
          ),
          _buildMenuItem(
            context,
            title: 'Exercise 5 – Common UI Fixes',
            targetScreen: const DebugFixesDemo(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String title, required Widget targetScreen}) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF2EFF7),
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }
}