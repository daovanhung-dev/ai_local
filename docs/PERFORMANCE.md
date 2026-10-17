# Performance measurement

The app stores one local benchmark row after a completed generation, or an error row when inference fails. The Settings screen shows recent TTFT and whether the selected engine was already warm before the send.

## Metrics collected now

- **TTFT** starts when Send is invoked and stops on the first non-empty text delta. It represents time until text is pushed into the chat state, including model selection/load when the engine was cold.
- **Warm/cold** means whether this model was loaded and ready before Send. It is not the OS page-cache state.
- **Cold model load** is recorded separately from the chat turn when a model is loaded into an empty inference service. **Model switch** records the time from cancel/unload through new-model load, warmup and conversation restoration.
- **Decode tokens/s** is estimated from generated token count divided by elapsed time after TTFT.
- **Memory** is an RSS sample before and after generation; the stored value is the larger sample. It is not a sampled peak during native inference.
- **Thermal state** is read from the platform when available.
- **Prefill time** is not exposed by the locked runtime integration and is stored as null.

The database also stores backend, device identifier, prompt token count, warm flag, timestamp and any inference error. Load and switch durations are shown as separate rows in Settings; an initial model load has no switch duration. The UI does not calculate P50/P95. Prompt tokens are used as the context token estimate, so this should not be interpreted as the full cached session size.

## Reading results

Do not compare cold TTFT to the plan's warm TTFT target. The target (<350 ms P50 / <500 ms P95) applies only to warm runs on a defined, certified device list and is not a product guarantee. Before making a performance claim, capture repeated W1/W2/W3 turns on physical devices and calculate P50/P95 by model/backend/profile. Include OS, chipset, memory, runtime version, thermal condition and errors.

No certified device results are included with this MVP. Current environment has no connected Android device/AVD; iOS execution requires macOS and Xcode. The database is local and is not uploaded.
