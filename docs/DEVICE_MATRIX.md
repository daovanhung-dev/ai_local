# Device validation matrix

No phone or emulator was available in the implementation environment, so no device is marked as certified. Fill one row for each physical device before using benchmark results as a release claim.

| Platform / device | Chipset | RAM | OS | Model / backend | Airplane mode | 20-turn stability | Thermal / OOM | Result |
|---|---|---:|---|---|---|---|---|---|
| Not tested | — | — | — | — | — | — | — | Pending physical-device validation |

## Recommended validation

1. Install one model with network access; verify the downloader completes and stores the pinned size and digest.
2. Enable airplane mode, force stop and relaunch the app, reopen the conversation, and generate another reply.
3. Repeat interrupted download/resume, checksum mismatch, low-storage and cancellation cases using controlled test files or a test server.
4. Run at least 20 turns per profile and model. Record cold load, warm TTFT, switching duration, output tokens/s, RSS, thermal state, crashes and OOMs separately.
5. Repeat after the device warms up and after app background/foreground transitions.

For Android, the release APK targets `arm64-v8a`; the current runtime baseline uses CPU. Vulkan remains disabled pending device/driver validation. iOS uses the Metal backend and requires deployment target 16.4 or newer.
