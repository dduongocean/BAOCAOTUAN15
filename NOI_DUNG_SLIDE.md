# TÀI LIỆU CHUẨN BỊ & NỘI DUNG SLIDE BÁO CÁO (CHỦ ĐỀ 10)
**TRƯỜNG ĐẠI HỌC BÁCH KHOA - ĐẠI HỌC ĐÀ NẴNG**  
**KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO**  
**Giảng viên hướng dẫn:** TS. Nguyễn Duy Nhật Viễn  
**Đề tài:** Chủ đề 10. Cơ sở quản lý trạng thái và cập nhật giao diện trong Flutter  
**Thành viên thực hiện:** Phan Vĩnh Sơn (Slide 1 → 7) & Vũ Duy Dương (Slide 8 → 15)  

---

# PHẦN I. TOÀN BỘ KIẾN THỨC LÝ THUYẾT CỐT LÕI (KHÔNG THIẾU BẤT KỲ PHẦN NÀO)

## 1. Khái niệm State và mối quan hệ giữa State với Giao diện

### 1.1. State (Trạng thái) là gì?
Trong phát triển ứng dụng Flutter, **State** là bất kỳ dữ liệu nào có khả năng thay đổi theo thời gian và sự thay đổi đó làm thay đổi cách hiển thị của giao diện người dùng (UI).
- **Ví dụ thực tế:** Giá trị bộ đếm hiện tại, nội dung người dùng đang gõ vào ô tìm kiếm, trạng thái bật/tắt của nút gạt (Switch), danh sách sản phẩm trong giỏ hàng, trạng thái đang tải dữ liệu (`isLoading = true/false`).
- Ngược lại, những dữ liệu cố định không thay đổi trong quá trình tồn tại của widget (ví dụ: tiêu đề app, màu sắc cố định truyền vào constructor) **không phải là State**.

### 1.2. Mối quan hệ giữa State và Giao diện ($UI = f(state)$)
Flutter hoạt động theo mô hình **Lập trình khai báo (Declarative UI)**, hoàn toàn khác với mô hình **Lập trình mệnh lệnh (Imperative UI)** truyền thống (như Android XML/Java hay iOS UIKit).

| Tiêu chí | Imperative UI (Truyền thống) | Declarative UI (Flutter) |
| :--- | :--- | :--- |
| **Cách cập nhật** | Tìm đối tượng giao diện (`findViewById`) rồi gọi hàm sửa đổi trực tiếp (`textView.setText("Mới")`). | Không sửa đổi widget cũ. Chỉ thay đổi dữ liệu **State**, Flutter sẽ tự gọi `build()` để tạo ra cấu hình UI mới. |
| **Công thức** | Tự viết code đồng bộ từng bước | **$UI = f(\text{state})$** |
| **Ưu điểm** | Quen thuộc với lập trình cổ điển | Đồng bộ tuyệt đối giữa dữ liệu và hiển thị, loại bỏ lỗi giao diện bị lệch với biến dữ liệu. |

### 1.3. Kiến trúc 3 cây bên trong Flutter Engine (Bản chất công nghệ)
Để hiểu tại sao State không bị mất khi giao diện vẽ lại, cần nắm 3 cây của Flutter:
1. **Widget Tree (Cây cấu hình):** Chứa bản mô tả giao diện. Widget mang tính **bất biến (`@immutable`)**, siêu nhẹ, bị vứt bỏ và tạo mới liên tục mỗi khi hàm `build()` chạy lại.
2. **Element Tree (Cây thực thể - Xương sống):** Là cầu nối trung gian được Flutter giữ ổn định qua nhiều khung hình. **Element chính là nơi lưu giữ đối tượng `State`** để dữ liệu không bị mất đi khi Widget bị thay thế.
3. **RenderObject Tree (Cây hiển thị):** Tính toán kích thước (Layout), vị trí và trực tiếp vẽ các điểm ảnh (Paint) lên màn hình.

---

## 2. StatelessWidget, StatefulWidget, Vòng đời State và setState

### 2.1. StatelessWidget
- **Định nghĩa:** Là widget **không có trạng thái nội tại thay đổi theo thời gian**. Mọi thuộc tính khai báo bên trong nó bắt buộc phải là `final` (bất biến).
- **Khi nào vẽ lại?** Nó chỉ chạy lại hàm `build()` khi:
  1. Được chèn vào cây giao diện lần đầu tiên.
  2. Widget cha truyền vào một giá trị tham số mới thông qua Constructor.
  3. Một `InheritedWidget` mà nó đăng ký phụ thuộc (như `Theme.of(context)`, `MediaQuery`) có sự thay đổi.
- **Ứng dụng:** Văn bản tĩnh, biểu tượng (`Icon`), thanh tiêu đề cố định, card hiển thị không tự tương tác đổi dữ liệu.

