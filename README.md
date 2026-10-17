# Local AI

Ứng dụng chat tiếng Việt với mô hình GGUF chạy trực tiếp trên Android arm64 và iOS arm64. Internet chỉ dùng để tải model hoặc mở trang điều khoản; tin nhắn và inference được xử lý trên thiết bị.

## Chức năng

- Chat streaming, dừng câu trả lời, tạo hội thoại mới và khôi phục lịch sử local.
- Thư viện ba model GGUF có tải tiếp tục, tiến độ, huỷ, SHA-256 và xoá file.
- Chuyển model qua một inference service duy nhất; Android dùng CPU, iOS ưu tiên Metal.
- Chọn cấu hình Nhanh, Cân bằng hoặc Chất lượng.
- Drift/SQLite lưu hội thoại, tin nhắn, model đã cài và kết quả benchmark.

## Yêu cầu và chạy

- Flutter 3.47.7 và Android SDK/NDK tương ứng.
- iOS cần macOS/Xcode; deployment target là iOS 16.4.

```sh
flutter pub get
flutter run
```

APK arm64 release:

```sh
flutter build apk --release --target-platform android-arm64
```

Lệnh này dùng cấu hình ký debug mặc định của scaffold Flutter. Cần cấu hình signing riêng trước khi phát hành lên store.

Kiểm tra dự án:

```sh
dart analyze
flutter test
```

Trên môi trường phát triển có đường dẫn thư mục chứa ký tự ngoài ASCII mà `flutter analyze` gặp lỗi Analysis Server, `dart analyze` là lệnh phân tích thay thế.

## Dữ liệu và quyền riêng tư

Model GGUF và cơ sở dữ liệu nằm trong application support riêng của app. Không có tài khoản, đồng bộ hoặc telemetry. Tải model cần mạng; sau khi model được cài xong, inference không cần mạng. Xem [danh mục và giấy phép model](docs/MODEL_LICENSES.md) cùng [ghi chú benchmark](docs/PERFORMANCE.md).

## Phạm vi kiểm chứng

Unit/widget tests và APK Android được chạy trên môi trường phát triển. Chưa chứng nhận hiệu năng, nhiệt độ, OOM hoặc airplane mode trên thiết bị thật; build iOS cần macOS/Xcode. Ma trận và các bước kiểm tra thiết bị có trong [DEVICE_MATRIX.md](docs/DEVICE_MATRIX.md).
# ai_local
