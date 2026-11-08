
import 'package:flutter/material.dart';
import '../services/local_json_storage.dart';

class Lab93CrudScreen extends StatefulWidget {
  const Lab93CrudScreen({super.key});

  @override
  State<Lab93CrudScreen> createState() => _Lab93CrudScreenState();
}

class _Lab93CrudScreenState extends State<Lab93CrudScreen> {
  // KHỐI 1: Khai báo dữ liệu, controller và trạng thái.
  final LocalJsonStorage _storage = LocalJsonStorage();
  final TextEditingController _searchController = TextEditingController();

  // Dùng file riêng để dữ liệu Lab 9.3 không lẫn với Lab 9.2.
  final String _fileName = 'contacts.json';

  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  // Giá trị tìm kiếm hiện tại.
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Đọc dữ liệu đã lưu khi vào màn hình.
    _loadItems();
  }

// KHỐI 2: Tải dữ liệu JSON đã lưu từ bộ nhớ cục bộ.
//
// Nếu chưa có dữ liệu, LocalJsonStorage trả về [].
// Không gọi API và không cần file JSON mẫu tạo sẵn.

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
      _error = 'Không thể đọc dữ liệu: $e';
      _isLoading = false;
    });
  }
}

  // KHỐI 3: Hàm lưu tự động được gọi sau thao tác CRUD.
  Future<void> _autoSave() async {
    if (mounted) {
      setState(() {
        _isSaving = true;
      });
    }

    try {
      await _storage.writeItems(_fileName, _items);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lưu dữ liệu thất bại: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // KHỐI 4: Hiển thị hộp thoại nhập tên khi thêm hoặc sửa.
  Future<void> _showItemDialog({Map<String, dynamic>? item}) async {
    final TextEditingController nameController = TextEditingController(
      text: item == null ? '' : '${item['name'] ?? ''}',
    );

    // Nếu có item nghĩa là đang sửa; nếu không thì đang thêm mới.
    final bool isEditing = item != null;

    final String? name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa mục' : 'Thêm mục mới'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Tên',
              hintText: 'Nhập tên',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              final value = nameController.text.trim();

              if (value.isNotEmpty) {
                Navigator.pop(dialogContext, value);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = nameController.text.trim();

                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );

    // Giải phóng controller của hộp thoại.
    nameController.dispose();

    // Người dùng bấm Hủy hoặc không nhập tên thì không thay đổi dữ liệu.
    if (name == null || name.isEmpty || !mounted) return;

    if (isEditing) {
      // UPDATE: cập nhật tên của mục có ID tương ứng.
      setState(() {
        final index = _items.indexWhere(
              (element) => element['id'] == item['id'],
        );

        if (index != -1) {
          _items[index]['name'] = name;
        }
      });
    } else {
      // CREATE: thêm mục mới với ID duy nhất theo thời điểm tạo.
      setState(() {
        _items.add({
          'id': DateTime.now().microsecondsSinceEpoch,
          'name': name,
        });
      });
    }

    // Tự lưu sau khi thêm hoặc sửa.
    await _autoSave();
  }

  // KHỐI 5: Xác nhận rồi xóa mục và tự lưu.
  Future<void> _deleteItem(Map<String, dynamic> item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có muốn xóa "${item['name']}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _items.removeWhere(
            (element) => element['id'] == item['id'],
      );
    });

    // Tự lưu sau khi xóa.
    await _autoSave();
  }

  // KHỐI 6: Lọc danh sách theo tên dựa trên nội dung tìm kiếm.
  List<Map<String, dynamic>> get _filteredItems {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _items;
    }

    return _items.where((item) {
      final name = '${item['name'] ?? ''}'.toLowerCase();
      return name.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 - JSON CRUD'),
        actions: [
          // Hiển thị trạng thái lưu hiện tại.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(_isSaving ? 'Đang lưu...' : 'Đã sẵn sàng'),
            ),
          ),
        ],
      ),

      // KHỐI 7: Xử lý loading, error và nội dung chính.
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
          // Ô tìm kiếm cập nhật danh sách khi người dùng nhập.
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm theo tên',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: 'Xóa tìm kiếm',
                ),
              ),
            ),
          ),

          // Hiển thị số lượng kết quả tìm được.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tìm thấy ${_filteredItems.length} mục',
              ),
            ),
          ),

          // Danh sách kết quả sau khi lọc.
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
              child: Text('Không có dữ liệu phù hợp.'),
            )
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text('${item['name']}'),
                    subtitle: Text('ID: ${item['id']}'),

                    // Nút sửa mục đang chọn.
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showItemDialog(item: item);
                          },
                          icon: const Icon(Icons.edit),
                          tooltip: 'Sửa',
                        ),

                        // Nút xóa có hộp thoại xác nhận.
                        IconButton(
                          onPressed: () {
                            _deleteItem(item);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          tooltip: 'Xóa',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Nút thêm mục mới.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        tooltip: 'Thêm mục',
        child: const Icon(Icons.add),
      ),
    );
  }
}
