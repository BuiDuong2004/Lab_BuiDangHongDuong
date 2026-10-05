import 'package:flutter/material.dart';

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  final List<Map<String, String>> movieList = const [
    {'title': 'Avatar', 'initial': 'A'},
    {'title': 'Inception', 'initial': 'I'},
    {'title': 'Interstellar', 'initial': 'I'},
    {'title': 'Joker', 'initial': 'J'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 – Layout De...'),
      ),
      body: Column(
        children: [
          // Tiêu đề đầu danh sách
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Now Playing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // ListView hiển thị danh sách phim
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                final movie = movieList[index];
                return Card(
                  elevation: 0,
                  color: const Color(0xFFF2EFF7),
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFDDE1FF),
                      child: Text(
                        movie['initial']!,
                        style: const TextStyle(
                          color: Color(0xFF1B1B2F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    title: Text(
                      movie['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text('Sample description'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}