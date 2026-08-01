---
name: Agama Platform Design System
description: High-craft, local-first speed reading & knowledge platform design specification
colors:
  primary: "#4f46e5"
  primary-light: "#eeedfff"
  emerald: "#059669"
  emerald-light: "#ecfdf5"
  crimson: "#ef4444"
  amber: "#d97706"
  rsvp-viewport: "#0a0d17"
  page-bg: "#f4f6fb"
  surface: "#ffffff"
  surface-variant: "#f0f2f8"
  ink: "#1c2033"
  ink-muted: "#5a6275"
  ink-faint: "#8c95a8"
  border: "#e4e7ef"
  border-strong: "#c8cede"
typography:
  display:
    fontFamily: "Outfit, -apple-system, sans-serif"
    fontSize: "36px"
    fontWeight: 800
    lineHeight: "1.15"
    letterSpacing: "-1.0px"
  title:
    fontFamily: "Outfit, -apple-system, sans-serif"
    fontSize: "18px"
    fontWeight: 700
    lineHeight: "1.3"
    letterSpacing: "-0.3px"
  body:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "15px"
    fontWeight: 400
    lineHeight: "1.65"
  mono:
    fontFamily: "JetBrains Mono, monospace"
    fontSize: "12px"
    fontWeight: 600
    lineHeight: "1.5"
rounded:
  sm: "8px"
  md: "10px"
  lg: "12px"
spacing:
  sm: "8px"
  md: "14px"
  lg: "20px"
  xl: "28px"
---

# Design System: Agama Platform

## Creative Direction

**Subject world:** Precision reading instruments — optometry charts, reading rulers, typographic specimens, lab measurement systems. The aesthetic is a focused research desk, not a product landing page.

**Not:** warm/cozy (no cream, no rounded-everything). **Is:** cool, precise, instrument-grade.

---

## Colors

### Page & Surface
| Token | Hex | Role |
|---|---|---|
| `page-bg` | `#F4F6FB` | Cool pearl — instrument precision |
| `surface` | `#FFFFFF` | Card surface |
| `surface-variant` | `#F0F2F8` | Input fill, chip background |

### Ink (Text)
| Token | Hex | Role |
|---|---|---|
| `ink` | `#1C2033` | Headings — ink blue-black |
| `ink-muted` | `#5A6275` | Body / secondary text |
| `ink-faint` | `#8C95A8` | Section labels, hints |

### Border
| Token | Hex | Role |
|---|---|---|
| `border` | `#E4E7EF` | Default hairline |
| `border-strong` | `#C8CEDE` | Focused/active state |

### Accents — each has a **single semantic role**
| Token | Hex | Role |
|---|---|---|
| `indigo` | `#4F46E5` | Primary action, selection |
| `indigo-light` | `#EEEDFF` | Hover tint, nav indicator |
| `emerald` | `#059669` | Speed, success, live status |
| `amber` | `#D97706` | Complexity, bionic mode |
| `crimson` | `#EF4444` | **ORP redicle only** — never decorative |

### RSVP Viewport
- Background: `#0A0D17` — ultra-dark for max word contrast during high-speed reading

### Named Rule: The Single Focus Rule
Crimson (`#EF4444`) is **reserved exclusively** for the ORP anchor letter. No other element uses crimson. This makes the redicle semantically unambiguous — the eye always knows what red means.

---

## Typography

**Display:** `Outfit` — geometric confidence, tight tracking at large sizes
**Body:** `Inter` — effortless legibility, 1.65 leading
**Mono:** `JetBrains Mono` — all numeric data (WPM, CCI, latency, progress %)

### Scale
| Style | Font | Size | Weight | Tracking | Use |
|---|---|---|---|---|---|
| displayLarge | Outfit | 36px | 800 | -1.0px | Page heroes |
| displayMedium | Outfit | 28px | 700 | -0.8px | Section headers |
| titleLarge | Outfit | 18px | 700 | -0.3px | Card titles |
| titleSmall | Outfit | 13px | 600 | 0 | Row labels |
| bodyLarge | Inter | 15px | 400 | — | Reading content |
| bodySmall | Inter | 12px | 400 | — | Meta / muted |
| labelLarge | JetBrains Mono | 12px | 700 | +0.6px | Metrics |
| labelSmall | JetBrains Mono | 10px | 500 | +0.3px | Section eyebrows |

---

## Layout

- **Navigation:** Persistent `NavigationBar` (bottom) — Library · Knowledge · Analytics
- **Max content width:** `960px` — constrained for readability on wide screens
- **Reading measure:** `680px` max for prose (Guided Sweep, Bionic Fixation)
- **Horizontal padding:** `20px` mobile, `24px` desktop
- **No sidebar** — bottom nav keeps one-handed mobile use

---

## Elevation & Depth

Flat by default. Borders over shadows.

- **Default card:** `1px solid #E4E7EF`, no shadow
- **Active/selected:** `1px solid accent.withAlpha(60)`, no shadow
- **Modal / sheet:** system bottom sheet with `16px` top radius
- **Never:** large drop shadows, heavy backdrop filters

---

## Shapes

- **Cards:** `12px` radius (tighter than before — more instrument, less balloon)
- **Buttons:** `9px` radius
- **Chips/badges:** `8px` radius
- **Nav indicator:** `12px` radius pill

---

## Components

### AppBar
- White surface with `1px` bottom border — no elevation
- Logo: `28×28` dark tile (`#0A0D17`) + crimson "A" in JetBrains Mono
- Live pulse: animated emerald dot + "local" label (not cloud latency number)

### Bottom Navigation
- `NavigationBar` height `62px`
- Indicator: `indigoLight` fill
- Always-show labels

### Engine Chooser (Library tab)
Three-tab selector (RSVP · Sweep · Bionic) with animated detail card below:
- Tab border color changes to engine accent when selected
- Detail card shows: tagline, WPM range badge, "best for" and "tradeoff" rows, CTA button

### RSVP Reader
- Context strip: 3 words before + 3 after current word — muted, prevents disorientation
- Dark viewport (`#0A0D17`) with crimson ORP anchor + guide ticks
- WPM guidance label below chips: "Good starting pace / Fast — check comprehension / Extreme"
- Keyboard: `Space` play/pause · `←→` step · `↑↓` ±50 WPM

### Document Tiles
- Format badge (PDF/EPUB/MD): `36×36`, accent-tinted
- Progress: `3px` track + % label in accent mono
- WPM avg: right-aligned mono

---

## Do's and Don'ts

### Do:
- Crimson = ORP anchor only. Period.
- JetBrains Mono for every number (WPM, %, ms, counts)
- Cool page background (`#F4F6FB`) not warm cream
- 12px border radius for cards, not 16px

### Don't:
- Don't use warm backgrounds (no `#FAF8F4`, no `#FFF8F0`)
- Don't decorate with crimson — it must always mean "fixation point"
- Don't use sidebar nav — bottom nav only
- Don't show SnackBar for actions that should navigate somewhere