### 2.2. StatefulWidget
- **Định nghĩa:** Là widget có thể thay đổi giao diện động khi người dùng tương tác hoặc khi dữ liệu bất đồng bộ thay đổi.
- **Kiến trúc tách đôi đặc biệt của `StatefulWidget`:**
  - **Lớp 1 (`StatefulWidget`):** Vẫn bất biến (`@immutable`). Nó đóng vai trò như vỏ bọc ngoài chứa cấu hình ban đầu và chỉ có nhiệm vụ duy nhất là tạo ra đối tượng State qua hàm `createState()`.
  - **Lớp 2 (`State<T>`):** Nằm bền vững trong Element Tree, là nơi chứa **các biến có thể thay đổi (mutable)** và hàm `build()`. Nhờ tách riêng như vậy, khi Widget cha vẽ lại và thay vỏ `StatefulWidget` mới, đối tượng `State` vẫn được giữ nguyên mà không bị reset về giá trị 0.

### 2.3. Vòng đời đầy đủ của State (State Lifecycle)
Một đối tượng `State` từ lúc sinh ra đến khi bị hủy đi qua các giai đoạn chuẩn sau:

1. **`createState()`:** Phương thức đầu tiên được gọi khi Flutter dựng `StatefulWidget`, trả về một thực thể của lớp `State`. Lúc này `mounted` chuyển thành `true` (State đã gắn vào `BuildContext`).
2. **`initState()`:**
   - Được gọi **đúng 1 lần duy nhất** trong toàn bộ vòng đời của State.
   - Dùng để khởi tạo giá trị biến ban đầu, tạo `AnimationController`, `TextEditingController`, hoặc đăng ký lắng nghe `Stream`.
   - *Lưu ý:* Tại đây chưa thể sử dụng `Theme.of(context)` hay `MediaQuery.of(context)` vì cây phụ thuộc chưa kết nối hoàn chỉnh.
3. **`didChangeDependencies()`:**
   - Được gọi ngay sau `initState()`.
   - Được gọi lại bất cứ khi nào một `InheritedWidget` mà State này phụ thuộc bị thay đổi (ví dụ: người dùng chuyển đổi Dark/Light Mode hoặc đổi ngôn ngữ ứng dụng).
4. **`build(BuildContext context)`:**
   - Hàm chịu trách nhiệm trả về cây giao diện Widget.
   - Được gọi rất nhiều lần: sau `initState`/`didChangeDependencies`, mỗi lần gọi `setState()`, hoặc khi có `didUpdateWidget()`.
   - *Nguyên tắc sống còn:* Hàm `build()` phải nhẹ, chạy nhanh, **tuyệt đối không gọi API, không khởi tạo Controller hay tính toán nặng bên trong `build()`**.
5. **`didUpdateWidget(covariant T oldWidget)`:**
   - Được gọi khi Widget cha rebuild và truyền một cấu hình Widget mới (với tham số mới) thay cho `oldWidget` nhưng vẫn giữ lại cùng một đối tượng `State`.
   - Dùng để so sánh `if (widget.id != oldWidget.id)` nhằm cập nhật lại dữ liệu nội bộ của State.
6. **`setState(VoidCallback fn)`:**
   - Phương thức thông báo cho Flutter biết dữ liệu State đã thay đổi và yêu cầu lên lịch chạy lại hàm `build()`.
7. **`deactivate()`:**
   - Được gọi khi State tạm thời bị gỡ khỏi cây giao diện (ví dụ khi di chuyển widget sang vị trí khác trong cây bằng `GlobalKey`). Nếu không được gắn lại trước khi kết thúc frame, bước tiếp theo sẽ là `dispose()`.
8. **`dispose()`:**
   - Được gọi **đúng 1 lần duy nhất** khi State bị xóa vĩnh viễn khỏi cây (`mounted` trở thành `false`).
   - **Bắt buộc** giải phóng toàn bộ tài nguyên tại đây (`controller.dispose()`, `timer.cancel()`, `streamSubscription.cancel()`) để tránh rò rỉ bộ nhớ (Memory Leak).

### 2.4. Cơ chế hoạt động bên trong của `setState()`
Khi lập trình viên gọi `setState(() { _count++; })`, Flutter thực hiện 3 bước sau:
- **Bước 1:** Thực thi ngay lập tức đoạn code bên trong dấu ngoặc `{ ... }` để cập nhật giá trị mới cho biến.
- **Bước 2:** Gọi hàm `_element.markNeedsBuild()` để đánh dấu Element tương ứng ở trạng thái **"Dirty" (cần được vẽ lại)**.
- **Bước 3:** Flutter **không vẽ lại ngay tức thì**, mà đợi đến nhịp đồng bộ khung hình tiếp theo (VSync, mỗi 16.6ms cho màn hình 60Hz) để gom toàn bộ các Element bị Dirty và chạy hàm `build()` một lần duy nhất. Cơ chế gom (batching) này giúp tránh vẽ thừa nếu gọi `setState` nhiều lần liên tiếp trong cùng một khung hình.

