
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalJsonStorage {
  // KHỐI 1: Đọc JSON.
  // Web: đọc JSON từ bộ nhớ trình duyệt.
  // Android/Desktop: đọc JSON từ file trong thư mục documents.
  Future<List<Map<String, dynamic>>> readItems(
      String fileName,
      ) async {
    String? jsonString;

    if (kIsWeb) {
      // Trên Chrome, không gọi path_provider.
      final prefs = await SharedPreferences.getInstance();
      jsonString = prefs.getString(fileName);
    } else {
      // Trên nền tảng có hỗ trợ dart:io, đọc file JSON.
      final file = await _getFile(fileName);

      if (!await file.exists()) {
        return [];
      }

      jsonString = await file.readAsString();
    }

    // File chưa có dữ liệu hoặc chuỗi rỗng.
    if (jsonString == null || jsonString.trim().isEmpty) {
      return [];
    }

    // Chuyển chuỗi JSON thành danh sách Dart.
    final decodedData = jsonDecode(jsonString);

    if (decodedData is! List) {
      throw const FormatException(
        'Dữ liệu JSON phải là một danh sách.',
      );
    }

    return decodedData.map((item) {
      return Map<String, dynamic>.from(item as Map);
    }).toList();
  }

  // KHỐI 2: Ghi JSON.
  // Web: lưu chuỗi JSON vào bộ nhớ trình duyệt.
  // Android/Desktop: ghi chuỗi JSON xuống file.
  Future<void> writeItems(
      String fileName,
      List<Map<String, dynamic>> items,
      ) async {
    // Chuyển danh sách Dart thành chuỗi JSON có định dạng dễ đọc.
    final jsonString = const JsonEncoder.withIndent('  ').convert(items);

    if (kIsWeb) {
      // Lưu JSON vào trình duyệt theo tên file làm khóa.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(fileName, jsonString);
    } else {
      // Ghi JSON xuống file trên nền tảng có hỗ trợ file.
      final file = await _getFile(fileName);
      await file.writeAsString(jsonString, flush: true);
    }
  }

  // KHỐI 3: Lấy đường dẫn file trên nền tảng không phải Web.
  Future<File> _getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }
}
