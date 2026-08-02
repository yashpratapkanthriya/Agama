---
name: Scholarly Minimalist
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#45464d'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#76777d'
  outline-variant: '#c6c6cd'
  surface-tint: '#565e74'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#131b2e'
  on-primary-container: '#7c839b'
  inverse-primary: '#bec6e0'
  secondary: '#9d4300'
  on-secondary: '#ffffff'
  secondary-container: '#fd761a'
  on-secondary-container: '#5c2400'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#191c1e'
  on-tertiary-container: '#818486'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#ffdbca'
  secondary-fixed-dim: '#ffb690'
  on-secondary-fixed: '#341100'
  on-secondary-fixed-variant: '#783200'
  tertiary-fixed: '#e0e3e5'
  tertiary-fixed-dim: '#c4c7c9'
  on-tertiary-fixed: '#191c1e'
  on-tertiary-fixed-variant: '#444749'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-reading:
    fontFamily: Source Serif 4
    fontSize: 24px
    fontWeight: '400'
    lineHeight: 36px
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-main:
    fontFamily: Source Serif 4
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-sm:
    fontFamily: Source Serif 4
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-caps:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
  ui-button:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  reading-margin-desktop: 120px
  reading-margin-mobile: 20px
  gutter: 24px
  stack-sm: 12px
  stack-md: 24px
  stack-lg: 48px
---

## Brand & Style
The design system focuses on the intersection of academic rigor and modern speed-reading technology. The brand personality is disciplined, intellectual, and serene, aiming to reduce cognitive load and facilitate "deep work" reading sessions.

The design style utilizes **Modern Minimalism** with a focus on high-quality typography and intentional whitespace. It incorporates elements of **Tonal Layering** to create a structured environment where the content—the text—remains the undisputed hero. The interface should feel like a premium digital library: quiet, organized, and profoundly functional.

## Colors
The palette is engineered for prolonged visual comfort and focus. 

- **Primary (Deep Navy):** Used for primary text, iconography, and structural UI elements. It provides the "weight" of a physical book.
- **Secondary (Focus Orange):** Reserved exclusively for speed-reading highlights, progress indicators, and primary calls to action. Its high energy is used to direct the eye without overwhelming the page.
- **Tertiary (Soft White):** The background color for the reading canvas, slightly warmed to reduce blue-light strain compared to pure white.
- **Neutral (Steel Gray):** Used for secondary metadata, borders, and inactive states.

## Typography
This design system employs a dual-font strategy to separate content from navigation.

- **Reading Experience:** Uses **Source Serif 4**. This face is chosen for its exceptional legibility in long-form prose and its authoritative, academic tone. Line heights are generous (1.5x - 1.6x) to prevent "line-skipping" during fast reading.
- **Interface & UI:** Uses **Hanken Grotesk**. A contemporary sans-serif that remains neutral and functional, ensuring the user interface feels modern and precise.
- **Focus States:** When speed-reading modes are active, letter-spacing should remain neutral to maintain word-shape recognition.

## Layout & Spacing
The layout follows a **Fixed Grid** philosophy for the reading experience to ensure optimal line lengths (60-75 characters per line), which is critical for reading speed and comprehension.

- **Desktop:** A centralized reading column with wide margins to eliminate peripheral distractions.
- **Mobile:** Content expands to fill the width with a safe 20px margin.
- **Rhythm:** An 8px base unit governs all spacing. Vertical rhythm in the reading view is strictly tied to the line-height of the body text to maintain a cohesive flow.

## Elevation & Depth
Depth is signaled through **Tonal Layers** rather than heavy shadows. The background is the lowest level (Tertiary). Cards and navigation elements sit one level above, distinguished by a subtle change in brightness or a very fine 1px border.

Where shadows are used (e.g., for floating action buttons or active book covers), they are **Ambient Shadows**: extremely diffused (20px+ blur), low opacity (5-8%), and tinted with the Primary Deep Navy to feel integrated into the environment.

## Shapes
The shape language is **Rounded**, conveying an approachable and humanistic feel that balances the "sharpness" of academic study. 

- **Standard Elements:** (Buttons, Input Fields) use a 0.5rem radius.
- **Book Covers:** In the library view, covers should use `rounded-lg` (1rem) to mimic the soft edges of a physical book spine.
- **Interactive Highlighting:** Selection boxes for text should be slightly rounded (2px) to feel less clinical than standard rectangular cursors.

## Components
- **Buttons:** Primary buttons use the Deep Navy fill with white text. Secondary buttons use a ghost style with a 1px Navy border.
- **Speed-Reading Highlight:** A unique component that places a Soft Orange underline or background tint behind a single word. The "focus point" (center of the word) may be slightly bolded.
- **Library Cards:** Minimalist tiles displaying a book cover, title in Hanken Grotesk, and a subtle progress bar in Focus Orange at the bottom.
- **Control Trays:** Bottom-aligned sheets for font and speed adjustments, using a semi-transparent blur (Glassmorphism) to maintain context of the text behind them.
- **Progress Indicators:** Thin, horizontal lines at the top of the reading view, utilizing the Focus Orange for the "filled" state.
- **Checkboxes/Radios:** Circular and minimalist, using the Primary color for checked states to avoid visual clutter.