**Các lưu ý lỗi thường gặp với `setState()`:**
- **Không dùng `async` trong callback của `setState`:** Sai: `setState(() async { await fetch(); })` (vì `build()` sẽ chạy xong trước khi dữ liệu tải về). Đúng: `await fetch()` xong xuôi mới gọi `setState()`.
- **Lỗi gọi `setState()` sau khi `dispose()`:** Nếu người dùng thoát màn hình trong lúc API đang tải, khi API trả về và gọi `setState()` sẽ gây crash app. Giải pháp: luôn kiểm tra **`if (!mounted) return;`** trước khi gọi `setState()`.

---

## 3. Phân biệt Trạng thái cục bộ (Local State) và Trạng thái chia sẻ (Shared State)

| Tiêu chí | Trạng thái cục bộ (Ephemeral / Local State) | Trạng thái cần chia sẻ (App / Shared State) |
| :--- | :--- | :--- |
| **Định nghĩa** | Dữ liệu chỉ thuộc về **một Widget duy nhất** hoặc phạm vi một phần nhỏ màn hình. Các thành phần khác không cần biết đến nó. | Dữ liệu dùng chung bởi **nhiều Widget ở các vị trí khác nhau**, trên **nhiều màn hình khác nhau**, hoặc giữ xuyên suốt phiên chạy app. |
| **Thời gian sống** | Ngắn hạn. Thường biến mất khi Widget/màn hình đó bị đóng (pop khỏi Navigator). | Dài hạn. Tồn tại xuyên suốt khi người dùng chuyển qua lại giữa các trang. |
| **Ví dụ điển hình** | - Chỉ số tab đang chọn ở BottomNavigationBar.<br>- Tiến trình chạy hiện tại của Animation.<br>- Nội dung đang gõ tạm trong ô nhập liệu.<br>- Trạng thái đóng/mở của một thẻ Dropdown. | - Thông tin phiên đăng nhập (User Profile/Token).<br>- Giỏ hàng (Cart) trong app bán hàng.<br>- Số lượng thông báo chưa đọc ở thanh tiêu đề.<br>- Cấu hình Dark/Light Theme và Đa ngôn ngữ. |
| **Giải pháp kỹ thuật** | `StatefulWidget` và `setState()` | `InheritedWidget`, `Provider`, `Riverpod`, `BLoC`, `ValueNotifier` |

---

## 4. Vòng đời cập nhật và Giới hạn của quản lý trạng thái cục bộ

### 4.1. Vòng đời cập nhật giao diện
Luồng khép kín khi dùng `setState()`:  
`Người dùng tương tác (Tap)` $\to$ `Thay đổi biến trong setState()` $\to$ `Element bị đánh dấu Dirty` $\to$ `VSync phát nhịp khung hình mới` $\to$ `Hàm build() chạy lại` $\to$ `Giao diện cập nhật theo biến mới`.

### 4.2. Bốn giới hạn lớn của cách quản lý trạng thái cục bộ (`setState`)
Khi ứng dụng phình to lên hàng chục màn hình, chỉ dùng `setState()` sẽ bộc lộ 4 nhược điểm chí mạng:

1. **Đẩy State lên trên & Truyền dữ liệu rườm rà (Lifting State Up & Prop Drilling):**
   - Để 2 Widget con nằm khác nhánh (ví dụ: nút "Thêm vào giỏ" ở trang Chi tiết và icon "Số lượng giỏ hàng" ở trang Chủ) dùng chung 1 biến, bắt buộc phải đẩy biến State lên Widget Cha chung cao nhất.
   - Sau đó phải truyền biến qua Constructor qua nhiều tầng Widget trung gian (dù các tầng trung gian đó không hề dùng đến biến này), đồng thời truyền hàm callback ngược lại để Con có thể báo cho Cha đổi biến. Mã nguồn trở nên cực kỳ rối rắm và khó sửa.
2. **Gây Rebuild dư thừa (Sụt giảm hiệu năng):**
   - Khi gọi `setState()` ở một Widget Cha cấp cao, toàn bộ cây Widget Con bên dưới đều bị gọi lại hàm `build()` (trừ khi tối ưu khắt khe bằng `const`). Điều này gây tốn CPU vô ích cho những phần tử giao diện hoàn toàn không liên quan đến biến vừa đổi.
