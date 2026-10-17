# Model manifest và giấy phép

Các URL dùng revision Hugging Face cố định thay vì `main`. Kích thước là số byte mong đợi; downloader yêu cầu kích thước và SHA-256 khớp trước khi đổi tên `.part` thành GGUF đã cài. Mọi mã hash bên dưới là SHA-256.

| Model | Tệp | Kích thước | Revision nguồn | SHA-256 | Điều khoản |
|---|---|---:|---|---|---|
| Gemma 3 270M Q4_K_M | `gemma-3-270m-it-q4_k_m.gguf` | 253,114,880 bytes | `0845b7e54ef2673cc691ab508e3ac6da7e392ad9` | `55aed1673d2f3014a739732c659c4995fc57abf6e4e9c68462fb2ceee820ea2f` | Gemma Terms of Use |
| Qwen3 0.6B Q4_K_M | `Qwen_Qwen3-0.6B-Q4_K_M.gguf` | 484,220,320 bytes | `60b85c0e3d8fe0f6474f406922a26d12aca4550d` | `9acfc1e001311f34b4252001b626f2e466d592a42065f66571bff3790d4e1b14` | Apache-2.0 |
| Qwen3 1.7B Q4_K_M | `Qwen_Qwen3-1.7B-Q4_K_M.gguf` | 1,282,439,584 bytes | `dcb19155b962dbb6389f4691a982043a8e651022` | `72c5c3cb38fa32d5256e2fe30d03e7a64c6c79e668ad84057e3bd66e250b24fb` | Apache-2.0 |

## Nguồn

- [Gemma 3 270M GGUF repository](https://huggingface.co/gguf-org/gemma-3-270m-it-gguf) · [Gemma Terms](https://ai.google.dev/gemma/terms)
- [Qwen3 0.6B GGUF repository](https://huggingface.co/bartowski/Qwen_Qwen3-0.6B-GGUF) · [Qwen3 0.6B license](https://huggingface.co/Qwen/Qwen3-0.6B/blob/main/LICENSE)
- [Qwen3 1.7B GGUF repository](https://huggingface.co/bartowski/Qwen_Qwen3-1.7B-GGUF) · [Qwen3 1.7B license](https://huggingface.co/Qwen/Qwen3-1.7B/blob/main/LICENSE)

Model cards and terms are third-party material. Review the applicable terms before distribution. Gemma is governed by Google's Gemma Terms rather than the Apache license. The app shows the model license name and opens its terms from the library and settings screens.

The canonical values live in [`model_catalog.dart`](../lib/core/config/model_catalog.dart). Update the pinned revision, file size, URL and digest together when changing a model artifact.
