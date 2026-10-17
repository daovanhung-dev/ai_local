# KẾ HOẠCH KỸ THUẬT — LOCAL AI CHATBOT (ANDROID + iOS)

**Phiên bản:** 1.0 — 16/10/2026  
**Phạm vi:** Chat text offline trên thiết bị, chuyển đổi giữa nhiều model ngay trong chat, ưu tiên tốc độ phản hồi.  
**Ngăn xếp:** Flutter + Riverpod + llamadart/llama.cpp + GGUF + SQLite/Drift.

## 1. Mục tiêu, phạm vi, KPI

### Bắt buộc trong MVP
- Chạy 100% offline sau khi tải model; **không gọi API inference**, không yêu cầu tài khoản.
- Android arm64-v8a và iOS arm64; Flutter UI dùng chung.
- Hiển thị tối thiểu 3 model; trạng thái chưa tải/đang tải/đã tải/đang nạp/sẵn sàng/lỗi.
- Chọn model ngay đầu màn chat; tải, huỷ tải, xoá, chuyển model; chỉ một model loaded tại thời điểm bất kỳ.
- Gửi/nhận text; token streaming, nút Dừng, New chat, lịch sử local, khôi phục ứng dụng.
- Tự nhận diện mức RAM/backend; chế độ Fast/Balanced/Quality; giải quyết lỗi OOM, thiếu bộ nhớ, thiếu dung lượng.
- Benchmark và lưu thông số TTFT, prefill, token/s, warmup, load-time, bộ nhớ, nhiệt độ ở chế độ phát triển.

### KPI chính (không đồng nhất với thời gian hoàn thành câu trả lời)
- **TTFT**: từ bấm Gửi đến **token đầu tiên thực sự hiển thị**; mục tiêu P50 < 350 ms, P95 < 500 ms trong **warm run**, model Ultra Fast hoặc Balanced trên **danh sách thiết bị đã chứng nhận** với prompt ngắn và context đã cache. Đây là tiêu chí thử nghiệm, không phải cam kết có sẵn.
- **Cold start** (từ app/engine chưa tải) và **model switching** theo dõi riêng, không tính vào SLA warm TTFT; UI phải thông báo đang nạp model.
- **Decode throughput**: chọn model/backend nhanh nhất theo đo thực tế; không đặt con số token/s chung cho mọi thiết bị.
- **Ổn định**: 0 crash/OOM trong 100 lượt chat test/thiết bị; app không giật đáng kể khi streaming, không làm mất lịch sử.
- **Đúng**: câu trả lời đa lượt có lịch sử, dừng sinh hoạt động, không tự lẫn nội dung từ model trước.

### Ngoài phạm vi MVP
- Voice, RAG, tải ảnh, cloud sync, sign-in, gọi công cụ, chạy đa model song song, chạy liên tục ngầm. Chỉ thêm sau khi KPI cốt lõi đạt.

## 2. Công nghệ

- Flutter stable tương thích phiên bản `llamadart` được khóa trong `pubspec.lock`; Dart + Riverpod + GoRouter (nếu nhiều trang).
- `llamadart` gọi native `llama.cpp` cho GGUF; `llamadart_llama_cpp_flutter` khi build iOS theo đúng cặp phiên bản do maintainer công bố. **Không** trộn companion version tùy tiện.
- Metal trên iOS; CPU NEON trên Android; Vulkan Android **opt-in**, kiểm tra driver, thử nghiệm có fallback CPU.
- Drift/SQLite: conversation, message, model metadata, benchmark result. Store file GGUF tại application support/private storage.
- HTTP client hỗ trợ download resume (Range), SHA-256, kích thước tệp, kiểm tra dung lượng trống; không lưu GGUF vào asset bundle nếu muốn tải/xoá riêng.
- Native inference chạy ngoài UI isolate; giới hạn tốc độ thông báo về UI để tránh rebuild nhiều lần.

## 3. Danh mục model ban đầu

| id | Tên hiển thị | GGUF | Dung lượng tham khảo | Vai trò |
|---|---|---|---|---|
| gemma3-270m-q4 | Gemma 3 270M — Ultra Fast | Q4_K_M | ~253 MB | Tối đa tốc độ, chất lượng chat tổng quát hạn chế |
| qwen3-06b-q4 | Qwen3 0.6B — Balanced | Q4_K_M | ~480 MB | **Mặc định khuyến nghị**, non-thinking |
| qwen3-17b-q4 | Qwen3 1.7B — Quality | Q4_K_M | Khoảng 1–1.3 GB, xác minh file trước khi phát hành | Chất lượng cao hơn, tốc độ thấp hơn |