3. **Trộn lẫn Logic nghiệp vụ vào Giao diện (Tight Coupling):**
   - Biến dữ liệu và các hàm xử lý logic nằm chặt trong lớp `State` của màn hình. Do đó không thể tái sử dụng logic đó cho màn hình khác và rất khó viết bài kiểm thử tự động (Unit Test) tách biệt với UI.
4. **Khó đồng bộ qua nhiều màn hình trên Navigator:**
   - Khi chuyển trang qua `Navigator.push()`, màn hình mới và màn hình cũ không tự động chia sẻ chung vùng nhớ State cục bộ. Việc đồng bộ trạng thái giữa các trang phải thực hiện thủ công thông qua truyền tham số và chờ `await Navigator.push(...)`, dễ phát sinh lỗi sai lệch dữ liệu.

---

# PHẦN II. HƯỚNG DẪN THIẾT KẾ 15 SLIDE BÁO CÁO & PHÂN CHIA THUYẾT TRÌNH

**Thời lượng chuẩn:** 20 phút (10 phút Lý thuyết & Kiến trúc + 05 phút Live Demo + 05 phút Q&A)  
**Phân chia thuyết trình:** **Phan Vĩnh Sơn** (Slide 1 → 7) | **Vũ Duy Dương** (Slide 8 → 15)

---

### SLIDE 1: TRANG TIÊU ĐỀ & GIỚI THIỆU
- **Người nói:** Phan Vĩnh Sơn (0.5 phút)
- **Nội dung đưa lên slide:**
  - TRƯỜNG ĐẠI HỌC BÁCH KHOA - ĐẠI HỌC ĐÀ NẴNG
  - KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO
  - **BÁO CÁO CHUYÊN ĐỀ DART & FLUTTER**
  - **Chủ đề 10: Cơ sở quản lý trạng thái và cập nhật giao diện trong Flutter**
  - Giảng viên hướng dẫn: TS. Nguyễn Duy Nhật Viễn
  - Sinh viên thực hiện: **Phan Vĩnh Sơn** (Nhóm trưởng) & **Vũ Duy Dương**
- **Lời thoại của Sơn:**  
  *"Kính chào thầy Nguyễn Duy Nhật Viễn và các bạn. Hôm nay nhóm em xin báo cáo Chủ đề 10: Cơ sở quản lý trạng thái và cập nhật giao diện trong Flutter. Em là Sơn sẽ trình bày phần đầu về bản chất State và vòng đời giao diện, sau đó bạn Dương sẽ trình bày cơ chế setState, phân loại trạng thái và giới hạn thực tế."*

---

### SLIDE 2: BẢNG PHÂN CÔNG NHIỆM VỤ (WBS)
- **Người nói:** Phan Vĩnh Sơn (1 phút)
- **Nội dung đưa lên slide:**
  | Hạng mục WBS | Vai trò | Người phụ trách | Sản phẩm bàn giao |
  | :--- | :--- | :---: | :--- |
  | **UI Design** | Thiết kế giao diện & Slide báo cáo | **Phan Vĩnh Sơn** | Giao diện 2 màn hình demo, Slide |
  | **Business Logic** | Xử lý tương tác đếm số, log vòng đời | **Phan Vĩnh Sơn** | `state_lifecycle_demo.dart` |
  | **State Management** | Phân tích vòng đời, giới hạn `setState` | **Vũ Duy Dương** | `local_state_limit_demo.dart` |
  | **Database / Local Data** | Quản lý trạng thái bộ nhớ cục bộ | **Vũ Duy Dương** | Cấu trúc State lưu trữ tạm |
  | **Báo cáo & Slide** | Tổng hợp tài liệu, sơ đồ kiến trúc | **Sơn & Dương** | `NOI_DUNG_SLIDE.md`, `README.md` |
- **Lời thoại của Sơn:**  
  *"Nhóm phân công rõ ràng 5 vai trò chuẩn: Em phụ trách thiết kế UI, Business Logic đếm số và thuyết trình Slide 1-7. Bạn Dương phụ trách State Management, kiến trúc giới hạn Local State và thuyết trình Slide 8-15."*

---

### SLIDE 3: KHÁI NIỆM STATE & MÔ HÌNH DECLARATIVE UI
- **Người nói:** Phan Vĩnh Sơn (1 phút)
- **Nội dung đưa lên slide:**
  - **State là gì?** Mọi dữ liệu có thể thay đổi theo thời gian làm thay đổi giao diện (biến đếm, nội dung nhập, loading...).
  - **Mối quan hệ giữa State và UI ($UI = f(state)$):**
    - *Imperative (Truyền thống):* Tìm view và sửa trực tiếp (`textView.setText`).
    - *Declarative (Flutter):* Chỉ thay đổi State, Flutter tự vẽ lại giao diện mới phản ánh đúng State đó.
