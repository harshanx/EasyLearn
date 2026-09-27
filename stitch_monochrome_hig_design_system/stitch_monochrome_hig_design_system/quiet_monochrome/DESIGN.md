---
name: Quiet Monochrome
colors:
  surface: '#f9f9fb'
  surface-dim: '#d9dadc'
  surface-bright: '#f9f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f5'
  surface-container: '#edeef0'
  surface-container-high: '#e8e8ea'
  surface-container-highest: '#e2e2e4'
  on-surface: '#1a1c1d'
  on-surface-variant: '#444748'
  inverse-surface: '#2f3132'
  inverse-on-surface: '#f0f0f2'
  outline: '#747878'
  outline-variant: '#c4c7c7'
  surface-tint: '#5f5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1c1b1b'
  on-primary-container: '#858383'
  inverse-primary: '#c8c6c5'
  secondary: '#5e5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e1dfdf'
  on-secondary-container: '#626262'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1a1b1f'
  on-tertiary-container: '#838388'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c8c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474646'
  secondary-fixed: '#e4e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#e3e2e7'
  tertiary-fixed-dim: '#c6c6cb'
  on-tertiary-fixed: '#1a1b1f'
  on-tertiary-fixed-variant: '#46474b'
  background: '#f9f9fb'
  on-background: '#1a1c1d'
  surface-variant: '#e2e2e4'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 3.5rem
    fontWeight: '700'
    lineHeight: 4rem
    letterSpacing: -0.03em
  display-lg-mobile:
    fontFamily: Manrope
    fontSize: 2.25rem
    fontWeight: '700'
    lineHeight: 2.75rem
    letterSpacing: -0.025em
  headline-lg:
    fontFamily: Manrope
    fontSize: 2.25rem
    fontWeight: '600'
    lineHeight: 2.75rem
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 1.75rem
    fontWeight: '600'
    lineHeight: 2.25rem
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Manrope
    fontSize: 1.5rem
    fontWeight: '600'
    lineHeight: 2rem
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Manrope
    fontSize: 1.125rem
    fontWeight: '600'
    lineHeight: 1.625rem
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 1.125rem
    fontWeight: '400'
    lineHeight: 1.7rem
    letterSpacing: -0.005em
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 1rem
    fontWeight: '400'
    lineHeight: 1.5rem
    letterSpacing: 0em
  body-sm:
    fontFamily: Hanken Grotesk
    fontSize: 0.875rem
    fontWeight: '400'
    lineHeight: 1.325rem
    letterSpacing: 0.005em
  label-md:
    fontFamily: Hanken Grotesk
    fontSize: 0.875rem
    fontWeight: '600'
    lineHeight: 1.25rem
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 0.75rem
    fontWeight: '600'
    lineHeight: 1rem
    letterSpacing: 0.02em
  caption:
    fontFamily: Hanken Grotesk
    fontSize: 0.6875rem
    fontWeight: '500'
    lineHeight: 0.875rem
    letterSpacing: 0.04em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-sm: 1rem
  margin: 2rem
  margin-sm: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

This design system expresses quiet luxury through hyper-minimalist discipline, optical clarity, and tactile digital craft. Engineered for high-stakes screening and clinical intervention workflows, the interface eliminates decorative distraction to establish unquestioned authority, composure, and emotional safety. 

The aesthetic fuses Apple Human Interface Guidelines with pure monochromatic architecture:
- **Quiet Luxury:** Restraint as power. High-contrast typography anchors wide expanses of pure white space, avoiding artificial color accents in favor of tonal precision and material physics.
- **Micro-tactility:** Surfaces respond to interaction through authentic Apple squircle curvature, frosted glass translucency, and subtle scale-down compressions (0.98x) on active contact.
- **Clinical Serenity:** The user experience removes visual noise, reducing cognitive load for educators, clinicians, and learners undergoing high-frequency cognitive screening.

## Colors

The system employs a strict monochrome spectrum that delivers structural clarity and rigorous clinical communication without hue bias.

### Color Tokens & Roles
- **Pitch Black (`#111111` / `#0A0A0A`):** Core structural anchor. Applied to dominant headline typography, primary tactile pill buttons, active state indicators, and critical elevated thresholds.
- **Slate Gray (`#666666`):** Secondary metadata, supporting labels, tabular captions, and inactive tab states.
- **Ash Gray (`#A1A1A6`):** Tertiary accents, placeholder values, inactive iconography, and disabled field bounds.
- **System Off-White (`#F7F7F9`):** Canvas grouping tone, secondary container fill, and nested card backdrop.
- **Pure White (`#FFFFFF`):** High-level card surfaces, interactive input backdrops, and floating sheets.
- **Pale Hairline (`#E5E5EA`):** Sub-pixel border boundaries and section dividers.

### Translucent Materials
- **Frosted Glass (`rgba(255, 255, 255, 0.8)`):** Paired with a 20px directional backdrop blur (`backdrop-filter: blur(20px) saturate(180%)`) for navigation bars, floating metric docks, and contextual sheets.

### Diagnostic Risk-Level Monochrome Mapping
Risk and assessment levels strictly reject traffic-light coloring, opting for luminosity-based perceptual weight:
- **Low Risk / Baseline:** Pure White (`#FFFFFF`) surface with an ultra-crisp 1px `#111111` structural stroke and `#111111` text.
- **Mild:** Light Ash Gray (`#E5E5EA`) surface, borderless, with `#111111` text.
- **Moderate:** Charcoal (`#555555`) surface, borderless, with `#FFFFFF` text.
- **Elevated / Priority:** Pitch Black (`#111111`) surface, borderless, with `#FFFFFF` text.

## Typography

