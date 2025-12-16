//
//  EditorDocument.swift
//  GUItool
//
//  Created by Sofia KL on 13.12.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct EditorDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.swiftSource] }

    var text: String

    init(text: String = "") {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents,
            let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }

        text = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}