**Nguồn đã kiểm tra:**
- Gemma 3 270M quant: https://huggingface.co/gguf-org/gemma-3-270m-it-gguf
- Qwen3 0.6B quant: https://huggingface.co/bartowski/Qwen_Qwen3-0.6B-GGUF
- Qwen3 0.6B hướng dẫn `/no_think`: https://huggingface.co/Qwen/Qwen3-0.6B-GGUF
- Model lớn hơn cần chốt SHA-256/URL/license trước khi triển khai.

Mỗi entry trong manifest gồm: `id`, `name`, `description`, `sourceUrl`, `fileName`, `sizeBytes`, `sha256`, `license`, `quantization`, `recommendedRam`, `contextSize`, `supportsThinking`, `recommendedBackend`, `sortOrder`. Chỉ hiện **Install** khi URL + license + hash đã được kiểm tra. Với model chưa tải: chọn model mở hộp thoại tải chứ không block chat âm thầm.

**Giấy phép**: kiểm tra cụ thể của từng model/quantizer, hiển thị attribution và điều khoản cần thiết. Không cho phép download một file từ nguồn không rõ ràng rồi tự thực thi.

## 4. Kiến trúc

```text
Flutter Screens & Widgets
  ChatScreen ─ ModelPickerSheet ─ ModelLibraryScreen ─ SettingsScreen
          │
Riverpod Notifiers / State
  ChatController       ModelController       BenchmarkController
          │                  │                       │
Use Cases
  SendMessage       SelectModel / Download / Delete        ProbeDevice
          │                  │                       │
Repositories
  ConversationRepository (Drift) ─ ModelRepository (manifest+local path)
          │                  │
Services
  LocalInferenceService (single engine + ChatSession + streaming)
  ModelLifecycleService (unload/load/warmup/recreate session)
  DownloadService (HTTP range, .part, hash, atomic rename)
  DeviceProfileService (RAM / CPU / GPU capability)
  PerformanceService (timings & memory)
          │
Native llama.cpp (GGUF, CPU/Metal/Vulkan)
```

**Quy tắc ownership:** `InferenceService` độc quyền quản lý engine; không tạo engine trong Widget `build()`; cho phép duy nhất một generation; khi đổi model phải cancel/await generation, lưu tin nhắn, giải phóng engine cũ, tải engine mới, warmup, tạo ChatSession và phục hồi history trong giới hạn token.

### Cấu trúc project

```text
lib/
  app/app.dart
  core/config/model_catalog.dart
  core/errors/app_failure.dart
  core/storage/app_database.dart
  core/services/device_profile_service.dart
  core/services/performance_service.dart
  features/chat/{data,domain,presentation}/
  features/models/{data,domain,presentation}/
  features/settings/presentation/
  inference/local_inference_service.dart
  inference/model_lifecycle_service.dart
  inference/inference_config.dart
  download/model_download_service.dart
  shared/widgets/
test/{unit,widget,integration}/
integration_test/
tooling/benchmark/
docs/{PERFORMANCE.md,DEVICE_MATRIX.md,MODEL_LICENSES.md}
```

### SQLite schema tối thiểu

```text
conversations(id, title, created_at, updated_at, last_model_id)
messages(id, conversation_id, role, content, model_id, status, created_at, token_count)
installed_models(id, file_path, status, installed_at, sha256, size_bytes)
benchmarks(id, device_id, model_id, backend, context_tokens, prompt_tokens,
           warm, ttft_ms, prefill_ms, decode_tps, peak_memory_mb, timestamp)
```

Index `messages(conversation_id, created_at)` và `conversations(updated_at)`; serialize DB IO không chặn UI. `model_id` trên mỗi tin nhắn giúp thấy rõ câu trả lời đã được sinh bởi model nào.

## 5. UX luồng màn hình

### Chat
- App bar: `Local AI` + menu chọn model (tên, trạng thái, dung lượng, tốc độ ước tính sau benchmark).
- Danh sách tin nhắn; bong bóng user và assistant; có biểu tượng model trên mỗi trả lời.
- Composer: ô nhập, Gửi, Dừng khi đang stream. Có New Chat và Lịch sử.
- Thời gian model chưa sẵn sàng: `Đang tải model...` / `Đang nạp model...`; không che giấu chi phí chuyển model.
- Stream text có cursor; cập nhật UI theo chu kỳ khoảng 30–50 ms hoặc tối đa 2–4 lần mỗi frame, gom delta; không gọi setState mỗi token nếu nhiều sự kiện nhỏ.