- **Sơ đồ vẽ trên slide (3 khối):**
  ```
  [ State thay đổi ] ──> [ Hàm build() chạy lại ] ──> [ Giao diện (UI) mới xuất hiện ]
  ```
- **Lời thoại của Sơn:**  
  *"Trong Flutter, giao diện là một hàm của trạng thái: $UI = f(\text{state})$. Thay vì tìm nút bấm để sửa chữ thủ công như lập trình truyền thống, ta chỉ cần cập nhật biến State, Flutter sẽ tự động dựng lại giao diện khớp với dữ liệu mới."*

---

### SLIDE 4: BẢN CHẤT CÔNG NGHỆ - KIẾN TRÚC 3 CÂY CỦA FLUTTER
- **Người nói:** Phan Vĩnh Sơn (1 phút)
- **Nội dung đưa lên slide:**
  - **1. Widget Tree:** Bản thiết kế cấu hình giao diện, bất biến (`immutable`), bị hủy và tạo lại liên tục.
  - **2. Element Tree:** Bộ khung xương sống lưu giữ liên kết và **là nơi cất giữ đối tượng State** để không bị mất dữ liệu khi vẽ lại.
  - **3. RenderObject Tree:** Thực hiện đo kích thước (Layout) và vẽ pixel lên màn hình (Paint).
- **Sơ đồ vẽ trên slide:**
  ```
  [ Widget Tree (Tạo mới liên tục) ] ──> [ Element Tree (Giữ đối tượng State) ] ──> [ RenderObject Tree (Vẽ ra màn hình) ]
  ```
- **Lời thoại của Sơn:**  
  *"Một câu hỏi đặt ra là: Nếu Widget bị tạo mới liên tục thì tại sao dữ liệu không bị reset về 0? Câu trả lời nằm ở kiến trúc 3 cây: Flutter cất giữ đối tượng State ở Element Tree chứ không phải trong Widget Tree."*

---

### SLIDE 5: STATELESSWIDGET VÀ STATEFULWIDGET
- **Người nói:** Phan Vĩnh Sơn (1 phút)
- **Nội dung đưa lên slide:**
  - **`StatelessWidget`:** Bất biến, không có State nội tại; chỉ vẽ lại khi Widget cha truyền dữ liệu mới qua Constructor (Ví dụ: Icon, Tiêu đề tĩnh).
  - **`StatefulWidget`:** Có dữ liệu thay đổi theo thời gian. Gồm 2 lớp tách biệt:
    - Lớp `StatefulWidget` (vỏ ngoài bất biến, gọi `createState()`).
    - Lớp `State<T>` (chứa biến thay đổi và hàm `build()`).
- **Sơ đồ vẽ trên slide:**
  ```
  StatelessWidget : [ Cấu hình cố định ] ──> [ build() ]
  StatefulWidget  : [ Lớp vỏ Widget ] ──> tạo ra ──> [ Lớp State (Giữ biến & build()) ]
  ```
- **Lời thoại của Sơn:**  
  *"Flutter chia Widget thành 2 loại: Stateless dành cho hiển thị tĩnh, bất biến; còn Stateful tách làm 2 lớp riêng biệt để lớp State giữ lại được dữ liệu thay đổi xuyên suốt thời gian chạy."*

---

### SLIDE 6: VÒNG ĐỜI CỦA STATE (PHẦN 1: KHỞI TẠO & HIỂN THỊ)
- **Người nói:** Phan Vĩnh Sơn (1 phút)
- **Nội dung đưa lên slide:**
  - 1. **`createState()`:** Tạo đối tượng State (`mounted = true`).
  - 2. **`initState()`:** Chạy **1 lần duy nhất** lúc khởi tạo (Khai báo biến, Controller, Stream).
  - 3. **`didChangeDependencies()`:** Chạy ngay sau `initState` và khi dữ liệu phụ thuộc (`Theme`, `MediaQuery`) thay đổi.
  - 4. **`build()`:** Vẽ cây giao diện (Chạy nhiều lần, yêu cầu nhẹ và nhanh).
- **Sơ đồ vẽ trên slide:**
  ```
  [ createState() ] ──> [ initState() (1 lần) ] ──> [ didChangeDependencies() ] ──> [ build() ]
  ```
- **Lời thoại của Sơn:**  
  *"Khi một StatefulWidget được gắn lên màn hình, nó chạy lần lượt: createState, initState đúng 1 lần duy nhất để chuẩn bị tài nguyên, sau đó qua didChangeDependencies và gọi build() để vẽ ra giao diện đầu tiên."*

---

