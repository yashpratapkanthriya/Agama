---
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
---

## Brand & Style
The design system is engineered for the "Scholarly Minimalist" speed reading experience. It prioritizes cognitive ease, academic rigor, and a distraction-free digital environment. The brand personality is intellectual, disciplined, and calm, targeting power readers and researchers who require maximum information density without visual fatigue.

The design style is **Minimalism** infused with **Tonal Layers**. It avoids unnecessary ornamentation, relying on precise typography and structural whitespace to guide the user's eye. The emotional response is one of "focused flow"—where the UI recedes to allow the content to become the primary interface.

## Colors
The palette is built on a foundation of "Soft Whites" to reduce screen glare during long reading sessions. 
- **Primary (Deep Slate):** (#1a2e35) Used for primary text and core structural elements to ensure maximum contrast and legibility.
- **Secondary (Energetic Orange):** (#f97316) A high-visibility accent color used for critical calls to action, active progress states, and essential interactive highlights to provide a warm, energetic contrast to the cool primary tones.
- **Surface & Neutral:** Gradations of cool grays (based on #4a5568) and off-whites create a subtle hierarchy of information containers without the harshness of pure black-on-white.
- **Reading Mode:** In the active reading state, the background should shift to a warm ivory (#FDFBF7) to further reduce eye strain.

## Typography
Typography is the core of this design system. We utilize **Source Serif 4** for high-level headings to provide an authoritative, book-like feel. **Literata** is used for all long-form reading content due to its optimized x-height and exceptional legibility on digital screens.

**Inter** provides a functional, neutral counterpoint for UI labels, metadata, and data visualization, ensuring that secondary information does not compete with the reading material. 

*   **Reading Environment:** Text should never exceed 70 characters per line.
*   **Vertical Rhythm:** Maintain strict adherence to a baseline grid to ensure a stable visual experience during rapid eye movement.

## Layout & Spacing
The system employs a **Fixed Grid** for the reading experience and a **Fluid Grid** for the dashboard and statistics views.

- **Reading View:** Centered single-column layout with a maximum width of 800px to prevent excessive horizontal eye travel. Large vertical margins (64px+) help isolate the text.
- **Dashboard:** A 12-column grid with 24px gutters. Content cards should span 4, 6, or 12 columns.
- **Mobile:** Margins scale down to 16px, but line height and internal padding within text blocks remain generous to maintain the "breathable" feel.

## Elevation & Depth
This design system avoids heavy shadows, instead using **Tonal Layers** and **Low-contrast Outlines**. 

- **Level 0 (Background):** Primary white/off-white surface.
- **Level 1 (Containers):** Subtle gray backgrounds or 1px borders in a soft neutral.
- **Level 2 (Active States):** Elevated elements use a very soft, highly diffused ambient shadow (0px 4px 20px rgba(26, 46, 53, 0.04)).
- **Interactive Depth:** Buttons and interactive cards do not "lift" on hover; instead, they shift in background tone or border weight to remain grounded and "print-like."

## Shapes
The shape language is **Soft**. Sharp corners are avoided to keep the interface approachable, but large radii are rejected to maintain a serious, academic aesthetic. 

- **Default (0.25rem):** Buttons, input fields, and small UI components.
- **Large (0.5rem):** Article cards, modal containers, and data visualization backgrounds.
- **Pill:** Reserved exclusively for "Progress" indicators and "Status" tags to provide a distinct visual contrast from functional buttons.

## Components
- **Buttons:** Primary buttons are solid Deep Slate (#1a2e35) with white text. Secondary buttons use an Energetic Orange (#f97316) outline or solid fill for high-priority actions. Use minimum 48px hit targets for accessibility.
- **Cards:** White surfaces with a 1px border. No shadows. Content within cards should have generous internal padding (24px).
- **Input Fields:** Minimalist style. Bottom-border only for a "notebook" feel, or a light-gray solid fill with 4px rounded corners.
- **Data Visualization:** Use the Energetic Orange for primary data points that require attention. Use light-gray fills for background bars or secondary data. Lines should be thin (1.5px - 2px) and precise.
- **Progress Bars:** Thin, 4px height bars. The background is a very light tint of the primary color, while the progress fill is the Energetic Orange.
- **Reading Speed Controller:** A discrete slider with a numeric label in Inter. The "current word" in the speed reader should be highlighted with a soft underline or a subtle orange-tinted background.