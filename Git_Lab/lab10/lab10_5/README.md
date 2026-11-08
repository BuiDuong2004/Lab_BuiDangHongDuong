# Lab 10.5 - Local Notification (MANDATORY – LO7)

Dự án minh họa tích hợp Local Notification trong ứng dụng Flutter nhằm đạt chuẩn đầu ra LO7.

## 1. Tính năng đã thực hiện
- Cấu hình thư viện `flutter_local_notifications: ^22.3.3`.
- Khai báo quyền `POST_NOTIFICATIONS` trên AndroidManifest.xml (bắt buộc cho Android 13+ / API 33+).
- Khởi tạo Notification Channel và cấu hình cho cả Android & iOS/macOS.
- Kiểm tra và yêu cầu cấp quyền hiển thị thông báo động lúc runtime.
- Kích hoạt thông báo tức thì mặc định (Demo Notification).
- Giả lập thông báo khi đăng nhập thành công (`showLoginSuccessNotification`).
- Giả lập thông báo khi đăng xuất (`showLogoutNotification`).
- Gửi thông báo với tiêu đề và nội dung tùy chỉnh.
- Lắng nghe sự kiện người dùng bấm vào thông báo (Notification Payload tap handler).

## 2. Cách chạy ứng dụng
1. Mở thư mục `lab10_5` trong Android Studio / VS Code hoặc dùng terminal:
   ```bash
   cd lab10_5
   flutter pub get
   flutter run
   ```
2. Lưu ý khi chạy trên thiết bị / máy ảo Android:
   - Trên Android 13+ (API 33+), ứng dụng sẽ tự động yêu cầu cấp quyền thông báo khi mở màn hình, hoặc bạn có thể nhấn nút "Yêu cầu cấp quyền (Android 13+)".
   - Bấm nút "Gửi thông báo mặc định" hoặc "Giả lập: Thông báo Đăng nhập thành công" để thấy thông báo xuất hiện trên thanh trạng thái (Status Bar / Notification Shade).

## 3. Tài khoản thử nghiệm
- Dự án Lab 10.5 tập trung vào tính năng Local Notification, không yêu cầu đăng nhập tài khoản thực.
- Có sẵn nút giả lập hành động Đăng nhập thành công và Đăng xuất để kiểm tra thông báo.
