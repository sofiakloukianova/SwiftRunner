//
//  ContentView.swift
//  GUItool
//
//  Created by Sofia KL on 09.12.25.
//

import SwiftUI

extension Color {
    static let editorBackground = Color(red: 41 / 255, green: 42 / 255, blue: 47 / 255)
    static let outputBackground = Color(red: 0x1E / 255, green: 0x1E / 255, blue: 0x1E / 255)
}

struct ContentView: View {
    @Binding var document: EditorDocument
    @State private var executor = ScriptExecutor()
    @State private var jumpController = OutputPaneViewModel()
    
    let fileURL: URL?
    
    private var filename: String {
        fileURL?.lastPathComponent ?? "Untitled.swift"
    }

    var body: some View {
        HSplitView {
            Group {
                EditorPaneView(rawText: $document.text, jumpController: jumpController)
                OutputPaneView(output: executor.output) { line, col in
                    jumpController.jump(toLine: line, column: col, in: document.text)
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
            SettingsButtonView()
        }
    }
}
