# Agama UI Redesign Spec — "Scholarly Minimalist"

Date: 2026-08-02
Status: Approved Design Spec

---

## 1. Brand & Design System Architecture

The Agama design system is engineered for the **Scholarly Minimalist** speed reading experience. It prioritizes cognitive ease, academic rigor, and a distraction-free digital environment. The brand personality is intellectual, disciplined, and calm, targeting power readers and researchers who require maximum information density without visual fatigue.

The design style is **Minimalism** infused with **Tonal Layers**, avoiding unnecessary ornamentation and relying on precise typography and structural whitespace to guide the user's eye.

---

## 2. Color System & Design Tokens

```yaml
name: Scholarly Minimalist
colors:
  surface: '#f9f9ff'
  surface-dim: '#cfdaf1'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eeff'
  surface-container-high: '#dee8ff'
  surface-container-highest: '#d8e3fa'
  on-surface: '#111c2c'
  on-surface-variant: '#42484a'
  inverse-surface: '#263142'
  inverse-on-surface: '#ebf1ff'
  outline: '#73787a'
  outline-variant: '#c2c7ca'
  surface-tint: '#4d6169'
  primary: '#041920'
  on-primary: '#ffffff'
  primary-container: '#1a2e35'
  on-primary-container: '#81969e'
  inverse-primary: '#b4cad3'
  secondary: '#9d4300'
  on-secondary: '#ffffff'
  secondary-container: '#fd761a'
  on-secondary-container: '#5c2400'
  tertiary: '#151819'
  on-tertiary: '#ffffff'
  tertiary-container: '#292c2d'
  on-tertiary-container: '#919394'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d0e6ef'
  primary-fixed-dim: '#b4cad3'
  on-primary-fixed: '#091e25'
  on-primary-fixed-variant: '#364a51'
  secondary-fixed: '#ffdbca'
  secondary-fixed-dim: '#ffb690'
  on-secondary-fixed: '#341100'
  on-secondary-fixed-variant: '#783200'
  tertiary-fixed: '#e1e3e4'
  tertiary-fixed-dim: '#c5c7c8'
  on-tertiary-fixed: '#191c1d'
  on-tertiary-fixed-variant: '#454748'
  background: '#f9f9ff'
  on-background: '#111c2c'
  surface-variant: '#d8e3fa'
```

### Color Palette Roles
- **Primary (Deep Slate Navy):** `#1a2e35` / `#041920` — Used for primary text, active reading spotlight text, and core structural elements.
- **Secondary (Energetic Orange):** `#fd761a` / `#9d4300` — High-visibility accent color used for critical calls to action, active progress states, and ORP focus highlights.
- **Surface & Neutral:** Gradations of cool soft blues/grays (`#f9f9ff`, `#e7eeff`, `#d8e3fa`) creating a subtle hierarchy without the harshness of pure white/black.
- **Reading Environment Mode:** Warm ivory (`#FDFBF7`) or soft dark navy reading stage to reduce eye strain.

---

## 3. Typography Rules & Scales

```yaml
typography:
  display-reading:
    fontFamily: Literata
    fontSize: 40px
    fontWeight: '500'
    lineHeight: 56px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Source Serif 4
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-md:
    fontFamily: Source Serif 4
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Literata
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 30px
  body-md:
    fontFamily: Literata
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  stats-num:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
    letterSpacing: -0.02em
```

- **Headings & Titles**: `Source Serif 4` for authoritative, book-like presence.
- **Long-Form Reading**: `Literata` for long-form reading content (optimized x-height & exceptional legibility).
- **UI Labels & Metadata**: `Inter` for clean, functional UI counterpoint.

---

## 4. Spacing, Shapes & Layout Grid

```yaml
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 8px
  container-max: 800px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
  reading-padding: 40px
```

- **Reading Environment Layout**: Centered single-column layout with max width 800px; text never exceeds 70 characters per line.
- **Dashboard Grid**: 12-column grid with 24px gutters. Content cards span 4, 6, or 12 columns.
- **Elevation & Depth**: Tonal layers and 1px low-contrast outlines (`#c2c7ca` / `#73787a`). Active states use a soft diffused ambient shadow `0px 4px 20px rgba(26, 46, 53, 0.04)`.

