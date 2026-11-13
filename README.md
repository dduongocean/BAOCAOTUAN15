# BÁO CÁO CHUYÊN ĐỀ DART & FLUTTER
**TRƯỜNG ĐẠI HỌC BÁCH KHOA - ĐẠI HỌC ĐÀ NẴNG**  
**KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO**  

- **Chủ đề 10:** Cơ sở quản lý trạng thái và cập nhật giao diện trong Flutter
- **Giảng viên hướng dẫn:** TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện:**
  1. Phan Vĩnh Sơn
  2. Vũ Duy Dương

---

## 1. Bảng phân công công việc

| Thành viên | Vai trò | Tệp phụ trách trong `lib/` | Nội dung đảm nhiệm |
| :--- | :--- | :--- | :--- |
| **Phan Vĩnh Sơn** | State Lifecycle & UI Rendering | [`lib/demos/state_lifecycle_demo.dart`](lib/demos/state_lifecycle_demo.dart) | - Phân biệt bản chất giữa `StatelessWidget` và `StatefulWidget`.<br>- Khởi tạo và theo dõi các hàm vòng đời State: `initState()`, `build()`, `dispose()`.<br>- Cập nhật giao diện động theo trạng thái thông qua hàm `setState()`. |
| **Vũ Duy Dương** | Local State Limits & Prop Drilling | [`lib/demos/local_state_limit_demo.dart`](lib/demos/local_state_limit_demo.dart) | - Kỹ thuật nâng trạng thái lên Cha (`Lifting State Up`) để chia sẻ dữ liệu.<br>- Minh họa truyền dữ liệu và callback (`onAdd`) qua `ChildDisplay`, `ChildButton` (`Prop Drilling`).<br>- Kiểm chứng hiện tượng rebuild dư thừa trên `UnrelatedChild` khi không dùng `const`. |
| **Cả 2 Thành viên** | System Integration & UI Navigation | [`lib/main.dart`](lib/main.dart) | - Xây dựng giao diện Tab điều hướng bằng `DefaultTabController` và `TabBarView` tại `main.dart`.<br>- Kiểm chuẩn chất lượng mã nguồn bằng `flutter analyze` và `flutter test` (`widget_test.dart`).<br>- Hoàn thiện tài liệu báo cáo và slide thuyết trình. |

---

## 2. Cấu trúc mã nguồn

```text
BAOCAOTUAN15/
├── lib/
│   ├── main.dart                          # Màn hình chính điều hướng 2 Tab
│   └── demos/
│       ├── state_lifecycle_demo.dart      # Demo StatelessWidget, StatefulWidget, vòng đời và setState
│       └── local_state_limit_demo.dart    # Demo giới hạn của quản lý State cục bộ (Prop Drilling)
├── pubspec.yaml                           # Cấu hình dự án Flutter
├── NOI_DUNG_SLIDE.md                      # Tài liệu lý thuyết và kịch bản slide báo cáo
└── README.md                              # Thông tin đề tài và hướng dẫn khởi chạy
```

---

## 3. Hướng dẫn cài đặt và khởi chạy

### Yêu cầu môi trường
- Flutter SDK: phiên bản 3.0 trở lên
- Dart SDK: phiên bản 3.0 trở lên
- Thiết bị: Máy ảo (Android Emulator / iOS Simulator) hoặc thiết bị thật đã bật gỡ lỗi USB.

### Các bước thực hiện
1. Di chuyển vào thư mục dự án:
```bash
cd BAOCAOTUAN15
```

2. Cài đặt các thư viện phụ thuộc:
```bash
flutter pub get
```

3. Kiểm tra thiết bị kết nối:
```bash
flutter devices
```

4. Khởi chạy ứng dụng:
```bash
flutter run
```

---

## 4. Mô tả các module chức năng

- **Module 1 (`state_lifecycle_demo.dart`):** So sánh trực tiếp giữa `StatelessWidget` (hiển thị tĩnh) và `StatefulWidget` (lưu giữ trạng thái qua `State`), đồng thời theo dõi thứ tự gọi các hàm vòng đời (`initState`, `build`, `dispose`) khi kích hoạt `setState()`.
- **Module 2 (`local_state_limit_demo.dart`):** Minh họa giới hạn của việc quản lý trạng thái cục bộ bằng `setState()`: muốn chia sẻ dữ liệu giữa các widget con bắt buộc phải đẩy biến lên widget cha (Lifting State Up / Prop Drilling), đồng thời gây ra hiện tượng gọi lại hàm `build()` dư thừa trên các widget con không liên quan.