### SLIDE 7: VÒNG ĐỜI CỦA STATE (PHẦN 2: CẬP NHẬT & HỦY BỎ)
- **Người nói:** Phan Vĩnh Sơn (1 phút)
- **Nội dung đưa lên slide:**
  - 5. **`didUpdateWidget()`:** Chạy khi Widget cha rebuild và truyền tham số mới xuống.
  - 6. **`setState()`:** Đánh dấu State cần vẽ lại và gọi lại `build()`.
  - 7. **`deactivate()`:** Chạy khi State tạm gỡ khỏi cây Widget.
  - 8. **`dispose()`:** Chạy **1 lần duy nhất** khi hủy vĩnh viễn (`mounted = false`) $\to$ Bắt buộc giải phóng tài nguyên (Controller, Stream) chống Memory Leak.
- **Sơ đồ vẽ trên slide:**
  ```
  [ build() ] <── setState() / didUpdateWidget()
      │
      ▼ (Khi thoát trang)
  [ deactivate() ] ──> [ dispose() (Giải phóng RAM) ]
  ```
- **Lời thoại của Sơn:**  
  *"Trong quá trình hoạt động, hàm build() liên tục chạy lại mỗi khi có setState() hoặc didUpdateWidget(). Khi người dùng thoát trang, deactivate và dispose() sẽ chạy để dọn dẹp bộ nhớ. Tiếp theo, bạn Dương sẽ giải thích cơ chế ngầm của setState và phân loại trạng thái."*

---

### SLIDE 8: CƠ CHẾ HOẠT ĐỘNG BÊN TRONG CỦA `setState()`
- **Người nói:** Vũ Duy Dương (1 phút)
- **Nội dung đưa lên slide:**
  - **3 bước ngầm khi gọi `setState(() { ... })`:**
    - 1. Chạy callback cập nhật giá trị biến ngay lập tức.
    - 2. Gọi `markNeedsBuild()` đánh dấu Element ở trạng thái **"Dirty" (cần vẽ lại)**.
    - 3. Đợi nhịp khung hình VSync kế tiếp (16.6ms) để gom và gọi `build()` một lần duy nhất.
  - **2 lưu ý bắt buộc:**
    - Không dùng `async` trực tiếp bên trong `setState(() async {...})`.
    - Luôn kiểm tra `if (mounted)` sau tác vụ bất đồng bộ để tránh lỗi crash sau khi `dispose()`.
- **Sơ đồ vẽ trên slide:**
  ```
  [ setState() ] ──> [ Cập nhật biến ] ──> [ Đánh dấu Dirty ] ──> [ Chờ VSync gọi build() ]
  ```
- **Lời thoại của Dương:**  
  *"Chào thầy và các bạn, em là Dương. Bản chất setState() không vẽ lại màn hình ngay tức thì tại dòng code đó, mà nó đánh dấu Element là 'Dirty' và đợi nhịp khung hình VSync tiếp theo mới gom lại gọi hàm build(). Điều này giúp tối ưu hiệu năng khi cập nhật nhiều biến cùng lúc."*

---

### SLIDE 9: TRẠNG THÁI CỤC BỘ (LOCAL STATE) VS TRẠNG THÁI CHIA SẺ (SHARED STATE)
- **Người nói:** Vũ Duy Dương (1 phút)
- **Nội dung đưa lên slide:**
  | Tiêu chí | Local State (Ephemeral State) | Shared State (App State) |
  | :--- | :--- | :--- |
  | **Phạm vi** | Nội bộ 1 Widget / 1 màn hình nhỏ | Chia sẻ nhiều Widget, nhiều màn hình |
  | **Ví dụ** | Tab đang chọn, tiến trình animation, nội dung đang gõ tạm | Thông tin User đăng nhập, Giỏ hàng, Dark/Light Theme |
  | **Công cụ** | `StatefulWidget` + `setState()` | `InheritedWidget`, `Provider`, `Riverpod`, `BLoC` |
- **Sơ đồ vẽ trên slide:**
  ```
  [ Local State ]  : Chỉ phục vụ 1 Widget (Dùng setState)
  [ Shared State ] : Phục vụ toàn ứng dụng (Dùng Provider / Riverpod / BLoC)
  ```
- **Lời thoại của Dương:**  
  *"Không có quy tắc cứng nhắc dùng công cụ nào cho mọi biến, mà ta chia làm 2 loại: Local State chỉ sống gọn trong 1 widget như tab đang chọn thì dùng setState cho gọn nhẹ. Còn Shared State như giỏ hàng hay user đăng nhập thì phải tách ra để nhiều màn hình cùng đọc được."*

---