### Model picker / Model library
- Mỗi model có nhãn Fast/Balanced/Quality; Installed/Not downloaded/Loading.
- Chạm model đã tải: huỷ generation đang diễn ra (có cảnh báo nhẹ nếu cần), chuyển model và warmup.
- Chạm model chưa tải: tải về trong nền của ứng dụng, hiển thị %, dung lượng, huỷ, thử lại.
- Nút xoá chỉ cho model không còn đang dùng; xác nhận và dọn file.
- Show RAM usage/kích thước file; model quá nặng sẽ cảnh báo.

### App resume/restart
- Khôi phục danh sách chat ngay lập tức; last-model tự nạp khi người dùng đi vào chat (có thể bắt đầu preload lúc app vào foreground nếu hợp lý).
- Nếu điện thoại kill process, cold loading là bình thường; không giả lập trạng thái Ready.
- Tôn trọng lifecycle iOS/Android; release model nếu áp lực bộ nhớ; không giữ chạy inference dưới nền trong MVP.

## 6. Tối ưu tốc độ (thứ tự ưu tiên)

1. **Model nhỏ, quantization Q4**: benchmark Gemma 270M, Qwen3 0.6B. Q4_K_M là baseline; thử Q4_0 với ARM (online repacking) nếu benchmark nhanh hơn; xác minh chất lượng tiếng Việt.
2. **Warm model**: nạp 1 model mặc định khi vào chat, warmup sau load, giữ engine khi người dùng chat liên tục. Không huỷ/tạo engine sau từng lượt.
3. **Context thấp**: baseline `contextSize=1024` hoặc `2048`; session budget 768–1536, giữ system prompt ngắn và tin nhắn gần nhất. Không nhét toàn bộ lịch sử vào inference.
4. **Reuse KV/prompt prefix**: dùng ChatSession cùng engine; `reusePromptPrefix=true`; giữ prefix ổn định. Khi switch model phải tạo session mới và rehydrate history.
5. **Qwen non-thinking**: áp `/no_think` hoặc runtime chat template tương thích; không stream nội dung `<think>` ra UI. Đừng dùng instruction format chung cho mọi model.
6. **Backend benchmark thực tế**: so sánh CPU, Metal iOS, Vulkan Android. Đừng mặc định GPU nhanh nhất với model nhỏ. Chỉ bật Vulkan cho GPU/driver đã chứng nhận.
7. **Threads**: bắt đầu `numberOfThreads=0` (auto); thử 2, 3, 4 thread trên máy mẫu và giữ best config; tránh giả định dùng tất cả core là nhanh nhất.
8. **Prefill**: giảm token prompt mới, giữ đúng KV cache; tune `batchSize` và `microBatchSize` một biến mỗi lần theo tài liệu. Trên Android Vulkan có cấu hình subgroup bị hạn chế microbatch — giữ fallback nếu output sai.
9. **Generation**: cap `maxTokens` 96/128/256 theo profile; hạ length khi người dùng chọn Fast; stream ngay khi có token. `streamBatchTokenThreshold=1` cho TTFT (so với 2/4/8 nếu overhead cao).
10. **UI**: không render Markdown phức tạp từng ký tự; stream plain text, parse markdown khi message hoàn tất hoặc debounce; input không bị block.
11. **Avoid startup IO**: manifest đọc nhanh và không chặn UI; model file được mmap nếu runtime hỗ trợ và không làm tăng lỗi page-in; đo cold load riêng.
12. **No speculative decoding mặc định**: có thể tốn RAM/khởi tạo và giảm throughput; chỉ bật sau A/B test có lợi trên máy thật.
13. **Thermal policy**: nếu throttle nóng máy làm TTFT xấu đi, hạ thread/gpu hoặc hạ profile; dừng khi app background theo policy.

Cấu hình thử nghiệm ban đầu (tuning, **không phải cấu hình phổ quát**):

```dart
const modelParams = ModelParams(
  contextSize: 2048,
  gpuLayers: 0, // CPU baseline Android; benchmark Metal/Vulkan sau
  numberOfThreads: 0,
  numberOfThreadsBatch: 0,
);

const generationParams = GenerationParams(
  maxTokens: 128,
  temp: 0.7,
  topK: 20,
  topP: 0.8,
  reusePromptPrefix: true,
  streamBatchTokenThreshold: 1,
);
```

Điều chỉnh các param theo model. Qwen3 non-thinking tham khảo thông số Qwen; không dùng config trên nếu runtime không hỗ trợ tham số nào.

## 7. Ví dụ triển khai inference, API có thể cần đồng bộ với phiên bản đã khóa

