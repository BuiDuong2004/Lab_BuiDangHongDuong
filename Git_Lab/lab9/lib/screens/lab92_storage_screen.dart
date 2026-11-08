
import 'package:flutter/material.dart';
import '../services/local_json_storage.dart';
class Lab92StorageScreen extends StatefulWidget {
  const Lab92StorageScreen({super.key});
  @override
  State<Lab92StorageScreen> createState() => _Lab92StorageScreenState();
}
class _Lab92StorageScreenState extends State<Lab92StorageScreen> {
  // KHỐI 1: Khai báo service, controller và dữ liệu.
  final LocalJsonStorage _storage = LocalJsonStorage();
  final TextEditingController _controller = TextEditingController();

  // Lab 9.2 lưu dữ liệu vào file riêng tên notes.json.
  final String _fileName = 'notes.json';

  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    // Tự đọc dữ liệu đã lưu khi mở màn hình.
    _loadItems();
  }

  // KHỐI 2: Đọc JSON từ bộ nhớ thiết bị.
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final loadedItems = await _storage.readItems(_fileName);
      if (!mounted) return;
      setState(() {
        _items = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Lỗi đọc dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  // KHỐI 3: Thêm mục mới vào danh sách trong bộ nhớ.
  void _addItem() {
    final text = _controller.text.trim();

    // Không thêm mục nếu người dùng chưa nhập nội dung.
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung.')),
      );
      return;
    }
    setState(() {
      _items.add({
        'id': DateTime.now().microsecondsSinceEpoch,
        'name': text,
      });

      _controller.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã thêm vào danh sách. Nhấn Lưu để lưu dữ liệu.'),
      ),
    );
  }

  // KHỐI 4: Lưu danh sách hiện tại xuống file JSON.
  Future<void> _saveItems() async {
    setState(() {
      _isSaving = true;
    });
    try {
      await _storage.writeItems(_fileName, _items);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu JSON thành công!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Giải phóng controller khi màn hình bị hủy.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Local Storage'),
        actions: [
          // Nút lưu JSON lên thiết bị.
          IconButton(
            onPressed: _isSaving ? null : _saveItems,
            tooltip: 'Lưu dữ liệu',
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      // KHỐI 5: Giao diện nhập nội dung và hiển thị danh sách.
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
              onPressed: _loadItems,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nhập nội dung',
                      hintText: 'Ví dụ: Học Flutter',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  tooltip: 'Thêm mục',
                ),
              ],
            ),
          ),

          // Danh sách dữ liệu đã đọc hoặc vừa thêm.
          Expanded(
            child: _items.isEmpty
                ? const Center(
              child: Text('Chưa có dữ liệu. Hãy thêm mục mới.'),
            )
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];

                return ListTile(
                  leading: const Icon(Icons.notes),
                  title: Text('${item['name']}'),
                  subtitle: Text('ID: ${item['id']}'),
                );
              },
            ),
          ),

          // Nút lưu rõ ràng theo yêu cầu của đề.
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveItems,
                icon: const Icon(Icons.save),
                label: Text(
                  _isSaving ? 'Đang lưu...' : 'Lưu dữ liệu JSON',
                ),
              ),
            ),
          ),
        ],
      ),

      // Nút nổi giúp thêm mục nhanh.
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Thêm mục',
        child: const Icon(Icons.add),
      ),
    );
  }
}