### SLIDE 10: VÒNG ĐỜI CẬP NHẬT & 4 GIỚI HẠN CỦA QUẢN LÝ STATE CỤC BỘ
- **Người nói:** Vũ Duy Dương (1.5 phút)
- **Nội dung đưa lên slide:**
  - **Giới hạn 1 (Prop Drilling / Lifting State Up):** Phải đẩy biến lên Widget Cha chung cao nhất rồi truyền xuống từng lớp trung gian qua Constructor và Callback $\to$ Code rườm rà.
  - **Giới hạn 2 (Rebuild dư thừa):** Gọi `setState()` ở Widget Cha làm toàn bộ cây con bên dưới bị gọi lại `build()`, kể cả widget không dùng biến đó.
  - **Giới hạn 3 (Khó bảo trì & Test):** Logic trộn lẫn với code UI trong lớp `State`.
  - **Giới hạn 4 (Khó đồng bộ đa màn hình):** Không tự động đồng bộ qua các màn hình tách rời trên Navigator.
- **Sơ đồ minh họa Prop Drilling:**
  ```
  [ Widget Cha (Giữ biến State) ]
         │                 │
   (truyền biến)     (truyền callback)
         ▼                 ▼
  [ Con 1 (Hiển thị) ]   [ Con 2 (Nút bấm) ]   +   [ Con 3 (Bị rebuild oan!) ]
  ```
- **Lời thoại của Dương:**  
  *"Dùng setState rất nhanh nhưng gặp 4 giới hạn lớn khi app mở rộng: Thứ nhất là Prop Drilling – phải truyền biến và hàm callback qua nhiều tầng cha con rất rối. Thứ hai là Rebuild dư thừa: Cha gọi setState khiến cả những widget con không liên quan cũng bị vẽ lại."*

---

### SLIDE 11: GIỚI THIỆU CHƯƠNG TRÌNH DEMO THỰC HÀNH
- **Người nói:** Vũ Duy Dương (0.5 phút)
- **Nội dung đưa lên slide:**
  - **Mục tiêu Demo (2 Module cơ bản):**
    1. **`state_lifecycle_demo.dart` (Tab 1):** Chứng minh `StatelessWidget` bất biến vs `StatefulWidget` cập nhật qua `setState()`, theo dõi số lần `initState()`, `build()`, `dispose()` chạy.
    2. **`local_state_limit_demo.dart` (Tab 2):** Tái hiện thực tế bài toán Prop Drilling giữa Cha và 2 Con, và hiện tượng Con thứ 3 bị rebuild oan khi Cha `setState()`.
- **Sơ đồ kiến trúc app Demo:**
  ```
  [ main.dart (2 Tabs) ] ──┬──> [ Tab 1: state_lifecycle_demo.dart ]
                           └──> [ Tab 2: local_state_limit_demo.dart ]
  ```
- **Lời thoại của Dương:**  
  *"Để chứng minh toàn bộ lý thuyết vừa trình bày, nhóm xây dựng ứng dụng Demo tối giản gồm 2 module thực hành kiểm chứng vòng đời State và giới hạn của Local State."*

---

### SLIDE 12: DEMO 1 - VÒNG ĐỜI CẬP NHẬT & SETSTATE (`state_lifecycle_demo.dart`)
- **Người nói:** Phan Vĩnh Sơn (2 phút)
- **Nội dung đưa lên slide (Code tinh gọn):**
  ```dart
  class _StateLifecycleDemoState extends State<StateLifecycleDemo> {
    int _count = 0;

    @override
    void initState() { super.initState(); debugPrint('1. initState()'); }

    void _increment() {
      setState(() => _count++); // Đổi biến & gọi lại build()
    }

    @override
    Widget build(BuildContext context) { ... }
  }
  ```
- **Thao tác thực tế:** Sơn chạy Tab 1, bấm nút `+1` nhiều lần và chỉ rõ trên màn hình & Terminal: `initState()` chỉ chạy 1 lần lúc mở app, còn mỗi lần bấm `setState()` là số lần chạy hàm `build()` tăng lên tương ứng.

---

### SLIDE 13: DEMO 2 - GIỚI HẠN LOCAL STATE & REBUILD DƯ THỪA (`local_state_limit_demo.dart`)
- **Người nói:** Vũ Duy Dương (2 phút)
- **Nội dung đưa lên slide (Code minh họa Prop Drilling):**
  ```dart
  // Widget Cha giữ State, truyền xuống Con 1 & Con 2
  Column(children: [
    ChildDisplay(value: _counter),       // Con 1: Nhận dữ liệu
    ChildButton(onAdd: _increase),       // Con 2: Nhận callback
    UnrelatedChild(),                    // Con 3: Không dùng biến vẫn bị build lại!
  ])
  ```
- **Thao tác thực tế:** Dương chạy Tab 2, bấm nút ở Con 2 và chỉ vào Console Log cho thầy xem: cả `Cha`, `Con 1`, `Con 2` và **`Con 3 (Không liên quan)`** đều in ra thông báo bị gọi lại hàm `build()` dư thừa.

