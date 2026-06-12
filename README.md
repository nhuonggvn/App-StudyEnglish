# LingoKids - Ứng dụng Học Tiếng Anh Bento UI Cho Trẻ Em

LingoKids là ứng dụng học tiếng Anh tương tác dành cho lứa tuổi mầm non và tiểu học (từ 3 đến 10 tuổi). Ứng dụng được thiết kế hoàn toàn theo phong cách **Minimalist Bento UI** hiện đại, sử dụng tông màu chủ đạo tím-xanh tinh tế, bo góc lớn và các hiệu ứng nút nhấn 3D vật lý sinh động giúp tăng tính tương tác và tạo sự thích thú cho trẻ trong quá trình học tập.

---

## 1. Thiết Kế & Hệ Thống Nhận Diện Thương Hiệu (Bento UI System)

Ứng dụng tuân thủ nghiêm ngặt hệ thống thiết kế tối giản, trực quan và hiện đại:

### Bảng Màu Thương Hiệu (Color Palette)
*   **Primary (Tím Chủ Đạo):** `#6B38D4` - Mang lại cảm giác kích thích trí não, khám phá khoa học và sáng tạo.
*   **Secondary (Xanh Lá Nhấn):** `#006C49` - Thể hiện sự phát triển bền vững, thân thiện và tươi sáng.
*   **Background (Nền Sáng):** `#FEF7FF` - Màu nền nhẹ nhàng, bảo vệ mắt của trẻ.
*   **Surface Containers:** Các khối Bento sử dụng các màu `#F7F2FA`, `#F3EDF7` kết hợp với viền mỏng `#E6E0E9` (`outlineVariant`) mang lại chiều sâu tinh tế thay vì đổ bóng đậm.

### Typography
*   **Font chữ chính:** `Nunito Sans` - Font chữ bo tròn thân thiện, dễ đọc, phù hợp tuyệt đối với trẻ em và các báo cáo phân tích dành cho phụ huynh.

### Quy Chuẩn Bo Góc & Tương Tác
*   **Border Radius:** Đồng bộ bo góc `32px` cho các container chính (Bento Cards, Grid Items) và `16px` cho các nút bấm phụ.
*   **Nút nhấn 3D (Pushable Button):** Thiết kế nút nhấn phẳng giả lập chiều sâu vật lý (viền dưới dày hơn 4px, khi nhấn sẽ dịch chuyển vị trí tạo phản hồi thị giác chân thực).

---

## 2. Kiến Trúc Dự Án (Architecture)

Ứng dụng áp dụng kiến trúc **Clean Code / MVVM** với sự quản lý trạng thái của thư viện `provider`, giúp mã nguồn dễ bảo trì, mở rộng và viết Unit Test:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart    # Định nghĩa bảng màu Bento UI
│   │   └── app_theme.dart     # Cấu hình ThemeData, Font chữ Nunito Sans
│   └── utils/                 # Các tiện ích hệ thống
├── data/
│   ├── models/
│   │   └── models.dart        # Khai báo dữ liệu Vocabulary, User Profile, Game Result
│   └── mock_data.dart         # Dữ liệu học tập giả lập ban đầu
├── providers/
│   └── app_provider.dart      # Quản lý State toàn cục (Điểm số, Âm thanh TTS, Tiến độ)
├── widgets/
│   └── shared_widgets.dart    # Thẻ Bento, nút nhấn 3D vật lý dùng chung
└── features/
    ├── home/                  # Màn hình chính & Custom Bottom Navigation Bar
    ├── learning_path/         # Lộ trình học tập cá nhân hóa bất đối xứng
    ├── games/                 # Kho trò chơi tương tác (Flashcard, Quiz, Ghép hình, Nghe & Chọn)
    ├── leaderboard/           # Bảng xếp hạng thi đua
    └── parent_zone/           # Vùng phụ huynh giám sát và báo cáo học tập tuần
```

---

## 3. Các Phân Hệ Tính Năng Chính (Core Features)

### 3.1. Trang Chủ (Home Dashboard)
*   Hiển thị lưới Bento Grid bất đối xứng giới thiệu các chủ đề học tập trực quan (Động vật, Màu sắc, Gia đình, Trường học).
*   Thanh điều hướng tùy biến (**Custom Bottom Navigation Bar**) bo góc lớn, mô phỏng chính xác trạng thái kích hoạt với phản hồi xúc giác nhẹ nhàng.

### 3.2. Lộ Trình Học Tập (Learning Path)
*   Thiết kế dạng **Asymmetric Layout** (so le trái - phải - giữa) độc đáo tạo cảm giác như một cuộc phiêu lưu kỳ thú.
*   Các thẻ bài học được kết nối với nhau bằng các đường nối chấm lửng tinh tế.
*   Logic hiển thị khóa (lock) xoay nhẹ 12 độ đối với bài học chưa mở khóa, tạo động lực chinh phục cho trẻ.

### 3.3. Kho Trò Chơi Tương Tác (Educational Games)
Mỗi chủ đề từ vựng hỗ trợ 4 chế độ chơi giúp kích thích tối đa các giác quan:
1.  **Flashcard:** Lật thẻ 3D mượt mà để ghi nhớ từ vựng kèm hình ảnh minh họa và phát âm giọng đọc bản ngữ.
2.  **Trắc nghiệm (Quiz):** Thử thách phản xạ nhanh chọn nghĩa chính xác. Các thẻ đáp án đổi màu Xanh/Đỏ mượt mà khi chọn.
3.  **Ghép hình (Matching Game):** Cột tiếng Anh và cột tiếng Việt dạng lưới Bento. Trẻ chọn các thẻ tương ứng để ghép đôi, hệ thống tự động gạch ngang khi ghép đúng.
4.  **Nghe & Chọn (Listening Game):** Rèn luyện kỹ năng nghe với tính năng đọc chuẩn giọng bản ngữ (TTS) hỗ trợ tùy chọn đọc chậm rãi cho trẻ mới bắt đầu.

### 3.4. Bảng Xếp Hạng (Leaderboard)
*   Bục vinh quang (Podium) Top 3 thiết kế dạng Bento cột màu sắc rõ ràng (Top 1 Tím, Top 2 Xanh lá, Top 3 Cam).
*   Danh sách xếp hạng thi đua giúp trẻ hào hứng và có thêm động lực học tập mỗi ngày.

### 3.5. Vùng Phụ Huynh (Parent Zone)
*   **Báo cáo tiến độ chi tiết:** Biểu đồ hoạt động hàng tuần dạng cột trực quan (sử dụng gói `fl_chart` tối giản).
*   **Đồng hồ quản lý giờ học:** Giới hạn thời gian học mỗi ngày và khóa bảo vệ giờ đi ngủ tự động.
*   **Nhắc nhở học tập thông minh:** Thiết lập giờ thông báo đẩy nhắc học.
*   **Chế độ Ngoại tuyến (Offline Mode):** Học tập mọi lúc mọi nơi không cần kết nối Internet.

---

## 4. Hướng Dẫn Cài Đặt & Chạy Dự Án

### Yêu Cầu Hệ Thống
*   Flutter SDK: `>=3.0.0`
*   Dart SDK: `>=3.0.0`

### Các Bước Cài Đặt

1.  Tải các gói phụ thuộc:
    ```bash
    flutter pub get
    ```

2.  Kiểm tra chất lượng và định dạng mã nguồn:
    ```bash
    flutter analyze
    ```

3.  Khởi chạy ứng dụng trên thiết bị giả lập hoặc thực tế:
    ```bash
    flutter run
    ```
