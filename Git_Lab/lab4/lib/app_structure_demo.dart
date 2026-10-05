import 'package:flutter/material.dart';

class AppStructureDemo extends StatefulWidget {
  const AppStructureDemo({super.key});

  @override
  State<AppStructureDemo> createState() => _AppStructureDemoState();
}

class _AppStructureDemoState extends State<AppStructureDemo> {
  // Trạng thái Dark Mode
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Cấu hình Theme sáng/tối
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFBF8FF),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise 4 – App Str...'),
          actions: [
            // Switch toggling Dark Mode trên AppBar
            Row(
              children: [
                const Text('Dark'),
                Switch(
                  value: _isDarkMode,
                  onChanged: (val) {
                    setState(() {
                      _isDarkMode = val;
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],
            )
          ],
        ),
        body: const Center(
          child: Text(
            'This is a simple screen with theme toggle.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isDarkMode = !_isDarkMode;
            });
          },
          child: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
        ),
      ),
    );
  }
}