```dart
import 'package:llamadart/llamadart.dart';

Future<void> quickSmokeTest(String ggufPath) async {
  final engine = await LlamaEngine.load(
    LlamaModel(ModelSource.path(ggufPath)),
    params: const ModelParams(contextSize: 2048, gpuLayers: 0),
  );
  try {
    final session = ChatSession(
      engine,
      maxContextTokens: 1536,
      systemPrompt: 'Trả lời bằng tiếng Việt ngắn gọn, chính xác. /no_think',
    );
    await for (final chunk in session.create([
      const LlamaTextContent('Xin chào, bạn là ai?'),
    ])) {
      // chuyển chunk.text đến ViewModel rồi UI, không block thread
      print(chunk.text);
    }
  } finally {
    await engine.dispose();
  }
}
```

`/no_think` chỉ áp với Qwen tương thích; Gemma dùng system prompt riêng. Trong app thật, engine phải được giữ sống giữa nhiều lượt, không dispose sau một câu hỏi như demo smoke-test.

**State machine model:** `notInstalled -> downloading -> installed -> loading -> warming -> ready -> generating -> ready`; mọi state có thể chuyển sang `error`, hỗ trợ cancel; switching là `cancel -> unload -> load -> warm -> ready`.

**Pipeline send:** `save user -> start Stopwatch -> generate async -> receive first nonempty visible text -> record TTFT -> flush UI -> stream -> finalize assistant -> save -> record tps`. Không tính spinner, placeholder hoặc text đã hard-code là token đầu tiên.

## 8. Roadmap và tiêu chí nghiệm thu

### Giai đoạn 0 — Preflight & baseline (0.5–1 ngày)
- [ ] Chốt 1 máy Android thật + 1 iPhone thật, ghi chipset/RAM/OS.
- [ ] Cài Flutter, SDK/NDK/Xcode phù hợp, đặt min iOS 16.4+ theo runtime.
- [ ] POC load từng GGUF trên thiết bị thật, test CPU; xác nhận license/size/checksum.
- [ ] Tạo benchmark thủ công cho 1 prompt 10–30 tokens, 1 prompt 100–200 tokens.
- **Done:** GGUF chạy offline, có log first token/time tổng/RAM và nhận diện GPU.

### Giai đoạn 1 — Chat end-to-end (1–2 ngày)
- [ ] Flutter ChatScreen, composer, streaming bubble, stop generating, retry.
- [ ] LocalInferenceService singleton hoặc long-lived Riverpod provider; ChatSession; catch OOM/errors.
- [ ] New chat và history tồn tại khi restart.
- **Done:** 20 cuộc hội thoại cơ bản liên tục không crash, stream không lag; hoàn toàn offline.

### Giai đoạn 2 — Multi-model & download (1–2 ngày)
- [ ] Model manifest, model picker, danh mục tải model, download .part/resume/checksum, delete.
- [ ] Serial model switching, reset context đúng, chỉ 1 engine.
- [ ] UI phản ánh trạng thái Ready/Loading/Downloading/Error chính xác.
- **Done:** tải, chuyển, xóa, khôi phục ít nhất 3 model; không leak RAM sau 10 lần switch.

### Giai đoạn 3 — Performance engineering (2–3 ngày)
- [ ] Thử các model/quant/backends/threads/context và lưu CSV benchmark.
- [ ] Warmup + prompt-cache + context pruning + render throttling.
- [ ] Auto-select CPU/GPU profile trên ma trận thiết bị, fallback an toàn.
- [ ] Đo cold vs warm, 20+ warm turns/cấu hình, P50/P95, nhiệt và pin.
- **Done:** TTFT P95 dưới 500 ms ở thiết bị/model đã chứng nhận hoặc report không đạt và lý do; không quảng cáo cam kết chung.

### Giai đoạn 4 — QA/release (1–2 ngày)
- [ ] Airplane-mode offline test; kill/resume; background/foreground; low-RAM/low-storage; checksum fail; interrupted download.
- [ ] Test trên 2–4 Android cấu hình khác nhau + ít nhất 1 iPhone thật nếu có.
- [ ] Không upload tin nhắn/telemetry mặc định. Kiểm tra quyền app, license, privacy manifest iOS.
- [ ] Build Android APK/AAB + iOS IPA qua Mac/Xcode; test release build (khác debug).
- **Done:** smoke test offline, dữ liệu bền vững, UX chấp nhận được, báo cáo benchmark có giới hạn.

**Tổng ước lượng kỹ thuật:** khoảng 6–10 ngày công để có MVP + tuning ban đầu, chưa tính thời gian giải quyết tương thích GPU/driver hoặc review store.

