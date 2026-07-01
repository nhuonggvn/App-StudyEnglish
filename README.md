# KidEnglish - Ứng dụng Học Tiếng Anh cho Trẻ Em

KidEnglish là ứng dụng học tiếng Anh tương tác dành cho lứa tuổi mầm non và tiểu học (từ 3 đến 10 tuổi). Ứng dụng được thiết kế hoàn toàn theo phong cách **Minimalist UI** và **Bento Grid** hiện đại, sử dụng tông màu chủ đạo tím-xanh tinh tế, bo góc lớn và các hiệu ứng nút nhấn 3D vật lý sinh động giúp tăng tính tương tác và tạo sự thích thú cho trẻ trong quá trình học tập.

Dự án được phát triển qua hai giai đoạn tương ứng với hai nhánh Git chính:
*   **Nhánh `main`**: Hoàn thành cấu trúc nền tảng, thiết kế giao diện Bento UI, các trò chơi tương tác cơ bản (Flashcard, Quiz, Ghép hình, Nghe), bảng xếp hạng, và vùng phụ huynh cơ bản.
*   **Nhánh `feature` (Hiện tại)**: Phát triển đột phá với tính năng **Tích hợp Trí Tuệ Nhân Tạo (Gemini AI)** cho phép tự động phân tích văn bản tiếng Anh, trích xuất từ vựng phù hợp độ tuổi và lưu trữ ngoại tuyến bền vững.

---

## 1. Thiết Kế & Hệ Thế Nhận Diện Thương Hiệu (Bento UI System)

Ứng dụng tuân thủ nghiêm ngặt hệ thống thiết kế tối giản, trực quan và hiện đại:

### Bảng Màu Thương Hiệu (Color Palette)
*   **Primary (Tím Chủ Đạo):** `#6B38D4` - Mang lại cảm giác kích thích trí não, khám phá khoa học và sáng tạo.
*   **Secondary (Xanh Lá Nhấn):** `#006C49` - Thể hiện sự phát triển bền vững, thân thiện và tươi sáng.
*   **Background (Nền Sáng):** `#FEF7FF` - Màu nền nhẹ nhàng, bảo vệ mắt của trẻ.
*   **Surface Containers:** Các khối Bento sử dụng các màu `#F7F2FA`, `#F3EDF7` kết hợp với viền mỏng `#E6E0E9` (`outlineVariant`) mang lại chiều sâu tinh tế thay vì đổ bóng đậm.

### Typography
*   **Font chữ chính:** `Nunito Sans` (tích hợp qua gói `google_fonts`) - Font chữ bo tròn thân thiện, dễ đọc, phù hợp tuyệt đối với trẻ em và các báo cáo phân tích dành cho phụ huynh.

### Quy Chuẩn Bo Góc & Tương Tác
*   **Border Radius:** Đồng bộ bo góc `32px` cho các container chính (Bento Cards, Grid Items) và `16px` cho các nút bấm phụ.
*   **Nút nhấn 3D (Pushable Button):** Thiết kế nút nhấn phẳng giả lập chiều sâu vật lý (viền dưới dày hơn 4px, khi nhấn sẽ dịch chuyển vị trí tạo phản hồi thị giác chân thực).

---

## 2. Quy Tắc Responsive Layout & Chống Overflow (Multi-Device Safe Rule)

Để đảm bảo giao diện hiển thị đẹp và không bị lỗi tràn màn hình (Overflow) trên mọi loại thiết bị từ 320dp trở lên, lập trình viên phải tuyệt đối tuân thủ các nguyên tắc sau:

### 2.1. Không dùng chiều cao cứng (Fixed Height) cho card chứa text
*   **Cấm dùng:** `height: 120` cho các Container hoặc Card có chứa text bên trong.
*   **Nguyên nhân:** Khi font size hệ thống của người dùng thay đổi (Accessibility lớn hơn mặc định), chữ sẽ tự động cao lên và gây lỗi render tràn khung.
*   **Ngoại lệ hợp lệ:** Chỉ áp dụng chiều cao cứng cho Widget chỉ chứa hình ảnh, Icon hoặc biểu đồ (CustomPaint) không kèm theo text.

