---
name: Looming Play
colors:
  surface: '#fef7ff'
  surface-dim: '#ded7e4'
  surface-bright: '#fef7ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f8f1fe'
  surface-container: '#f3ebf8'
  surface-container-high: '#ede5f3'
  surface-container-highest: '#e7e0ed'
  on-surface: '#1d1a23'
  on-surface-variant: '#494454'
  inverse-surface: '#322f39'
  inverse-on-surface: '#f5eefb'
  outline: '#7b7486'
  outline-variant: '#cbc3d7'
  surface-tint: '#6d3bd7'
  primary: '#6b38d4'
  on-primary: '#ffffff'
  primary-container: '#8455ef'
  on-primary-container: '#fffbff'
  inverse-primary: '#d0bcff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#825100'
  on-tertiary: '#ffffff'
  tertiary-container: '#a36700'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e9ddff'
  primary-fixed-dim: '#d0bcff'
  on-primary-fixed: '#23005c'
  on-primary-fixed-variant: '#5516be'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#fef7ff'
  on-background: '#1d1a23'
  surface-variant: '#e7e0ed'
typography:
  display-lg:
    fontFamily: Nunito Sans
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Nunito Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
  headline-md:
    fontFamily: Nunito Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  body-lg:
    fontFamily: Nunito Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 30px
  body-md:
    fontFamily: Nunito Sans
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  label-caps:
    fontFamily: Nunito Sans
    fontSize: 14px
    fontWeight: '800'
    lineHeight: 20px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-margin: 24px
  gutter: 16px
  card-padding: 32px
  touch-target-min: 48px
---

## Brand & Style
The design system is built on the philosophy of **Friendly Minimalism**. It prioritizes extreme clarity and cognitive ease for children aged 3-10, removing the chaotic clutter often found in educational software. The brand personality is encouraging, safe, and vibrant without being overwhelming.

The aesthetic combines the structural integrity of modern SaaS with the warmth of tactile learning tools. By utilizing generous whitespace and large, interactive touch targets, the UI fosters independence in young learners. The style avoids complex textures in favor of flat surfaces, soft ambient shadows, and bold color blocking to define interactive zones.

## Colors
The palette is rooted in a vibrant "Digital Lavender" primary purple to signify creativity and wisdom. The secondary Mint and accent Orange act as semantic cues for success and warning/energy respectively. 

- **Primary Purple (#8B5CF6):** Used for main actions, active states, and progress indicators.
- **Secondary Mint (#10B981):** Used for "Correct" feedback, completion badges, and growth-related motifs.
- **Accent Orange (#F59E0B):** High-visibility callouts, "Play" buttons, and energy-based gamification elements.
- **Soft Pink (#F472B6):** Auxiliary color for character highlights and creative expression sections.
- **Surface Neutrals:** Use very light tints of purple or blue for backgrounds to keep the interface feeling "cool" and calm.

## Typography
**Nunito Sans** is the sole typeface for this design system. Its naturally rounded terminals provide a friendly, organic feel that mirrors early childhood handwriting while maintaining the legibility of a professional geometric sans.

- **Scale:** Font sizes are oversized compared to standard apps to accommodate emerging readers.
- **Hierarchy:** Use 'Extra Bold' (800) for all primary navigation and success messages to ensure they are the first thing a child sees.
- **Readability:** Maintain a minimum line height of 1.5x for body text to assist children who are tracking words with their fingers on the screen.

## Layout & Spacing
The layout follows a **Fluid Grid** model with high internal padding. For children, "negative space" is a functional tool that prevents accidental taps and reduces visual anxiety.

- **Rhythm:** All spacing is based on an 8px baseline grid. 
- **Margins:** On mobile/tablet, use a minimum 24px side margin to keep interactive elements away from the bezel where small hands hold the device.
- **Touch Targets:** No interactive element should be smaller than 48x48px. Primary action buttons should ideally be 64px in height.
- **Stacking:** Use vertical stacks for lesson choices to allow for large, full-width cards that are easy to target.

## Elevation & Depth
Depth is conveyed through **Tonal Layers** and **Ambient Shadows**. The design system avoids high-contrast black shadows, opting instead for "colored shadows" that use a darker, desaturated version of the background or primary color.

- **Level 0 (Base):** Neutral background (#F9FAFB).
- **Level 1 (Cards):** Pure white surfaces with a 12% opacity shadow of the primary purple (Blur: 20px, Y-Offset: 8px).
- **Level 2 (Interactive):** Buttons and active chips use a slightly more pronounced shadow to appear "lifted" and ready to be pressed.
- **Active State:** When pressed, elements should visually "sink" (reduce Y-offset and blur) to provide tactile-like haptic feedback.

## Shapes
The shape language is extremely soft and approachable. High-radius corners are used to remove "sharpness" from the digital environment, making it feel safe and toy-like.

- **Large Cards:** Specifically set at 32px to create a container that feels like a physical flashcard or board game piece.
- **Buttons:** Use 16px (rounded-lg) for standard buttons, and full pill-shapes for smaller chips or tags.
- **Input Fields:** Should mirror button roundedness to maintain consistency across the interactive layer.

## Components
- **Action Buttons:** Use "thick" bottom borders (4px) in a slightly darker shade of the button color to create a 3D "pushable" look.
- **Cards:** Large surfaces with 32px radius. Content inside should be centered with at least 32px of internal padding.
- **Progress Bars:** Thick (12px+) tracks with rounded ends. Use the Secondary Mint color for the fill to signal positive movement.
- **Chips/Badges:** Use for difficulty levels (Easy, Medium, Hard). Always accompany text with a simple icon for non-readers.
- **Feedback Overlays:** Full-screen modal overlays for "Great Job!" with large-scale flat illustrations and a single "Continue" button at the bottom.
- **Instructional Icons:** Use thick-stroke (2px+) rounded icons. Avoid thin or complex line art.