## 9. Benchmark và thiết bị chứng nhận

### Workloads
- W1: prompt mới 10–30 tokens, system ngắn, model warmed.
- W2: 100–200 prompt tokens, 2–3 lượt hội thoại.
- W3: ~512–1024 tokens lịch sử, warm context.
- W4: cold app start (đo riêng).
- W5: switch model và gửi ngay (đo riêng).
- W6: 20 lượt chat liên tục, máy nóng và pin đang dùng.

### Dữ liệu bắt buộc mỗi run
`device, chip, RAM, OS, model, quant, runtime version, backend, gpuLayers, threads, contextSize, currentContextTokens, promptTokens, outputTokens, warm/cold, TTFT_UI_ms, TTFT_engine_ms, prefill_ms, decode_tokens_per_sec, total_time_ms, load_time_ms, peak_RAM_MB, thermal_state, error`.

**Tiêu chuẩn:** chạy ≥20 warm requests trên mỗi tổ hợp chính, lấy P50/P95; không so sánh Android debug với iOS release. Benchmark chuẩn phải chạy release/profile trên thiết bị thật, không đánh giá GPU từ emulator.

### Quy tắc auto profile
- Lúc đầu mặc định Balanced (Qwen3 0.6B) nếu RAM đủ; máy yếu thì Fast (Gemma 270M).
- Profile thiết bị lưu lại config thắng A/B test cho từng model, thay vì một cấu hình chung.
- Cảnh báo model Quality có thể rất chậm trên thiết bị thiếu RAM; không tự tải model lớn.
- Nếu máy có lỗi Vulkan / OOM / nhiệt, fallback sang CPU và giảm context.

## 10. Rủi ro, đánh đổi và giải pháp

| Rủi ro | Biện pháp |
|---|---|
| TTFT > 500 ms trên máy yếu | Giảm model, context, prefill; chạy warmed; đo chân thực; thông báo giới hạn |
| Android Vulkan lỗi/ra text sai | Device allow-list sau benchmark; CPU fallback |
| iOS RAM kill app | Single-model; nhỏ context; giải phóng nhanh khi thiếu RAM |
| Chuyển model có độ trễ giây | Hiển thị Loading; đừng gộp switching vào warm TTFT |
| Model nhỏ trả lời tiếng Việt sai | Bộ test 30–50 prompt tiếng Việt, benchmark chất lượng song song tốc độ |
| Model chiếm ổ cứng | Download on demand; xoá riêng; loại file GGUF khỏi cloud backup |
| File tải lỗi | SHA256, resume, atomic rename; không load file .part |
| Thermal throttling | Benchmark warm dài và giới hạn tài nguyên |
| Chat cache không đúng giữa 2 model | Rebuild session; phân biệt lịch sử UI và KV session |
| Licenses riêng của model | Manifest license/source/attribution, audit trước release |

## 11. Definition of Done

- [ ] Có app Android/iOS với giao diện chat đơn giản, đẹp, mượt.
- [ ] Chọn 3 model trực tiếp từ chat; tải về/xoá/chuyển và streaming hoạt động.
- [ ] Offline hoàn toàn khi model đã tải; không phụ thuộc máy chủ.
- [ ] Có ít nhất 1 model đạt TTFT <500 ms P95 trong bài test **warm** trên thiết bị chứng nhận **hoặc** có benchmark minh bạch vì sao chưa đạt; không làm sai số đo.
- [ ] Có thời gian cold start và thời gian switch riêng.
- [ ] Không crash/OOM sau 100 lượt chat + 10 lượt switch model trên từng thiết bị thử nghiệm.
- [ ] Lịch sử còn khi restart; hiển thị lỗi hữu ích; model tải an toàn.
- [ ] Có build release được và tài liệu thiết lập + benchmark.

## 12. Tài liệu kỹ thuật gốc

- llama.cpp Android: https://github.com/ggml-org/llama.cpp/blob/master/docs/android.md
- llama.cpp caching: https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
- llamadart: https://github.com/leehack/llamadart
- llamadart performance: https://llamadart.leehack.com/docs/guides/performance-tuning
- llamadart chat session: https://llamadart.leehack.com/docs/getting-started/first-chat-session
- llamadart model lifecycle: https://llamadart.leehack.com/docs/guides/model-lifecycle
- Qwen3 GGUF: https://huggingface.co/Qwen/Qwen3-0.6B-GGUF
- Qwen3 Q4: https://huggingface.co/bartowski/Qwen_Qwen3-0.6B-GGUF
- Gemma 270M: https://developers.googleblog.com/en/introducing-gemma-3-270m/
