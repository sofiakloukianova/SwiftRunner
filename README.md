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

> _(Optional, but highly recommended)_
> Add 1–2 screenshots of the editor and output pane.

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