Typography establishes architectural balance through geometry and negative space. 

- **Display & Headlines (Manrope):** Geometric, precision-engineered letterforms deliver confident, modern authority. Tight negative letter-spacing (`-0.02em` to `-0.03em`) on large variants maintains cohesive typographic mass.
- **Body & Controls (Hanken Grotesk):** Neutral grotesk characteristics ensure pristine legibility at scale. Body copy adheres strictly to a `1.5` proportional line height, preventing ocular fatigue during prolonged intervention reviews.
- **Numeric Display:** Tabular numbers (`font-variant-numeric: tabular-nums`) must be enabled on all metric readouts, assessment scores, and time-tracking modules.

## Layout & Spacing

The layout is constructed on an 8pt base grid with an inner 4pt sub-grid for micro-alignments.

### Grid Architecture
- **Desktop (1024px+):** 12-column responsive fluid grid with 32px (`space-xl` / 2) gutters and 48px canvas margins. Maximum central container width is capped at 1280px.
- **Tablet (768px – 1023px):** 8-column grid with 24px (`space-lg`) gutters and 32px canvas margins.
- **Mobile (320px – 767px):** 4-column layout with 16px (`space-md`) gutters and 16px outer safety margins.

### Inset-Grouped Layout Structure
In alignment with Apple HIG standards, viewports organize cards and functional rows into inset-grouped modules. Containers do not hit canvas edges; they remain inset with minimum `16px` lateral clearance on mobile devices, wrapping related actionable fields into cohesive rounded islands.

## Elevation & Depth

This design system avoids muddy, heavy drop shadows, relying on tonal contrast, frosted light dispersion, and razor-sharp perimeter lines.

### Depth Hierarchy
1. **Canvas (Base Level):** Solid `#F7F7F9` or pure `#FFFFFF`.
2. **Surface Insets:** Recessed modules use `#F7F7F9` on white backgrounds or `#FFFFFF` on off-white surfaces, bounded by a `0.5px` border of `#E5E5EA`.
3. **Floating Overlays & Headers:** Translucent White (`rgba(255, 255, 255, 0.8)`) layered over backdrop blur (`20px`), bound on the bottom edge by a single `0.5px` `#E5E5EA` hairline.
4. **Interactive Modals & Menus:** Ambient contact illumination only. Standard elevation uses `box-shadow: 0 12px 32px -4px rgba(0, 0, 0, 0.04), 0 4px 12px -2px rgba(0, 0, 0, 0.02)` coupled with a distinct `0.5px solid #E5E5EA` perimeter stroke.

## Shapes

The shape system strictly uses continuous squircle geometry (super-ellipses), eliminating abrupt tangent transitions between curves and straight edges.

- **Primary Buttons & Badges:** Full pill curvature (`9999px`).
- **Cards & Primary Modules:** Apple-style `rounded-2xl` to `rounded-3xl` radii (`20px` to `26px`).
- **Inner Controls & Inputs:** Adaptive rounded forms (`12px` to `16px`), visually matching the radius of the outer container when nested.
- **Hairlines:** Structural borders use an ultra-fine `0.5px` stroke weight (`1px` on non-Retina displays) with `#E5E5EA` tone to maintain crisp perimeter definition.

## Components

### Buttons
- **Primary:** Pitch Black (`#111111`) fill, pure white text (`#FFFFFF`), full pill shape (`rounded-full`), height: 44px (touch target compliant). Active state: scales down to `0.98x` with opacity `0.92`.
- **Secondary / Ghost:** Pure White (`#FFFFFF`) surface, 0.5px `#E5E5EA` border, Pitch Black (`#111111`) text. Active state: `#F7F7F9` fill.
- **Destructive:** Pitch Black (`#111111`) outline with an inner Ash Gray strike indicator; no jarring saturated red.

### Risk Chips & Badges
- Pill-shaped (`rounded-full`), compact padding (4px vertical, 12px horizontal), `label-sm` typographic styling.
- Rendered exclusively using the monochromatic diagnostic hierarchy:
  - *Low:* White fill with 1px `#111111` stroke.
  - *Mild:* `#E5E5EA` fill, no stroke.
  - *Moderate:* `#555555` fill, `#FFFFFF` text.
  - *Elevated:* `#111111` fill, `#FFFFFF` text.

### Inset-Grouped Lists
- Contained within an outer `24px` squircle container with a Pure White (`#FFFFFF`) fill.
- Rows measure a minimum of `52px` vertical height.
- Row separators use a `0.5px` solid `#E5E5EA` line inset `16px` from the leading icon/text edge, spanning flush to the right margin.
- Trailing elements feature micro navigation chevrons (`#A1A1A6`) or monochrome state toggles.

### Inputs & Search Bars
- Background: `#F7F7F9` (recessed) with an invisible `0.5px` border that transitions to solid `#111111` upon focus.
- Radius: `14px` squircle.
- Text: Pitch Black (`#111111`), placeholder: Ash Gray (`#A1A1A6`). No drop shadows on focus; clarity is maintained through border contrast alone.

### Checkboxes & Radios
- **Checkbox:** `20px` square with `6px` squircle radius. Selected: Pitch Black (`#111111`) fill with white checkmark. Unselected: 1px `#A1A1A6` stroke, white fill.
- **Radio Button:** Concentric pill circles. Selected: Outer 1px `#111111` ring with an inner `#111111` solid dot.

### Cards & Screening Modules
- High-level cards feature a Pure White (`#FFFFFF`) fill, `24px` squircle radius, and an ultra-fine `0.5px solid #E5E5EA` hairline.
- Content groupings maintain a generous `24px` interior padding (`space-lg`), separating diagnostic data points cleanly.