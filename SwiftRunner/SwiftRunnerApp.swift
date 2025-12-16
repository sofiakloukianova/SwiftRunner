//
//  GUItoolApp.swift
//  GUItool
//
//  Created by Sofia KL on 09.12.25.
//

import SwiftUI

@main
struct SwiftRunnerApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: EditorDocument()) { file in
            ContentView(document: file.$document, fileURL: file.fileURL)
                .frame(minWidth: 1200, minHeight: 600)
        }
        .windowResizability(.contentSize)
    }
}
