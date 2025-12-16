//
//  OutputPaneViewModel.swift
//  GUItool
//
//  Created by Sofia KL on 16.12.25.
//


import AppKit
import Foundation

@Observable
final class OutputPaneViewModel {
    weak var textView: NSTextView?

    func jump(toLine line: Int, column col: Int, in text: String) {
        guard let tv = textView else { return }

        let target = max(0, min(text.count, offset(line: line, column: col, in: text)))
        tv.setSelectedRange(NSRange(location: target, length: 0))
        tv.scrollRangeToVisible(NSRange(location: target, length: 0))
        tv.window?.makeFirstResponder(tv)
    }

    // 1-based line/column -> 0-based character offset
    private func offset(line: Int, column: Int, in text: String) -> Int {
        guard line > 0, column > 0 else { return 0 }

        var currentLine = 1
        var idx = text.startIndex

        // Move idx to start of requested line
        while idx < text.endIndex && currentLine < line {
            if text[idx] == "\n" { currentLine += 1 }
            idx = text.index(after: idx)
        }

        // Move within line by (column - 1) characters
        var remaining = column - 1
        while idx < text.endIndex && remaining > 0 && text[idx] != "\n" {
            idx = text.index(after: idx)
            remaining -= 1
        }

        return text.distance(from: text.startIndex, to: idx)
    }
}