### 2.2. Không dùng Expanded bên trong container có chiều cao cố định
*   **Cấm dùng:** Đặt Widget `Expanded` làm con của một `Container` có chiều cao `height` cố định.
*   **Nguyên nhân:** `Expanded` cần một cha có ràng buộc động (như Flex, Column, Row không có height cứng). Nếu chiều cao bị giới hạn cứng, hệ thống Flutter sẽ crash vì lỗi không tính toán được lay-out.
*   **Giải pháp:** Dùng thuộc tính `mainAxisSize: MainAxisSize.min` trên Column của container để tự động co giãn và xóa đi thuộc tính height của Container.

### 2.3. Quy tắc bắt buộc cho lay-out hai cột song song (Side-by-side Row)
*   Khi đặt hai card nằm cạnh nhau trong một `Row`, bắt buộc phải bọc Row đó bằng `IntrinsicHeight`:
    ```dart
    IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CardLeftWidget(),
          ),
          Expanded(
            child: CardRightWidget(),
          ),
        ],
      ),
    )
    ```
*   Mỗi card con bên trong cần thiết kế bằng Column và dùng `mainAxisSize: MainAxisSize.min`. Giao diện sẽ tự động đồng bộ chiều cao của cả hai card bằng với chiều cao của card lớn hơn.

### 2.4. Quy tắc cho biểu đồ hoặc CustomPaint
*   `CustomPaint` luôn phải được bọc bằng widget `SizedBox` có kích thước rộng, dài tường minh:
    ```dart
    SizedBox(
      width: 120, // chỉnh chiều rộng biểu đồ
      height: 120, // chỉnh chiều cao biểu đồ
      child: CustomPaint(
        painter: ChartPainter(),
      ),
    )
    ```

### 2.5. Quy tắc bọc Text trong không gian hẹp
*   Mỗi widget `Text` nằm trong `Expanded`, Row chia đôi hoặc Bento Card nhỏ bắt buộc phải có thuộc tính `overflow: TextOverflow.ellipsis` và `maxLines` để ngăn chữ tràn ra ngoài:
    ```dart
    Text(
      'Tên từ vựng tiếng Anh rất dài',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16, // chỉnh cỡ chữ label
      ),
    )
    ```

---

## 3. Kiến Trúc Dự Án (Architecture)

Ứng dụng áp dụng kiến trúc **Clean Code / MVVM** phân chia rõ ràng các lớp trách nhiệm:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        # Định nghĩa bảng màu Bento UI
│   │   └── app_theme.dart         # Cấu hình ThemeData, Font chữ Nunito Sans
│   └── services/
│       ├── gemini_service.dart    # Dịch vụ tích hợp AI Gemini để sinh gợi ý học tập
│       ├── local_storage_service.dart # Quản lý lưu trữ offline bằng Hive
│       ├── notification_service.dart # Dịch vụ thông báo nhắc nhở học tập
│       └── tts_service.dart       # Phát âm giọng đọc bản ngữ (Text to Speech)
├── data/
│   ├── models/
│   │   └── models.dart            # Khai báo models: Vocabulary, UserProfile, GameResult
│   └── vocabulary_data.dart       # Dữ liệu học tập và từ vựng hệ thống
├── providers/
│   └── app_provider.dart          # State Management (Điểm số, tiến độ học, setting)
├── widgets/
│   └── shared_widgets.dart        # Các Widget dùng chung như BentoCard, PushableButton
└── features/
    ├── splash/                    # Màn hình chờ khi vào ứng dụng
    ├── onboarding/                # Màn hình hướng dẫn cho người dùng mới
    ├── home/                      # Trang chủ với lưới Bento bất đối xứng và Custom Bottom Navigation
    ├── learning_path/             # Lộ trình học tập bất đối xứng (Asymmetric)
    ├── games/                     # Kho trò chơi tương tác (Flashcard, Quiz, Matching, Listening)
    ├── leaderboard/               # Bảng xếp hạng thi đua học tập
    └── parent_zone/               # Vùng phụ huynh giám sát, báo cáo fl_chart & Tạo chủ đề bằng AI
