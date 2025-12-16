//
//  SyntaxHighlighter.swift
//  GUItool
//
//  Created by Sofia KL on 14.12.25.
//

import AppKit

enum SyntaxHighlighter {

    private static let keywords = [
        "func", "struct", "class", "enum", "let", "static",
        "var", "if", "else", "return", "import", "for", "in"
    ]

    // MARK: - Regexes

    private static let keywordRegex = try!
        NSRegularExpression(pattern: "\\b(" + keywords.joined(separator: "|") + ")\\b")

    private static let stringRegex = try!
        NSRegularExpression(pattern: "\"([^\"\\\\]|\\\\.)*\"")

    private static let commentRegex = try!
        NSRegularExpression(pattern: "//.*")

    private static let numberRegex = try!
        NSRegularExpression(pattern: "\\b\\d+(?:\\.\\d+)?\\b")

    // MARK: - Public API

    static func highlight(_ textStorage: NSTextStorage, theme: PaneTheme) {
        let fullRange = NSRange(location: 0, length: textStorage.length)
        let source = textStorage.string

        applyBaseStyle(to: textStorage, range: fullRange, theme: theme)

        // 1. Hightlight comments
        let commentRanges = ranges(matching: commentRegex, in: source, range: fullRange)
        applyHightlight(color: theme.commentColor, to: textStorage, ranges: commentRanges)

        // 2. Mask comments before string matching
        let commentMaskedSource = maskedText(source, masking: commentRanges)

        // 3. Highlight strings
        let stringRanges = ranges(matching: stringRegex, in: commentMaskedSource, range: fullRange)
        applyHightlight(color: theme.stringColor, to: textStorage, ranges: stringRanges)

        let protectedRanges = commentRanges + stringRanges

        // 3. Highlight numbers (excluding comments & strings)
        let numberRanges = ranges(matching: numberRegex, in: source, range: fullRange, excluding: protectedRanges)
        applyHightlight(color: theme.numberColor, to: textStorage, ranges: numberRanges)

        // 4. Highlight keywords (excluding comments & strings)
        let keywordRanges = ranges(matching: keywordRegex, in: source, range: fullRange, excluding: protectedRanges)
        applyHightlight(color: theme.keywordColor, to: textStorage, ranges: keywordRanges)
    }

    // MARK: - Helpers

    private static func applyBaseStyle(to textStorage: NSTextStorage, range: NSRange, theme: PaneTheme) {
        textStorage.setAttributes([.font: theme.nsFont, .foregroundColor: theme.baseColor], range: range)
    }

    private static func applyHightlight(color: NSColor, to textStorage: NSTextStorage, ranges: [NSRange]) {
        for range in ranges {
            textStorage.addAttribute(.foregroundColor, value: color, range: range)
        }
    }
    
    private static func maskedText(_ text: String, masking ranges: [NSRange])-> String {
        var chars = Array(text)
        for range in ranges {
            for i in range.location..<min(range.location + range.length, chars.count) {
                chars[i] = " "
            }
        }
        return String(chars)
    }

    private static func ranges(
        matching regex: NSRegularExpression,
        in text: String,
        range: NSRange,
        excluding protectedRanges: [NSRange] = []
    ) -> [NSRange] {
        regex
            .matches(in: text, range: range)
            .map { $0.range }
            .filter { range in
                !protectedRanges.contains { $0.intersection(range) != nil }
            }
    }

    private static func overlaps(_ range: NSRange, anyOf ranges: [NSRange]) -> Bool {
        ranges.contains { $0.intersection(range) != nil }
    }
}
