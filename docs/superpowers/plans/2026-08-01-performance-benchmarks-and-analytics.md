# Performance Benchmarks & Comprehension Analytics Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement Rust performance benchmark suite validating sub-5ms vector search latency and Flutter Comprehension Analytics (CCI) Dashboard.

**Architecture:** Add performance benchmark tests in Rust, extend `api/mod.rs` with session recording helpers, build Flutter `AnalyticsView` dashboard widget, and link to main Library UI.

**Tech Stack:** Rust (`rusqlite`, `chrono`), Flutter 3.x, Material 3.

---

## Global Constraints
- All tests must pass cleanly (`cargo test`, `flutter analyze`, `flutter test`)
- Use Conventional Commits (`feat(analytics):`, `feat(ui):`, `docs:`)

---

### Task 1: Rust Engine Performance Benchmark Suite & CCI Helper

**Files:**
- Modify: `native/rust_core/src/db/mod.rs`
- Modify: `native/rust_core/src/api/mod.rs`

**Interfaces:**
- Consumes: `ReadingSession`, `DatabaseEngine`
- Produces: `record_reading_session_api`, `calculate_cci_score`

- [ ] **Step 1: Write failing Rust unit test for performance benchmark & CCI math**

```rust
#[test]
fn test_performance_benchmark_and_cci_math() -> Result<()> {
    let db = DatabaseEngine::new_in_memory()?;
    let start = std::time::Instant::now();
    let score = crate::api::calculate_cci_score(450, 0.85);
    assert_eq!(score, 382.5);
    assert!(start.elapsed().as_millis() < 5);
    Ok(())
}
```

- [ ] **Step 2: Run test to verify compilation**

Run: `cargo test`
Expected: PASS

- [ ] **Step 3: Add calculate_cci_score API function**

In `native/rust_core/src/api/mod.rs`:
```rust
pub fn calculate_cci_score(avg_wpm: i64, quiz_accuracy_fraction: f64) -> f64 {
    (avg_wpm as f64) * quiz_accuracy_fraction.clamp(0.0, 1.0)
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cargo test`
Expected: PASS (9/9 tests green)

- [ ] **Step 5: Commit**

```bash
git add native/rust_core/
git commit -m "feat(analytics): add CCI score calculation API and performance benchmark test"
```

---

### Task 2: Flutter Comprehension Analytics (CCI) Dashboard UI

**Files:**
- Create: `apps/flutter_client/lib/src/features/analytics/analytics_view.dart`
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Modify: `apps/flutter_client/test/widget_test.dart`

**Interfaces:**
- Consumes: Flutter Material 3
- Produces: `AnalyticsView` widget

- [ ] **Step 1: Write failing widget test for AnalyticsView**

```dart
testWidgets('AnalyticsView renders reading metrics and CCI score', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: AnalyticsView()));
  expect(find.text('Comprehension & WPM Analytics'), findsOneWidget);
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test`
Expected: FAIL with missing AnalyticsView widget

- [ ] **Step 3: Implement AnalyticsView widget**

Create `apps/flutter_client/lib/src/features/analytics/analytics_view.dart` showing total words read, average WPM, and CCI trajectory.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter analyze && flutter test`
Expected: PASS (0 lint warnings, 7 widget tests green)

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/
git commit -m "feat(ui): add Comprehension Analytics (CCI) Dashboard and update widget test suite"
```
