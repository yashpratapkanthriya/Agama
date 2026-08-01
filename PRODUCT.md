# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Stack

Flutter 3.22+ Material 3 shell with embedded Rust core engine (compiled to WASM / C-FFI via flutter_rust_bridge v2)

## Users

Speed readers, researchers, and knowledge workers reading long-form technical PDFs, EPUBs, and articles offline in high-focus environments.

## Product Purpose

Provide a 100% zero-backend, privacy-first speed reading and knowledge retention platform that helps users digest dense documents faster with zero latency and high retention.

## Positioning

Zero-backend, local-first speed reading platform combining sub-millisecond adaptive Pacing Engine (RSVP, Optimal Recognition Point, Bionic Fixation) with SQLCipher + sqlite-vec local vector memory and SM-2 flashcard recall.

## Operating Context

Offline, distraction-free reading sessions across desktop (macOS/Linux/Windows) and mobile/web devices. High-throughput document ingestion (PDF, EPUB, Markdown, HTML) without sending data to cloud servers.

## Capabilities and Constraints

- Capabilities:
  - Multi-mode speed reader (Adaptive Pacing RSVP, Bionic Fixation, Guided Highlighting, ORP redicle styling).
  - Embedded ONNX complexity analyzer and local vector search (`sqlite-vec`).
  - SM-2 spaced-repetition flashcards generated from annotations.
  - Bi-directional CRDT document/note sync via embedded Yrs engine.
- Constraints:
  - 100% Zero-Backend requirement (all compute, storage, and ML models execute locally in-process).
  - Bi-temporal database schema (`histvon` / `histbis`) for non-destructive data versioning.

## Brand Commitments

- Name: Agama
- Identity: Minimalist, ultra-responsive, focused reading workspace emphasizing readability, typographic precision, and high-performance ergonomics.

## Evidence on Hand

- Rust core engine: `native/rust_core` (AIP pacing, ONNX, ORP, SQLCipher, Yrs CRDT).
- Flutter UI app: `apps/flutter_client` (Material 3 UI, RSVP controller, Bionic fixator).
- Documentation: `docs/SAD.md`, `docs/schema.md`, `docs/decentralized_sync_architecture.md`.

## Product Principles

1. Zero Latency, Zero Cloud: Everything computes locally in-process with 0ms server dependence.
2. Typographic Precision: Every micro-interaction, font weight, and redicle alignment serves reading velocity and focus.
3. Non-Destructive Memory: Historical annotations, documents, and revisions are preserved using bi-temporal versioning.
4. Distraction-Free Flow: High-density information display with zero clutter or visual noise.

## Accessibility & Inclusion

- Support customizable RSVP speed controls (WPM), high contrast ORP redicle colors, dynamic font sizing, and full keyboard navigation shortcuts for desktop/web.
