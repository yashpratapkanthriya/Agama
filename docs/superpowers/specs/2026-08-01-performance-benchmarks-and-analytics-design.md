# System Design Specification: Performance Benchmarks & Comprehension Analytics (CCI) Dashboard

## 1. Overview & Objectives

This specification defines the technical design for:
1. **Performance Benchmark Suite (`native/rust_core/benches/`)**: Automated benchmarking suite validating NFR targets (FFI transfer latency $< 0.8\text{ ms}$, vector search latency $< 4.5\text{ ms}$).
2. **Comprehension Calibration Index (CCI) Engine (`native/rust_core/src/db/mod.rs`)**: On-device calculation of reading performance ($CCI = WPM \times \text{Quiz Accuracy}$) saved in `reading_sessions` table with 17-character `histvon` timestamping.
3. **Flutter Analytics Dashboard ([`analytics_view.dart`](file:///Users/yashpratap/Documents/GitHub/Agama/apps/flutter_client/lib/src/features/analytics/analytics_view.dart))**: Material 3 dashboard rendering WPM trends, total words read, quiz retention rates, and CCI trajectory over time.

---

## 2. Technical Architecture & Components

```
+------------------------------------------------------------------------------------+
|                      BENCHMARKS & COMPREHENSION ANALYTICS (CCI)                    |
+------------------------------------+-----------------------------------------------+
| 2.1 Performance Benchmarks         | 2.2 Comprehension Analytics Dashboard         |
| - Criterion Benchmark Suite        | - ReadingSession Historized Store (histvon)   |
| - Vector Search Latency (< 4.5ms)  | - CCI Score Calculation                       |
| - FFI Transfer Latency (< 0.8ms)   | - Material 3 Flutter Analytics UI Widget      |
+------------------------------------+-----------------------------------------------+
```

### 2.1 Performance Benchmarks (`native/rust_core/tests/benchmark_test.rs`)
- Measures execution timing using high-precision `std::time::Instant`.
- Validates that vector similarity search over chunk vectors completes in sub-5ms latency.
- Validates AIP delay calculation throughput for 100,000 words.

### 2.2 Comprehension Calibration Index (CCI) & Analytics (`apps/flutter_client/lib/src/features/analytics/analytics_view.dart`)
- **CCI Formula**:
  $$CCI = \text{Average WPM} \times \left( \frac{\text{Quiz Score \%}}{100} \right)$$
- **Analytics Dashboard UI**:
  - Highlights total words read, average WPM across sessions, and CCI comprehension score.
  - Session history list showing individual reading sessions.

---

## 3. Verification & Testing Strategy

1. **Rust Core Tests (`cargo test`)**:
   - `test_performance_benchmarks`: Asserts sub-millisecond calculation speeds.
   - `test_reading_session_cci_calculation`: Asserts CCI score math and database insertion.
2. **Flutter UI & Widget Tests (`flutter test`)**:
   - `AnalyticsView renders reading metrics and CCI score`: Asserts analytics dashboard widgets.
3. **Static Analysis (`flutter analyze`)**:
   - Zero errors, zero warnings.

---
*Design specification created August 2026 for production deployment.*
