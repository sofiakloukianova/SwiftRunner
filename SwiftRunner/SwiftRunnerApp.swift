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
        }
        .defaultSize(width: 1200, height: 600)
    }
}
