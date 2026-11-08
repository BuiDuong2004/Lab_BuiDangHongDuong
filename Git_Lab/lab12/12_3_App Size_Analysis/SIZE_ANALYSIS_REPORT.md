# Báo Cáo Phân Tích Kích Thước Ứng Dụng (Exercise 12.3 — App Size Analysis)

## 1. Giới thiệu & Lệnh Thực Thi
Để phân tích kích thước và các thành phần chiếm dung lượng trong gói cài đặt ứng dụng Taskly, nhóm đã tiến hành phân tích chuyên sâu với lệnh:
```bash
flutter build apk --analyze-size --target-platform android-arm64
```
Lệnh trên thực hiện build APK ở chế độ Release, kích hoạt Tree-Shaking, và trích xuất cấu trúc nhị phân của APK thành file phân tích chi tiết `apk-code-size-analysis.json`.

---

## 2. Kết Quả Kích Thước Tổng Thể (Summary Metrics)
| Thông số | Giá trị | Ghi chú |
| :--- | :--- | :--- |
| **Tên tệp APK** | `app-release.apk` | Build cho kiến trúc `android-arm64` |
| **Tổng dung lượng nén (Total Compressed Size)** | **16.4 MB** | Kích thước người dùng tải về |
| **Dung lượng giải nén (Uncompressed Size)** | **~38.2 MB** | Dung lượng chiếm trên thiết bị sau khi cài đặt |
| **Material Icons Tree-Shaking** | **1,645,184 B → 2,772 B** | **Giảm 99.8%** (chỉ giữ lại các glyph icon được dùng) |
| **Asset Logo Tối Ưu** | **5,292 B (~5.2 KB)** | Giảm 99.75% so với file thiết kế gốc (2.1 MB) |

---

## 3. Top 3 Thành Phần Chiếm Nhiều Không Gian Nhất (Top 3 Space Consumers)

```
app-release.apk (Total: 16.4 MB)
├── 1. lib/arm64-v8a/ (16.0 MB - ~96.5%)  <-- Top 1: Thư viện Native C++ & Dart AOT
│   ├── libflutter.so (Flutter Engine: Skia/Impeller, Dart VM)
│   └── libapp.so (Dart AOT Compiled Machine Code)
│       ├── package:flutter (3.0 MB - 60% Dart code)
│       ├── Dart Core & UI runtimes (920 KB)
│       ├── Dependencies (material_color_utilities, provider): ~100 KB
│       └── Application Logic (package:taskly / clone): 26 KB
├── 2. classes.dex (232 KB - ~1.4%)      <-- Top 2: Bytecode Java/Kotlin Android Embedding
└── 3. assets/flutter_assets/ (223 KB - ~1.3%) <-- Top 3: Tài nguyên ứng dụng & Font
    ├── Font MaterialIcons (2.7 KB đã tree-shaken)
    ├── task_logo_optimized.png (5.2 KB)
    └── Kernel snapshot & asset manifest
```

### Chi tiết phân tích:
1. **Top 1 — Thư viện Native C/C++ (`lib/arm64-v8a` ~ 16 MB, chiếm 96.5%):**
   - Bao gồm `libflutter.so` (Flutter C++ engine, xử lý đồ họa Impeller/Skia, text layout, event loop). Đây là thành phần cố định của mọi ứng dụng Flutter để đảm bảo khả năng chạy độc lập không phụ thuộc vào hệ điều hành.
   - Kèm theo `libapp.so` chứa mã máy AOT (Ahead-of-Time) của toàn bộ Flutter Framework (`package:flutter` chiếm 3 MB) và mã nguồn logic ứng dụng (chỉ chiếm 26 KB).
2. **Top 2 — Compiled Dalvik Executable (`classes.dex` ~ 232 KB, chiếm 1.4%):**
   - Chứa mã nguồn biên dịch của Android Activity (`FlutterActivity`), Android Embedding V2, và các adapter giao tiếp giữa hệ điều hành Android và Flutter Engine.
3. **Top 3 — Assets & Flutter Assets (`assets/flutter_assets` ~ 223 KB, chiếm 1.3%):**
   - Chứa phông chữ `MaterialIcons-Regular.otf` đã được tối ưu hóa (tree-shaken từ 1.64 MB xuống 2.7 KB).
   - Tệp biểu tượng đã resize `task_logo_optimized.png` (5.2 KB).
   - Cấu trúc font metadata và AssetManifest.

---

## 4. Danh Sách Đề Xuất Tối Ưu Hóa (Optimization Suggestions)

Dựa trên kết quả phân tích, dưới đây là các đề xuất tối ưu hóa kích thước có thể áp dụng ngay:

1. **Sử dụng Android App Bundle (`.aab`) cho Production Deployment:**
   - Thay vì phân phối APK phổ thông, biên dịch bằng lệnh:
     ```bash
     flutter build appbundle --release
     ```
   - Google Play sẽ sử dụng Dynamic Delivery để chỉ tải xuống mã native và tài nguyên dành riêng cho thiết bị của người dùng, giúp giảm kích thước tải xuống tới **50-60%** (chỉ còn khoảng ~7 - 9 MB).
2. **Áp dụng Chia nhỏ APK theo kiến trúc CPU (`--split-per-abi`):**
   - Nếu phân phối tệp APK trực tiếp (sideloading hoặc web hosting), chạy lệnh:
     ```bash
     flutter build apk --split-per-abi --release
     ```
   - Tách thành 3 file APK riêng biệt: `armeabi-v7a` (32-bit), `arm64-v8a` (64-bit), và `x86_64`. Người dùng không cần phải tải cả 3 thư viện native cùng một lúc.
3. **Kích hoạt R8 ProGuard Code Shrinking & Resource Shrinking trong Android:**
   - Trong `android/app/build.gradle.kts`:
     ```kotlin
     buildTypes {
         release {
             isMinifyEnabled = true
             isShrinkResources = true
             proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
         }
     }
     ```
   - Giúp xóa bỏ các class Java/Kotlin không dùng trong `classes.dex`, giảm thêm khoảng 40-70 KB.
4. **Loại bỏ triệt để tài nguyên và thư viện dư thừa:**
   - Đã loại bỏ file ảnh gốc chưa nén `task_logo_unoptimized.png` (tiết kiệm ngay 2.1 MB).
   - Kiểm tra `pubspec.yaml` để loại bỏ các dependency không còn sử dụng.
5. **Duy trì Icon Font Tree-Shaking:**
   - Luôn bật cờ `--tree-shake-icons` (mặc định trong Flutter Release build), giúp giảm 99.8% kích thước font icon.
