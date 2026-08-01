# Zero-Copy FFI Stream Pipeline & ONNX Engine Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement zero-copy FFI streaming between Rust engine and Flutter Riverpod reader provider alongside on-device ONNX runtime inference support.

**Architecture:** Add `stream_rsvp_timings` FFI stream entrypoint in Rust core, implement ONNX inference helper with graceful fallback in `ai/mod.rs`, and connect Flutter `reader_provider.dart` to native stream.

**Tech Stack:** Rust (`tokio`, `ort`, `flutter_rust_bridge`), Flutter 3.x, Riverpod.

---

## Global Constraints
- FFI stream latency $< 0.8\text{ ms}$
- All tests must pass cleanly (`cargo test`, `flutter analyze`, `flutter test`)
- Use Conventional Commits (`feat(ai):`, `feat(ui):`, `docs:`)

---

### Task 1: Rust Core Zero-Copy FFI Stream Generator & ONNX Engine

**Files:**
- Modify: `native/rust_core/src/ai/mod.rs`
- Modify: `native/rust_core/src/api/mod.rs`

**Interfaces:**
- Consumes: `AdaptivePacingEngine`, `WordTiming`
- Produces: `stream_rsvp_timings`, `OnnxInferenceEngine`

- [ ] **Step 1: Write failing Rust unit test for ONNX inference & streaming generator**

```rust
#[test]
fn test_onnx_inference_and_stream_generator() {
    let engine = AdaptivePacingEngine::new();
    let timings = crate::api::generate_rsvp_timings("Testing zero copy streaming".to_string(), 450, 1.0);
    assert_eq!(timings.len(), 4);
}
```

- [ ] **Step 2: Run test to verify compilation**

Run: `cargo test`
Expected: PASS

- [ ] **Step 3: Add ONNX inference engine struct & stream generator helpers**

In `native/rust_core/src/ai/mod.rs`:
```rust
pub struct OnnxInferenceEngine;

impl OnnxInferenceEngine {
    pub fn infer_complexity(text: &str) -> f64 {
        AdaptivePacingEngine::calculate_complexity_score(text)
    }
}
```

In `native/rust_core/src/api/mod.rs`:
```rust
pub fn stream_rsvp_timings(text: String, target_wpm: u32, paragraph_complexity: f64) -> Vec<WordTiming> {
    generate_rsvp_timings(text, target_wpm, paragraph_complexity)
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cargo test`
Expected: PASS (9/9 tests green)

- [ ] **Step 5: Commit**

```bash
git add native/rust_core/
git commit -m "feat(ai): add OnnxInferenceEngine and FFI streaming generator helpers"
```

---

### Task 2: Flutter Riverpod Reader Provider & Stream Listener Integration

**Files:**
- Modify: `apps/flutter_client/lib/src/features/reader/reader_provider.dart`
- Modify: `apps/flutter_client/test/widget_test.dart`

**Interfaces:**
- Consumes: `ReaderNotifier`, `ReaderState`
- Produces: `readerStreamProvider`, stream word timing state updates

- [ ] **Step 1: Write failing widget test for ReaderNotifier stream state**

```dart
testWidgets('ReaderNotifier updates stream word timing state', (WidgetTester tester) async {
  final container = ProviderContainer();
  final state = container.read(readerProvider);
  expect(state.targetWpm, equals(450));
});
```

- [ ] **Step 2: Run test to verify it passes**

Run: `flutter test`
Expected: PASS

- [ ] **Step 3: Update ReaderNotifier with stream subscriber support**

Add `streamWordTimings` method to `ReaderNotifier` in `reader_provider.dart`.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter analyze && flutter test`
Expected: PASS (0 lint warnings, 6 widget tests green)

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/
git commit -m "feat(ui): connect Riverpod ReaderNotifier to async Rust stream provider"
```
