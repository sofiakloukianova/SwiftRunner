//
//  LineNumberView.swift
//  GUItool
//
//  Created by Sofia KL on 15.12.25.
//

import Cocoa
import SwiftUI
import AppKit

final class LineNumberRulerView: NSRulerView {
    weak var textView: NSTextView?
    
    // MARK: - Initialization

    init(textView: NSTextView) {
        self.textView = textView
        super.init(
            scrollView: textView.enclosingScrollView!,
            orientation: .verticalRuler
        )
        self.clientView = textView
        self.ruleThickness = 40

        // Observer 1: Redraws vertical ruler when typing/deleting text
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: NSText.didChangeNotification,
            object: textView
        )
        
        // Observer 2: Redraws vertical ruler when cursor moves to highlight current line
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: NSTextView.didChangeSelectionNotification,
            object: textView
        )
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Triggered when text changes or cursor moves -> calls drawHashMarksAndLabels
    @objc private func textDidChange() {
        needsDisplay = true
    }
    
    // MARK: - Drawing
    
    // Custom method to draw line numbers as vertical ruler
    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = textView,
              let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer else { return }

        // === SETUP: Prepare styling and positioning ===
        let font = textView.font ?? .systemFont(ofSize: 12)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.secondaryLabelColor
        ]

        let relativePoint = convert(NSPoint.zero, from: textView) // Align ruler and text view coordinate systems
        let inset = textView.textContainerInset.height // Account for text view padding
        let string = textView.string as NSString
        
        let cursorLocation = textView.selectedRange().location
        var currentLine = 0
        var charCount = 0
        var lineNumber = 1
        
        // === DRAW LINE NUMBERS: Loop through each line ===
        // Enumerate each line in the text (including trailing empty line if text ends with newline)
        string.enumerateSubstrings(
            in: NSRange(location: 0, length: string.length),
            options: [.byLines, .substringNotRequired]
        ) { _, lineRange, _, _ in
            // Track which line the cursor is on
            if cursorLocation >= charCount && cursorLocation < charCount + lineRange.length + 1 {
                currentLine = lineNumber
            }
            charCount += lineRange.length + 1
            
            // Get the rectangle (= where the line is drawn on the screen) for this line's glyphs
            let glyphRange = layoutManager.glyphRange(forCharacterRange: lineRange, actualCharacterRange: nil)
            let lineRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)

            // Calculate y position fir the line number
            let y = lineRect.minY + relativePoint.y + inset

            // Draw line number (highlighted if current)
            let isCurrent = lineNumber == currentLine
            self.drawLineNumber(lineNumber, atY: y, attrs: attrs, isCurrent: isCurrent)
            lineNumber += 1
        }
        
        // === SPECIAL CASE: Empty line after final newline ===
        if string.hasSuffix("\n") {
            // Find the last visible line
            let lastGlyphIndex = layoutManager.numberOfGlyphs > 0 ? layoutManager.numberOfGlyphs - 1 : 0
            let lastLineRect = layoutManager.lineFragmentRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
            
            let y = lastLineRect.maxY + relativePoint.y + inset // The new empty line appears right below the last line
            
            let isCurrent = lineNumber == currentLine
            self.drawLineNumber(lineNumber, atY: y, attrs: attrs, isCurrent: isCurrent)
        }
    }
    
    // MARK: - Helpers

    // Helper method: Draws a single line number at a specific Y position
    private func drawLineNumber(_ number: Int, atY y: CGFloat, attrs: [NSAttributedString.Key: Any], isCurrent: Bool) {
        let label = "\(number)" as NSString
        var drawAttrs = attrs
        
        // Highlight current line
        if isCurrent {
            drawAttrs[.foregroundColor] = NSColor.labelColor
        }
        
        // Calculate X position
        let size = label.size(withAttributes: drawAttrs)
        let x = ruleThickness - size.width - 6
        
        label.draw(at: NSPoint(x: x, y: y), withAttributes: drawAttrs)
    }
}
