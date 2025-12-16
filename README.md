# SwiftRunner

SwiftRunner is a macOS app for writing and running Swift scripts with live output.
It features a split editor/output view, syntax highlighting, and clickable compiler
errors for quick navigation.

## Features

- Write and run Swift scripts instantly
- Live stdout / stderr streaming
- Clickable compiler errors (jump to line & column)
- Syntax highlighting
- Adjustable font size
- Light / Dark appearance
- Stop running scripts at any time

## Screenshots
<img width="1053" height="585" alt="screenshot1" src="https://github.com/user-attachments/assets/c62ecdbb-0b5d-43c2-bc90-b35ef92591d2" />

## Architecture Overview

SwiftRunner is built using **SwiftUI + AppKit**:

- `EditorPaneView` – NSTextView-backed code editor
- `OutputPaneView` – Rich-text output with clickable diagnostics
- `ScriptExecutor` – Runs Swift scripts in a background process
- `ErrorNavigationService` – Maps compiler errors to editor positions
- `PaneTheme` – Centralized styling and appearance settings

## Requirements

- macOS 13 or later
- Xcode 15 or later
- Swift 5.9 or later

## Build and Run Instructions

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/SwiftRunner.git
cd SwiftRunner
```

### 2. Open the Xcode project

Open the project file:

```bash
open SwiftRunner.xcodeproj
```

### 3. Build and run

Press: ⌘ + R
