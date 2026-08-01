---
target: docs/internal_manual.html
total_score: 30
max_score: 40
na_heuristics: ""
p0_count: 2
p1_count: 2
p2_count: 1
p3_count: 0
generated_at: 2026-08-01T14:50:48Z
---

# Impeccable Design Critique Snapshot: Agama Internal Manual

Method: dual-agent (A: df2185c9-9360-4ffc-b981-ef4161ff9024 · B: 91fecc68-1447-4337-9658-eff70a03fc65)

## Design Health Score

| # | Heuristic | Score | Key Issue / Observation |
|---|-----------|:---:|---|
| 1 | Visibility of System Status | 4/4 | Synchronous RSVP word updates, monospace telemetry, and play/pause state feedback. |
| 2 | Match System / Real World | 4/4 | Direct speed reading domain vocabulary (ORP 35%, RSVP, Bionic Fixation, SM-2 recall). |
| 3 | User Control and Freedom | 3/4 | Smooth tab switching and continuous WPM sliders; lacks one-click simulator reset. |
| 4 | Consistency and Standards | 4/4 | Clean token alignment with `DESIGN.md` light theme colors, fonts, and card surfaces. |
| 5 | Error Prevention | 2/4 | Sliders prevent out-of-bound values, but numeric input fields lack min/max validation. |
| 6 | Recognition Rather Than Recall | 4/4 | In-place live previews and visible formula labels ($CCI = WPM \times Accuracy$). |
| 7 | Flexibility and Efficiency | 2/4 | Lacks keyboard shortcuts (`Space` to play/pause, `↑/↓` for WPM, `1-8` for tab navigation). |
| 8 | Aesthetic and Minimalist Design | 4/4 | Minimalist alabaster aesthetic adhering to "The Single Focus Rule" (<10% accent saturation). |
| 9 | Error Recovery | 2/4 | Empty queries handle search fallbacks, but invalid numbers yield raw `NaN` values. |
| 10 | Help and Documentation | 3/4 | Comprehensive inline architecture NFRs, use cases, and code snippets. |
| **Total** | | **30/40** | **Good (Solid Foundation, Accessibility & Keyboard Gaps)** |

---

## Design Specificity Verdict

- **LLM Assessment (Assessment A)**: Highly authentic to the speed reading domain. The RSVP redicle box with 35% ORP crimson anchor, Bionic Fixation $F1\dots F5$ bolding sandbox, and CCI calculator directly express the core platform capabilities.
- **Deterministic Scan (Assessment B)**:
  - **2 Warnings**: 1 marketing buzzword (`"enterprise-grade"` on L449), 1 saturated indigo shadow glow (`rgba(99, 102, 241, ...)` on L83/L267).
  - **20 Advisories**: 11 off-scale font sizes, 9 off-scale border-radii diverging from `DESIGN.md` scale steps (`6px`/`10px`/`16px`).

---

## Overall Impression

A visually polished, highly relevant light-themed interactive manual. The light alabaster cards, geometric typography (`Outfit`/`Inter`/`JetBrains Mono`), and live feature sandboxes elevate internal documentation. However, critical accessibility gaps (non-semantic `<div>` navigation, missing ARIA labels) and a lack of keyboard shortcuts prevent it from feeling fully production-grade.

---

## Priority Issues

1. **[P0] Accessibility: Non-Semantic Navigation Blocks Screen Readers & Keyboard Focus**
   - **Why it matters**: Sidebar tabs use `<div class="nav-item" onclick="...">` without `role="tab"`, `tabindex="0"`, or `onkeydown` listeners. Keyboard-only and screen reader users cannot focus or switch tabs.
   - **Fix**: Convert navigation to `<nav role="tablist">`, add `role="tab"`, `tabindex="0"`, `aria-selected`, and `onkeydown` (Enter/Space) handlers. Replace `<sidebar>` with `<aside>`.
   - **Suggested Command**: `/impeccable adapt`

2. **[P0] Accessibility: Form Controls Missing Accessible Labels**
   - **Why it matters**: Range sliders (`#wpm-slider`, `#bionic-slider`), numeric inputs (`#cci-wpm`, `#cci-acc`), and search field (`#vector-query`) lack `<label>` associations or `aria-label` tags.
   - **Fix**: Add explicit `aria-label` attributes to all form controls and sliders.
   - **Suggested Command**: `/impeccable audit`

3. **[P1] Power User UX: Missing Global Keyboard Shortcuts**
   - **Why it matters**: Speed readers and dev power users expect `Space` (Play/Pause), `ArrowUp/Down` (WPM ±25), and `1-8` (Tab navigation) shortcuts.
   - **Fix**: Add a global `keydown` event listener mapping keyboard shortcuts to simulator functions.
   - **Suggested Command**: `/impeccable polish`

4. **[P1] Visual Slop: Marketing Buzzword & Saturated Glow Shadows**
   - **Why it matters**: `"enterprise-grade"` reads like generic SaaS marketing slop; saturated indigo shadow glows (`rgba(99, 102, 241, 0.35)`) violate **The Flat-Border First Rule** in `DESIGN.md`.
   - **Fix**: Remove `"enterprise-grade "` on L449; replace indigo shadow glows on L83 and L267 with standard slate ambient shadows `box-shadow: var(--shadow-subtle)`.
   - **Suggested Command**: `/impeccable clarify`

5. **[P2] Token Hygiene: Off-Scale Font Sizes and Border Radii**
   - **Why it matters**: 20 inline CSS declarations use ad-hoc pixel values (`11px`, `13px`, `15px`, `8px`, `12px`, `14px`) rather than exact `DESIGN.md` token scale steps.
   - **Fix**: Standardize border radii to `6px`, `10px`, or `16px` and font sizes to `12px`, `14px`, `16px`, `18px`, or `32px`.
   - **Suggested Command**: `/impeccable layout`

---

## Persona Red Flags

- **Alex (Power User)**: No keyboard shortcuts. WPM slider capped at 900 WPM with coarse 50 WPM steps. Cannot paste custom text snippets into the RSVP simulator.
- **Jordan (First-Timer)**: Unexplained technical jargon (*Yrs CRDT state vectors*, *SQLCipher historization*). Missing one-click speed presets (e.g. 250 WPM Warmup, 450 WPM Pacing).
- **Sam (Accessibility User)**: Keyboard tab navigation completely broken due to `<div class="nav-item">`. Unlabeled sliders. Crimson ORP anchor letter (`#ef4444`) lacks high-contrast underline/tick indicator for colorblind users. Lacks `@media (prefers-reduced-motion: reduce)`.
