---
name: Agama Platform Design System
description: High-craft, local-first speed reading & knowledge platform design specification
colors:
  primary: "#6366f1"
  primary-hover: "#4f46e5"
  primary-light: "#eeefff"
  emerald: "#10b981"
  emerald-light: "#ecfdf5"
  crimson: "#ef4444"
  amber: "#f59e0b"
  redicle-viewport: "#090d16"
  neutral-bg: "#f8fafc"
  surface: "#ffffff"
  text-main: "#0f172a"
  text-muted: "#64748b"
  border: "#e2e8f0"
typography:
  display:
    fontFamily: "Outfit, -apple-system, sans-serif"
    fontSize: "32px"
    fontWeight: 800
    lineHeight: "1.2"
    letterSpacing: "-0.8px"
  title:
    fontFamily: "Outfit, -apple-system, sans-serif"
    fontSize: "18px"
    fontWeight: 700
    lineHeight: "1.3"
    letterSpacing: "-0.4px"
  body:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: "1.6"
    letterSpacing: "normal"
  label:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "12px"
    fontWeight: 700
    lineHeight: "1.3"
    letterSpacing: "0.8px"
  mono:
    fontFamily: "JetBrains Mono, monospace"
    fontSize: "14px"
    fontWeight: 500
    lineHeight: "1.5"
rounded:
  sm: "6px"
  md: "10px"
  lg: "16px"
spacing:
  sm: "8px"
  md: "16px"
  lg: "24px"
  xl: "32px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "#ffffff"
    rounded: "{rounded.md}"
    padding: "12px 24px"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
  card-container:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.lg}"
    padding: "28px"
---

# Design System: Agama Platform

## Overview

**Creative North Star: "The Precision Speed Reading Sanctuary"**

The Agama design system balances high-throughput visual speed reading efficiency with intentional, serene readability. Engineered with a crisp, light alabaster palette (`#f8fafc`), deep slate typography (`#0f172a`), vibrant indigo primary accents (`#6366f1`), and crimson ORP focus redicles (`#ef4444`), the interface minimizes visual noise while keeping reader focus anchored at 600+ WPM.

**Key Characteristics:**
- **Crisp High-Contrast Light Mode**: Clean white cards layered over alabaster background with hairline slate borders (`#e2e8f0`).
- **Optimal Recognition Point (ORP) Redicle Focus**: Vibrant crimson visual anchor positioning eyes at 35% word prefix.
- **Expressive Geometric Typography**: Pairing `Outfit` display headings with `Inter` body prose and `JetBrains Mono` telemetry metrics.

## Colors

The palette uses high-contrast light neutrals with purposeful functional accents.

### Primary
- **Indigo Accent** (`#6366f1`): Used for primary action buttons, active tab states, and key interactive controls.
- **Indigo Hover** (`#4f46e5`): Hover state for primary buttons.
- **Indigo Light Tint** (`#eeefff`): Background tint for active navigation items and highlighted chips.

### Secondary
- **Emerald Speed Green** (`#10b981`): Represents high-speed metrics, optimal CCI calibration zones, and success indicators.
- **Emerald Light Tint** (`#ecfdf5`): Background fill for success cards and active recall score chips.

### Functional & Focus
- **Crimson ORP Anchor** (`#ef4444`): Dedicated color for the Optimal Recognition Point (ORP) letter in the speed reader redicle.
- **Amber Warning** (`#f59e0b`): Outbox sync alerts and pending CRDT operations.

### Neutral
- **Page Background** (`#f8fafc`): Crisp alabaster surface for main viewports.
- **Card Surface** (`#ffffff`): Pure white elevated card surfaces.
- **Main Text** (`#0f172a`): High-contrast deep slate for primary headings and body copy.
- **Muted Text** (`#64748b`): Cool muted slate for secondary labels, eyebrows, and subtitles.
- **Border / Divider** (`#e2e8f0`): Hairline border stroke for cards and dividers.

### Named Rules
**The Single Focus Rule.** Primary accent and crimson redicle highlights are reserved strictly for active reader focus and primary call-to-action buttons. No more than 10% of any viewport contains accent saturation.

## Typography

**Display Font:** `Outfit` (with `-apple-system, BlinkMacSystemFont, sans-serif`)
**Body Font:** `Inter` (with `-apple-system, BlinkMacSystemFont, sans-serif`)
**Label/Mono Font:** `JetBrains Mono` (with `monospace`)

**Character:** Geometric confidence in display titles paired with effortless, highly-legible body prose and crisp monospace telemetry metrics.

### Hierarchy
- **Display** (`800 weight`, `32px/38px`, `letter-spacing -0.8px`): Page hero headers and section titles.
- **Title** (`700 weight`, `18px/24px`, `letter-spacing -0.4px`): Card titles and feature headings.
- **Body** (`400 weight`, `16px/1.6 line-height`): Reader prose, description paragraphs, and manual content.
- **Label** (`700 weight`, `12px/1.3`, `letter-spacing 0.8px`, uppercase): Section eyebrows, badge text, and metric card labels.
- **Mono** (`500 weight`, `14px/1.5`): WPM speed counters, CCI calculated scores, and SQL snippets.

## Layout

- **Sidebar Navigation**: Fixed 290px width sidebar on desktop viewports.
- **Main Viewport**: Fluid container max-width 1040px with 40px top/bottom and 60px horizontal padding.
- **Grid Density**: Responsive 3-column metric cards (`minmax(220px, 1fr)`).

## Elevation & Depth

Surfaces rely primarily on clean tonal contrast and subtle hairline borders (`1px solid #e2e8f0`) rather than heavy drop shadows.

### Shadow Vocabulary
- **Subtle Elevation** (`box-shadow: 0 4px 20px -2px rgba(15, 23, 42, 0.05)`): Default card rest elevation.
- **Card Hover** (`box-shadow: 0 10px 30px -4px rgba(15, 23, 42, 0.08)`): Active hover elevation.

### Named Rules
**The Flat-Border First Rule.** Surfaces rely on hairline slate borders and tonal background separation at rest. Soft ambient shadows appear only on card hover and floating modal dialogs.

## Shapes

- **Card Radius**: `16px` border-radius for main content cards.
- **Control Radius**: `10px` to `12px` border-radius for buttons, inputs, and sliders.
- **Badge Radius**: `20px` pill radius for metric tags and status chips.

## Components

### Buttons
- **Shape:** `10px` rounded corners.
- **Primary:** Background `#6366f1`, text `#ffffff`, padding `12px 24px`.
- **Hover:** Background `#4f46e5`, subtle -1px vertical transform.

### Cards / Containers
- **Corner Style:** `16px` border-radius.
- **Background:** `#ffffff` pure white.
- **Border:** `1px solid #e2e8f0`.
- **Padding:** `28px` internal padding.

### RSVP Redicle Box
- **Background:** `#090d16` ultra-dark viewport for maximum visual contrast during high-speed reading.
- **Text Color:** `#ffffff` prefix/suffix with `#ef4444` crimson ORP center anchor letter.

## Do's and Don'ts

### Do:
- **Do** maintain crisp high contrast between deep slate text (`#0f172a`) and alabaster/white backgrounds.
- **Do** highlight the 35% word prefix ORP letter in crimson (`#ef4444`) during RSVP speed reading.
- **Do** use `JetBrains Mono` for telemetry values (WPM, latency, CCI scores).

### Don't:
- **Don't** clutter the reading viewport with decorative drop shadows or saturated background gradients.
- **Don't** use dark grey body text that fails WCAG AA contrast standards against light backgrounds.
- **Don't** use generic default system fonts when `Outfit` and `Inter` font stacks are specified.
