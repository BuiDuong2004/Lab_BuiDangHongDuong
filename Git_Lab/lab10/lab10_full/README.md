# Lab 10 Full – Final Integrated Project

Dự án tích hợp toàn bộ các tính năng từ Lab 10.1 đến Lab 10.5 theo yêu cầu tài liệu Lab 10:
- **Lab 10.1**: Giao diện Đăng nhập & Xác thực dữ liệu biểu mẫu (Form Validation).
- **Lab 10.2**: Đăng nhập bằng REST API thực tế (DummyJSON Auth API).
- **Lab 10.3**: Quản lý phiên làm việc với SharedPreferences, tự động điều hướng SplashScreen (Auto-login) và Đăng xuất (Logout).
- **Lab 10.4**: Đăng nhập bằng Google qua Firebase Authentication (Google Sign-In).
- **Lab 10.5 (LO7)**: Tích hợp Local Notification hiển thị thông báo tức thì khi đăng nhập thành công và đăng xuất.

---

## 1. Các tính năng chính (Minimum Required Features)
1. **SplashScreen Routing & Auto-login**:
   - Tự động kiểm tra phiên làm việc khi mở ứng dụng.
   - Nếu đã đăng nhập (Google Firebase hoặc API DummyJSON qua token), tự động vào `HomeScreen`.
   - Nếu chưa đăng nhập, tự động chuyển vào `LoginScreen`.
2. **Real API Login**:
   - Gửi yêu cầu HTTP POST đến `https://dummyjson.com/auth/login`.
   - Kiểm tra tính hợp lệ của username & password.
   - Xử lý trạng thái tải (Loading indicator) và hiển thị thông báo lỗi chi tiết khi sai thông tin hoặc mất mạng.
3. **Firebase Google Sign-In**:
   - Đăng nhập bảo mật với tài khoản Google qua Firebase Auth.
   - Hiển thị avatar Google, tên tài khoản, email trên màn hình Home.
4. **Auto Login & Logout**:
   - Lưu trữ token và thông tin người dùng trong `SharedPreferences`.
   - Nút đăng xuất xóa toàn bộ dữ liệu phiên, gọi `signOut()` từ Firebase / Google và trở lại màn hình đăng nhập.
5. **Local Notification Integration (MANDATORY – LO7)**:
   - Tự động xin quyền thông báo trên Android 13+ (`POST_NOTIFICATIONS`).
   - Tự động kích hoạt thông báo hệ thống khi đăng nhập thành công (kèm tên người dùng).
   - Tự động kích hoạt thông báo khi đăng xuất tài khoản.
   - Nút gửi thông báo thử nghiệm trực tiếp ngay trên `HomeScreen`.

---

## 2. Hướng dẫn chạy ứng dụng
1. Mở thư mục `lab10_full` trong terminal hoặc công cụ IDE (Android Studio / VS Code):
   ```bash
   cd lab10_full
   flutter pub get
   flutter run
   ```
2. Lưu ý quyền thông báo:
   - Ứng dụng tự động kích hoạt hộp thoại xin quyền thông báo trên Android 13+. Hãy bấm **Allow** (Cho phép) để trải nghiệm tính năng LO7.

---

## 3. Tài khoản thử nghiệm (Test Accounts)
### A. Đăng nhập qua Real REST API (DummyJSON)
- **Username**: `emilys`
- **Password**: `emilyspass`
*(Hoặc các tài khoản khác từ https://dummyjson.com/users như `kminchelle` / `0lelplR`)*

### B. Đăng nhập qua Firebase Google Sign-In
- Sử dụng tài khoản Google cá nhân của bạn thông qua nút **"Đăng nhập bằng Google"**.
