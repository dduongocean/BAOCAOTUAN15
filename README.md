# BÁO CÁO CHUYÊN ĐỀ DART & FLUTTER
**TRƯỜNG ĐẠI HỌC BÁCH KHOA - ĐẠI HỌC ĐÀ NẴNG**  
**KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO**  

- **Chủ đề 10:** Cơ sở quản lý trạng thái và cập nhật giao diện trong Flutter
- **Giảng viên hướng dẫn:** TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện:**
  1. Phan Vĩnh Sơn - Nhóm trưởng
  2. Vũ Duy Dương - Thành viên

---

## 1. Bảng phân công công việc (WBS)

| STT | Nhiệm vụ (WBS) | Vai trò | Người phụ trách | Sản phẩm bàn giao |
| :---: | :--- | :--- | :---: | :--- |
| 1 | UI Design | Thiết kế giao diện demo, bố cục slide | Phan Vĩnh Sơn | Giao diện 2 màn hình demo, Slide báo cáo |
| 2 | Business Logic | Xây dựng logic đếm số, tương tác người dùng | Phan Vĩnh Sơn | lib/demos/state_lifecycle_demo.dart |
| 3 | State Management | Phân tích vòng đời State, giới hạn setState | Vũ Duy Dương | lib/demos/local_state_limit_demo.dart |
| 4 | Database / Local Data | Quản lý trạng thái bộ nhớ cục bộ trong State | Vũ Duy Dương | Cấu trúc State lưu trữ tạm thời |
| 5 | Báo cáo & Slide | Biên soạn tài liệu lý thuyết, sơ đồ vòng đời | Cả nhóm | NOI_DUNG_SLIDE.md, README.md |

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