---

## 5. Navigation & 4-Tab Architecture

### Top Header Bar
- **Left**: `[A] Agama` logo + view context label.
- **Center/Right**: `🔥 5-Day Streak · ⚡ 450 WPM` reading stats badge + Dark/Light Mode toggle.

### 4 Navigation Destinations
1. **Library Tab**: File drop zone, paste text input, Engine Chooser bento grid with live previews.
2. **Knowledge Tab**: Vector semantic highlight search & spaced-repetition flashcard trainer.
3. **Analytics Tab**: WPM velocity charts, daily reading time rings, comprehension heatmaps.
4. **User / Settings Tab**: Profile goals, Decentralized P2P sync management (`histvon`), engine defaults.

---

## 6. Component Specs

- **Buttons**: Primary buttons in solid Deep Slate (`#1a2e35`) with white text. High-priority action buttons in Energetic Orange (`#fd761a`). Minimum 48px hit target.
- **Cards**: Tonal surfaces with 1px border (`#c2c7ca`), generous 24px internal padding, no harsh shadows.
- **Speed Reader Controller**: Discrete slider with numeric label in `Inter`. Current word in speed reader highlighted with orange-tinted background (`#fd761a`) or soft underline.
- **Progress Indicators**: Thin 4px height bars with Energetic Orange progress fill (`#fd761a`).

---

## 7. Wireframes

```
+---------------------------------------------------------------------------------------------------+
| [A] Agama  |  READING STUDIO         🔥 5-Day Streak · ⚡ 450 WPM Avg        [☀️/🌙] [Quick Import +] |
+---------------------------------------------------------------------------------------------------+
|  [📖 Library]           [🔖 Knowledge]            [📊 Analytics]           [👤 User / Settings]   |
+---------------------------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------------------------+
| READING METHOD SELECTION                                                                          |
| +------------------------------+ +------------------------------+ +------------------------------+ |
| | ⚡ RSVP Redicle (Selected)   | | 📖 Guided Sweep              | | 🧠 Bionic Fixation         | |
| | [MAX SPEED] 400–1000+ WPM    | | [DEEP STUDY] 250–600 WPM   | | [FOCUS AID] 200–450 WPM    | |
| +------------------------------+ +------------------------------+ +------------------------------+ |
| | LIVE PREVIEW: [  speed  ] (Highlighted in Energetic Orange #fd761a)                            | |
| | [ ▶ START READING WITH RSVP ]                                                                  | |
| +-----------------------------------------------------------------------------------------------+ |
+---------------------------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------------------------+
| USER / SETTINGS & DECENTRALIZED SYNC BENTO GRID                                                   |
| +-----------------------------------------------+ +-----------------------------------------------+ |
| | 👤 USER PROFILE & GOALS                       | | 🔄 DECENTRALIZED SYNC (P2P NODE)             | |
| | Daily Target: 30 mins / day                   | | Status: ACTIVE  (histvon: 20260802124000)   | |
| | Current Streak: 🔥 5 Days                     | | Connected Devices: 2 (MacBook, iPad)        | |
| | [ ⚙️ Edit Goals ]                             | | [ ⚡ Trigger P2P Sync Now ]                  | |
| +-----------------------------------------------+ +-----------------------------------------------+ |
| | ⚙️ ENGINE DEFAULTS                             | | 📦 DATA & STORAGE MANAGEMENT                | |
| | Default Engine: RSVP Redicle                  | | Rust Engine Core: Embedded (Local)          | |
| | Default WPM: 450 WPM                          | | Vector Embeddings: 384-dim Index            | |
| | ORP Accent: Energetic Orange (#fd761a)       | | [ 📦 Export Highlights ]  [ 🗑️ Clear Cache ]   | |
| +-----------------------------------------------+ +-----------------------------------------------+ |
+---------------------------------------------------------------------------------------------------+
```
