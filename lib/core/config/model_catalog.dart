enum ModelTier { fast, balanced, quality }

enum ModelInstallStatus {
  notInstalled,
  downloading,
  installed,
  loading,
  warming,
  ready,
  generating,
  error,
}

class ModelManifestEntry {
  const ModelManifestEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.sourceUrl,
    required this.fileName,
    required this.sizeBytes,
    required this.sha256,
    required this.license,
    required this.licenseUrl,
    required this.quantization,
    required this.recommendedRamBytes,
    required this.contextSize,
    required this.supportsThinking,
    required this.tier,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String description;
  final String sourceUrl;
  final String fileName;
  final int sizeBytes;
  final String sha256;
  final String license;
  final String licenseUrl;
  final String quantization;
  final int recommendedRamBytes;
  final int contextSize;
  final bool supportsThinking;
  final ModelTier tier;
  final int sortOrder;

  String get formattedSize {
    final megabytes = sizeBytes / (1024 * 1024);
    if (megabytes >= 1024) return '${(megabytes / 1024).toStringAsFixed(2)} GB';
    return '${megabytes.round()} MB';
  }
}

const modelCatalog = <ModelManifestEntry>[
  ModelManifestEntry(
    id: 'gemma3-270m-q4',
    name: 'Gemma 3 270M',
    description: 'Phản hồi nhanh, phù hợp câu hỏi ngắn.',
    sourceUrl:
        'https://huggingface.co/gguf-org/gemma-3-270m-it-gguf/resolve/0845b7e54ef2673cc691ab508e3ac6da7e392ad9/gemma-3-270m-it-q4_k_m.gguf?download=true',
    fileName: 'gemma-3-270m-it-q4_k_m.gguf',
    sizeBytes: 253114880,
    sha256: '55aed1673d2f3014a739732c659c4995fc57abf6e4e9c68462fb2ceee820ea2f',
    license: 'Gemma Terms of Use',
    licenseUrl: 'https://ai.google.dev/gemma/terms',
    quantization: 'Q4_K_M',
    recommendedRamBytes: 2 * 1024 * 1024 * 1024,
    contextSize: 2048,
    supportsThinking: false,
    tier: ModelTier.fast,
    sortOrder: 0,
  ),
  ModelManifestEntry(
    id: 'qwen3-06b-q4',
    name: 'Qwen3 0.6B',
    description: 'Cân bằng giữa tốc độ và chất lượng. Model mặc định.',
    sourceUrl:
        'https://huggingface.co/bartowski/Qwen_Qwen3-0.6B-GGUF/resolve/60b85c0e3d8fe0f6474f406922a26d12aca4550d/Qwen_Qwen3-0.6B-Q4_K_M.gguf?download=true',
    fileName: 'Qwen_Qwen3-0.6B-Q4_K_M.gguf',
    sizeBytes: 484220320,
    sha256: '9acfc1e001311f34b4252001b626f2e466d592a42065f66571bff3790d4e1b14',
    license: 'Apache License 2.0',
    licenseUrl: 'https://huggingface.co/Qwen/Qwen3-0.6B/blob/main/LICENSE',
    quantization: 'Q4_K_M',
    recommendedRamBytes: 3 * 1024 * 1024 * 1024,
    contextSize: 2048,
    supportsThinking: true,
    tier: ModelTier.balanced,
    sortOrder: 1,
  ),
  ModelManifestEntry(
    id: 'qwen3-17b-q4',
    name: 'Qwen3 1.7B',
    description: 'Chất lượng cao hơn, cần nhiều bộ nhớ hơn.',
    sourceUrl:
        'https://huggingface.co/bartowski/Qwen_Qwen3-1.7B-GGUF/resolve/dcb19155b962dbb6389f4691a982043a8e651022/Qwen_Qwen3-1.7B-Q4_K_M.gguf?download=true',
    fileName: 'Qwen_Qwen3-1.7B-Q4_K_M.gguf',
    sizeBytes: 1282439584,
    sha256: '72c5c3cb38fa32d5256e2fe30d03e7a64c6c79e668ad84057e3bd66e250b24fb',
    license: 'Apache License 2.0',
    licenseUrl: 'https://huggingface.co/Qwen/Qwen3-1.7B/blob/main/LICENSE',
    quantization: 'Q4_K_M',
    recommendedRamBytes: 5 * 1024 * 1024 * 1024,
    contextSize: 2048,
    supportsThinking: true,
    tier: ModelTier.quality,
    sortOrder: 2,
  ),
];

ModelManifestEntry modelById(String id) =>
    modelCatalog.firstWhere((model) => model.id == id);
