import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 – Core Widge...'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Headline Text
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // 2. Material Icon (Biểu tượng clapperboard/movie)
            const Center(
              child: Icon(
                Icons.movie_creation,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),

            // 3. Image.network (Ảnh đường cao tốc/nút giao thông)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/id/1018/600/300',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Text('Không tải được ảnh')),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Card chứa ListTile
            Card(
              elevation: 0,
              color: const Color(0xFFF2EFF7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.star,
                    size: 32,
                    color: Color(0xFF4A4B57),
                  ),
                  title: Text(
                    'Movie Item',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    'This is a sample ListTile inside a Card.',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}