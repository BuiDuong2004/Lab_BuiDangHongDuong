
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lab91AssetsScreen extends StatefulWidget {
  const Lab91AssetsScreen({super.key});

  @override
  State<Lab91AssetsScreen> createState() => _Lab91AssetsScreenState();
}

class _Lab91AssetsScreenState extends State<Lab91AssetsScreen> {
  // Chứa danh sách dữ liệu đọc được từ file JSON.
  List<Map<String, dynamic>> _items = [];

  // Theo dõi trạng thái tải dữ liệu.
  bool _isLoading = true;

  // Lưu nội dung lỗi nếu đọc file thất bại.
  String? _error;

  @override
  void initState() {
    super.initState();

    // Tự động đọc JSON khi màn hình được mở.
    _loadAssetsJson();
  }

  // KHỐI 1: Đọc file JSON từ assets và chuyển thành List Dart.
  Future<void> _loadAssetsJson() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/items.json',
      );  // Chuyển chuỗi JSON thành danh sách Dart.
      final List<dynamic> decodedData = jsonDecode(jsonString);
      // Chuyển từng phần tử thành Map để dễ truy cập các trường.
      final List<Map<String, dynamic>> loadedItems =
      decodedData.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();
      // Cập nhật giao diện sau khi tải thành công.
      if (!mounted) return;
      setState(() {
        _items = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      // Hiển thị lỗi nếu file không tồn tại hoặc JSON không hợp lệ.
      if (!mounted) return;
      setState(() {
        _error = 'Không thể đọc JSON: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1 - Read Assets JSON'),
      ),

      // KHỐI 2: Hiển thị giao diện theo trạng thái tải dữ liệu.
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadAssetsJson,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      )

      // KHỐI 3: Hiển thị danh sách JSON bằng ListView.builder.
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${item['id']}'),
              ),
              title: Text('${item['name']}'),
              subtitle: Text('Category: ${item['category']}'),
            ),
          );
        },
      ),
    );
  }
}
