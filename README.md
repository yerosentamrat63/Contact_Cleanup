# Contact Cleaner 📇

> **A focused, tactile Flutter mobile application for decluttering your phone address book without the chaos.**

Designed around a swipe-to-decide interaction model (left to keep, right to mark for deletion), Contact Cleaner pairs an editorial, warm paper aesthetic with a zero-risk confirmation workflow: **nothing is removed from your device until you inspect and confirm it in the final review list.**

---

## 📱 Features

- **Swipe-to-Decide Contact Queue**: Drag right to mark for deletion, left to keep, with real-time card rotation, stamp tinting, and haptic feedback.
- **Physical Touch Controls**: Dedicated `KEEP` (Sage) and `DELETE` (Terracotta) action buttons with an inline "or swipe" cue for intuitive onboarding.
- **Instant Decision Undo**: Top header undo button reverts marked decisions and restores the contact card to its prior state.
- **Early Review Jump**: A dynamic `Review (X)` shortcut button appears as soon as any contacts are marked, allowing you to delete the current batch without swiping through every contact.
- **Non-Destructive Review Screen**: Live selection counter, "Tick all" / "Untick all" batch toggles, and individual contact checkboxes to change your mind before deleting.
- **Safety Bottom Sheet**: Confirms exact deletion count with explicit destructive warning before triggering address book mutations.
- **Clean Summary & Reset**: Reports contacts deleted vs kept, with live address book reload upon starting a new clean session.
- **Animated Coach Mark**: Interactive visual guide demonstrating swipe directions with guaranteed contrast and zero typography glitches.

---

## 🎨 Design System

Contact Cleaner implements an earthy, tactile editorial design language:

| Token | Color Hex | Role |
| :--- | :--- | :--- |
| **Bone** | `#D8CFBC` | Primary matte solid canvas background |
| **Floral White** | `#FFFBF4` | Raised card surface and elevated controls |
| **Smoky Black** | `#11120D` | Primary headlines and high-contrast text |
| **Olive Drab / Ink** | `#565449` / `#3E3D34` | Subtitles, labels, and secondary actions |
| **Terracotta** | `#B23A2E` | Destructive delete state, stamps, and alert buttons |
| **Sage Ink / Tint** | `#3F5A2B` / `#E3E9D2` | Keep action, confirmed state, and positive badges |

### Typography
- **Headings & Cards**: [Bricolage Grotesque](https://fonts.google.com/specimen/Bricolage+Grotesque) (w600/w700/w800)
- **Counters & Meta Labels**: [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono) (w500/w700)

---

## 🏗️ Architecture & Project Structure

```
design/                        # Design handoff HTML & original master icon assets
├── Contact Cleaner Screens.html
└── app_icons/
lib/
├── main.dart                  # App entry point & stage coordinator state machine
├── models/
│   └── contact_item.dart      # Contact data model & FlutterContacts mapper
├── services/
│   ├── contact_service.dart   # Permissions, address book query & batch deletion
│   └── preferences_service.dart # SharedPreferences state for onboarding & coach mark
├── theme/
│   ├── colors.dart            # Semantic color palette & design tokens
│   └── typography.dart        # Bricolage Grotesque & JetBrains Mono text styles
├── widgets/
│   ├── app_background.dart    # Solid bone matte background container
│   ├── app_buttons.dart       # Primary, Outline, CircleIcon, & ActionChoice buttons
│   ├── app_checkbox.dart      # Custom vector square checkbox with smooth animation
│   └── app_icons.dart         # Custom vector paths (Undo, Check, Trash, Locks, Arrows)
└── screens/
    ├── onboarding_screen.dart # Welcome screen with stacked card illustration
    ├── permission_screen.dart # Explicit contact read/write permission request
    ├── swipe_screen.dart      # Card stack, gesture listener & action buttons
    ├── coach_mark_overlay.dart# Interactive animated swipe demonstration
    ├── review_screen.dart     # Contact list review with checkbox toggles
    ├── confirm_sheet.dart     # Modal confirmation bottom sheet
    └── done_screen.dart       # Final deletion summary & restart flow
```

---

## ⚡ Performance & Size Optimization

Optimized for instant load times and minimal storage footprint:

- **Release ABI Splitting**: Compiles separate APKs for target architectures (`arm64-v8a`, `armeabi-v7a`, `x86_64`) rather than an bloated multi-ABI fat binary.
- **R8 Minification & Code Shrinking**: Enabled `isMinifyEnabled = true` and `isShrinkResources = true` with custom ProGuard rules.
- **Font Tree-Shaking**: Stripped 99.9% of unused glyphs from Material Icons (1.6 MB reduced to 1 KB).
- **Installed Footprint**: Decreased installed disk footprint from **~200 MB (debug fat build) down to ~17 MB** on Android devices.

---

## 🧪 Testing

The test suite covers full user flows and behavioral edge cases:

```bash
# Run all unit and widget tests
flutter test

# Run static code analysis
flutter analyze
```

### Test Coverage Highlights:
- Onboarding screen interaction & callback delivery
- Permission gate handling
- Swipe gesture distance, velocity commits, and Undo state restoration
- Early review shortcut (`Review (X)`) trigger
- Coach mark overlay rendering & dismiss lifecycle
- Review screen checkbox toggling, "Tick all / Untick all", and modal sheet confirmation
- Done screen metrics and state reload

---

## 🚀 Building & Running

### Requirements
- Flutter SDK 3.13+ (or 3.35+)
- Android SDK (API 34+)
- Connected physical device or emulator

### Development Mode
```bash
flutter run
```

### Optimized Production Release Build
```bash
flutter build apk --release --split-per-abi
```
The output APK for modern Android devices is located at:
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (~16.7 MB)