---

### SLIDE 14: GIẢI PHÁP KHẮC PHỤC & HƯỚNG PHÁT TRIỂN
- **Người nói:** Vũ Duy Dương (1 phút)
- **Nội dung đưa lên slide:**
  - **Tối ưu cục bộ trong `setState`:**
    - Đưa từ khóa **`const`** vào các Widget không đổi (như `const UnrelatedChild()`) để Flutter bỏ qua rebuild.
    - Chia nhỏ `StatefulWidget` xuống tận nút lá sâu nhất thay vì đặt ở Widget Cha to.
  - **Giải pháp triệt để cho App State:** Chuyển sang sử dụng `InheritedWidget`, `Provider`, `Riverpod` hoặc `BLoC` (sẽ học ở các chuyên đề sau) để tách biệt Logic khỏi UI và chỉ vẽ lại đúng Widget lắng nghe.
- **Sơ đồ vẽ trên slide:**
  ```
  [ Giới hạn setState ] ──> [ Giải pháp ngắn hạn: dùng const & tách widget nhỏ ]
                        ──> [ Giải pháp dài hạn: Provider / Riverpod / BLoC ]
  ```

---

### SLIDE 15: TỔNG KẾT & CÂU HỎI PHẢN BIỆN (Q&A)
- **Người nói:** Sơn & Dương (1 phút thuyết trình + 5 phút Q&A)
- **Nội dung đưa lên slide:**
  - **3 Điểm cốt lõi cần nhớ:**
    1. Giao diện là hàm của trạng thái: $UI = f(\text{state})$, State được giữ ở **Element Tree**.
    2. Vòng đời chuẩn: `initState` (1 lần) $\to$ `build` (nhiều lần qua `setState`) $\to$ `dispose` (giải phóng tài nguyên).
    3. Dùng `setState` cho Local State; dùng các giải pháp State Management cho Shared State để tránh Prop Drilling và Rebuild thừa.
  - **"XIN CẢM ƠN THẦY NGUYỄN DUY NHẬT VIỄN VÀ CÁC BẠN!"**

---

## PHẦN III. BỘ 5 CÂU HỎI PHẢN BIỆN THẦY RẤT HAY HỎI & ĐÁP ÁN CHUẨN

1. **Hỏi:** *Tại sao khi Widget cha rebuild tạo ra đối tượng `StatefulWidget` mới mà biến đếm bên trong `State` không bị reset về 0?*  
   $\to$ **Đáp án:** Vì đối tượng `Widget` chỉ là cấu hình tạm thời nằm ở Widget Tree, còn đối tượng `State` được Flutter gắn cố định vào **Element Tree**. Khi rebuild, Flutter giữ lại Element và State cũ, chỉ cập nhật lại tham chiếu tới Widget mới.
2. **Hỏi:** *Tại sao không nên gọi API hoặc tạo Controller bên trong hàm `build()`?*  
   $\to$ **Đáp án:** Vì hàm `build()` được gọi lại liên tục mỗi khi `setState()` hoặc animation chạy (có thể 60-120 lần/giây). Nếu đặt logic gọi API hay tạo biến trong `build()`, ứng dụng sẽ gọi mạng liên tục gây treo app và rò rỉ bộ nhớ. Nên đặt chúng trong `initState()`.
3. **Hỏi:** *Nếu gọi `setState()` sau khi đã `await` một tác vụ mạng mà người dùng đã bấm nút Back thoát màn hình rồi thì chuyện gì xảy ra?*  
   $\to$ **Đáp án:** App sẽ văng lỗi ngoại lệ (`setState() called after dispose()`). Cách phòng tránh là kiểm tra thuộc tính `if (!mounted) return;` trước khi gọi `setState()`.
4. **Hỏi:** *Làm sao để một Widget Con không liên quan không bị `build()` lại khi Widget Cha gọi `setState()`?*  
   $\to$ **Đáp án:** Khai báo constructor của Widget Con đó là `const` và truyền vào với từ khóa `const` (ví dụ `const UnrelatedChild()`). Flutter sẽ nhận ra tham chiếu không đổi và tái sử dụng lại Element cũ mà không gọi `build()`.
5. **Hỏi:** *Khi nào nên dùng `setState` và khi nào bắt buộc dùng `Provider` / `BLoC`?*  
   $\to$ **Đáp án:** Dùng `setState` cho trạng thái cục bộ gói gọn trong 1 widget/màn hình (như nút Switch, tab index). Khi cần chia sẻ dữ liệu xuyên suốt nhiều màn hình hoặc nhiều nhánh widget cách xa nhau (như giỏ hàng, thông tin đăng nhập) thì cần dùng `Provider`/`BLoC` để tránh Prop Drilling và rebuild dư thừa.
