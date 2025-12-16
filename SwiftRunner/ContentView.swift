//
//  ContentView.swift
//  GUItool
//
//  Created by Sofia KL on 09.12.25.
//

import SwiftUI

struct ContentView: View {
    // Model
    @Binding var document: EditorDocument
    // Service
    @State private var executor = ScriptExecutor()
    @State private var errorNavigator = ErrorNavigationService()
    // Appearance
    @State private var paneTheme = PaneTheme()
    
    let fileURL: URL?
    
    private var filename: String {
        fileURL?.lastPathComponent ?? "Untitled.swift"
    }

    var body: some View {
        HSplitView {
            Group {
                EditorPaneView(rawText: $document.text, errorNavigatior: errorNavigator, paneTheme: paneTheme)
                OutputPaneView(output: executor.output, exitCode: executor.lastExitCode, paneTheme: paneTheme) { line, col in
                    errorNavigator.jump(toLine: line, column: col, in: document.text)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(minWidth: 200)
        }
        .toolbar {
            StatusIndicatorView(isRunning: executor.isRunning, exitCode: executor.lastExitCode)
            PlayButtonView(isRunning: executor.isRunning) {
                executor.run(script: document.text, filename: filename)
            }
            StopButtonView(isRunning: executor.isRunning) {
                executor.stop()
            }
            SettingsView(paneTheme: paneTheme)
        }
    }
}
