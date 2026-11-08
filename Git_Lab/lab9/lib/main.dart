
import 'package:flutter/material.dart';

import 'screens/lab91_assets_screen.dart';
import 'screens/lab92_storage_screen.dart';
import 'screens/lab93_crud_screen.dart';

void main() {
  // Điểm bắt đầu của ứng dụng Flutter.
  runApp(const Lab9App());
}

class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    // KHỐI 1: Cấu hình giao diện chung của ứng dụng.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9 - JSON Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),

      // KHỐI 2: Màn hình chính chứa 3 tab của bài Lab.
      home: const Lab9HomePage(),
    );
  }
}

class Lab9HomePage extends StatefulWidget {
  const Lab9HomePage({super.key});

  @override
  State<Lab9HomePage> createState() => _Lab9HomePageState();
}

class _Lab9HomePageState extends State<Lab9HomePage> {
  // Lưu vị trí tab đang được chọn.
  int _selectedIndex = 0;

  // Danh sách 3 màn hình tương ứng với 3 bài Lab.
  final List<Widget> _screens = const [
    Lab91AssetsScreen(),
    Lab92StorageScreen(),
    Lab93CrudScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // KHỐI 3: Hiển thị màn hình theo tab hiện tại.
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // KHỐI 4: Thanh điều hướng để chuyển giữa 3 bài Lab.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_open),
            label: 'Lab 9.1',
          ),
          NavigationDestination(
            icon: Icon(Icons.save),
            label: 'Lab 9.2',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage),
            label: 'Lab 9.3',
          ),
        ],
      ),
    );
  }
}
