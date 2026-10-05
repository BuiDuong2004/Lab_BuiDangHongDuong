import 'package:flutter/material.dart';

class DebugFixesDemo extends StatefulWidget {
  const DebugFixesDemo({super.key});

  @override
  State<DebugFixesDemo> createState() => _DebugFixesDemoState();
}

class _DebugFixesDemoState extends State<DebugFixesDemo> {
  final List<String> movies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common U...'),
      ),
      // Đã sửa Lỗi 2: Sử dụng SingleChildScrollView cho các khung nhìn có nguy cơ đè/tràn màn hình
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Đã sửa Lỗi 1: Bọc ListView bên trong Expanded khi đặt trong Column
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.movie_creation,
                      size: 32,
                      color: Color(0xFF4A4B57),
                    ),
                    title: Text(
                      movies[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}