```

---

## 4. Các Thư Viện & Công Nghệ Sử Dụng (Dependencies)

*   `provider`: Quản lý trạng thái (State Management) toàn cục.
*   `flutter_tts`: Đọc từ vựng tiếng Anh chuẩn giọng bản xứ (Text-to-Speech).
*   `hive` & `hive_flutter`: Cơ sở dữ liệu NoSQL cực nhanh lưu trữ tiến trình học tập của trẻ ngoại tuyến.
*   `flutter_local_notifications`: Gửi thông báo đẩy nhắc nhở trẻ học tập theo giờ phụ huynh thiết lập.
*   `confetti`: Tạo hiệu ứng bóng bay và pháo hoa ăn mừng khi trẻ hoàn thành bài học hoặc game.
*   `audioplayers`: Phát âm thanh tiếng động khi chọn đúng/sai và nhạc nền cho game.
*   `google_fonts`: Load font chữ Nunito Sans chuẩn đẹp.
*   `fl_chart`: Vẽ biểu đồ cột biểu diễn thời gian học và điểm số trong Parent Zone.
*   `shared_preferences`: Lưu trữ các thiết lập đơn giản của ứng dụng.
*   `percent_indicator`: Hiển thị thanh tiến độ học tập hình tròn hoặc hình thanh ngang trực quan.

---

## 5. Các Phân Hệ Tính Năng Chính (Core Features)

### 5.1. Trang Chủ (Home Dashboard)
*   Hiển thị lưới Bento Grid bất đối xứng giới thiệu các chủ đề học tập trực quan (Động vật, Màu sắc, Gia đình, Trường học).
*   Thanh điều hướng tùy biến (**Custom Bottom Navigation Bar**) bo góc lớn, mô phỏng chính xác trạng thái kích hoạt với phản hồi rung nhẹ nhàng.

### 5.2. Lộ Trình Học Tập (Learning Path)
*   Thiết kế dạng **Asymmetric Layout** (so le trái - phải - giữa) độc đáo tạo cảm giác như một cuộc phiêu lưu kỳ thú.
*   Các thẻ bài học được kết nối với nhau bằng các đường nối chấm lửng tinh tế.
*   Logic hiển thị khóa (lock) xoay nhẹ 12 độ đối với bài học chưa mở khóa, tạo động lực chinh phục cho trẻ.

### 5.3. Kho Trò Chơi Tương Tác (Educational Games)
Mỗi chủ đề từ vựng hỗ trợ 4 chế độ chơi giúp kích thích tối đa các giác quan:
1.  **Flashcard:** Lật thẻ 3D mượt mà để ghi nhớ từ vựng kèm hình ảnh minh họa và phát âm giọng đọc bản xứ.
2.  **Trắc nghiệm (Quiz):** Thử thách phản xạ nhanh chọn nghĩa chính xác. Các thẻ đáp án đổi màu Xanh/Đỏ mượt mà khi chọn.
3.  **Ghép hình (Matching Game):** Cột tiếng Anh và cột tiếng Việt dạng lưới Bento. Trẻ chọn các thẻ tương ứng để ghép đôi, hệ thống tự động gạch ngang khi ghép đúng.
4.  **Nghe & Chọn (Listening Game):** Rèn luyện kỹ năng nghe với tính năng đọc chuẩn giọng bản xứ (TTS) hỗ trợ tùy chọn đọc chậm rãi cho trẻ mới bắt đầu.

### 5.4. Bảng Xếp Hạng (Leaderboard)
*   Bục vinh quang (Podium) Top 3 thiết kế dạng Bento cột màu sắc rõ ràng (Top 1 Tím, Top 2 Xanh lá, Top 3 Cam).
*   Danh sách xếp hạng thi đua giúp trẻ hào hứng và có thêm động lực học tập mỗi ngày.

### 5.5. Vùng Phụ Huynh (Parent Zone) - Nhánh Feature phát triển thêm
*   **Báo cáo tiến độ chi tiết:** Biểu đồ hoạt động hàng tuần dạng cột trực quan (sử dụng gói `fl_chart` tối giản).
*   **Đồng hồ quản lý giờ học:** Giới hạn thời gian học mỗi ngày và khóa bảo vệ giờ đi ngủ tự động.
*   **Nhắc nhở học tập thông minh:** Thiết lập giờ thông báo đẩy nhắc học.
*   **Tạo Chủ Đề Bằng AI (AI Topic Generator - Mới ở nhánh Feature)**:
    *   Cho phép Phụ huynh hoặc Giáo viên nhập API Key Gemini và dán văn bản tiếng Anh bất kỳ (bài báo, truyện ngắn, đoạn hội thoại...).
    *   Sử dụng mô hình `gemini-1.5-flash` để tự động phân tích và trích xuất thông minh từ 5 đến 10 từ vựng phù hợp nhất với nhóm tuổi đã chọn (3-5 tuổi, 6-7 tuổi hoặc 8-10 tuổi).
    *   Tự động dịch nghĩa Tiếng Việt chính xác và gán Emoji biểu tượng phù hợp cho từng từ.
    *   **Lưu trữ bền vững (Persistence)**: Tích hợp lưu trữ ngoại tuyến qua Hive database. Khi lưu, chủ đề tự chọn mới sẽ lập tức được thêm vào danh sách bài học trên toàn hệ thống và hiển thị lên lộ trình học tập để học sinh có thể tham gia học và chơi các trò chơi tương tác như các chủ đề mặc định.

---

## 6. Hướng Dẫn Cài Đặt & Chạy Dự Án

### Yêu Cầu Hệ Thống
*   Flutter SDK: `>=3.10.8`
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

3.  Khởi chạy ứng dụng trên thiết bị giả lập hoặc thiết bị thực tế:
    ```bash
    flutter run
    ```

---

## 7. QA Automation & Hướng Dẫn Testing

Để hỗ trợ tốt nhất cho việc kiểm thử tự động hóa (QA Automation), hệ thống tích hợp sẵn các kiểm thử đơn vị (Unit Test) và kiểm thử giao diện (Widget Test).

### 7.1. Các lệnh chạy kiểm thử tự động
*   Chạy toàn bộ test trong dự án:
    ```bash
    flutter test
    ```
*   Chạy riêng một file kiểm thử cụ thể:
    ```bash
    flutter test test/widget_test.dart
    ```
*   Chạy test và xuất báo cáo độ bao phủ mã nguồn (Code Coverage):
    ```bash
    flutter test --coverage
    ```

### 7.2. File viết Test mẫu hoàn chỉnh
Lập trình viên có thể tham khảo đoạn mã nguồn test sau để viết thêm các bài kiểm thử cho Widget mới đúng quy chuẩn:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test widget kiểm tra hành vi nhấn nút PushableButton
void main() {
  testWidgets('Kiểm tra Widget PushableButton hoạt động đúng', (WidgetTester tester) async {
    bool isPressed = false;

    // Khởi tạo Widget trong môi trường test giả lập
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextButton(
            onPressed: () {
              isPressed = true;
            },
            child: const Text('Nhấn vào đây'),
          ),
        ),
      ),
    );

    // Kiểm tra chữ trên nút bấm có tồn tại không
    expect(find.text('Nhấn vào đây'), findsOneWidget);

    // Thực hiện hành động bấm nút giả lập
    await tester.tap(find.text('Nhấn vào đây'));
    await tester.pump();

    // Kiểm tra giá trị biến thay đổi đúng logic mong muốn
    expect(isPressed, true);
  });
}
```
