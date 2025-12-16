//
//  OutputPaneView.swift
//  GUItool
//
//  Created by Sofia KL on 09.12.25.
//

import SwiftUI
import AppKit

struct OutputPaneView: NSViewRepresentable {
    let output: String
    let exitCode: Int?
    let paneTheme: PaneTheme
    let onJump: (_ line: Int, _ column: Int) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onJump: onJump)
    }

    func makeNSView(context: Context) -> NSScrollView {
        // === 1) Make text view ===
        let textView = NSTextView()
        // Behavior
        textView.isEditable = false
        textView.isSelectable = true
        textView.isRichText = true // Supports links
        textView.delegate = context.coordinator
        // Appearance
        textView.font = paneTheme.nsFont
        textView.textColor = paneTheme.textColor
        textView.backgroundColor = paneTheme.outputBackground
        textView.textContainerInset = paneTheme.textInsets
        textView.linkTextAttributes = [
            .foregroundColor: paneTheme.linkColor,
            .underlineStyle: paneTheme.underlineStyle
        ]
        // Layout
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainer?.widthTracksTextView = true
        textView.drawsBackground = true
        
        // === 2) Make scroll view ===
        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = true

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        
        // Keep appearance in sync
        textView.font = paneTheme.nsFont
        textView.textColor = paneTheme.textColor
        textView.backgroundColor = paneTheme.outputBackground

        // Single source of truth: attributed output
        textView.textStorage?.setAttributedString(
            context.coordinator.attributedOutput(
                from: output,
                exitCode: exitCode ?? 0,
                theme: paneTheme
            )
        )
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, NSTextViewDelegate {
        private let onJump: (Int, Int) -> Void

        init(onJump: @escaping (Int, Int) -> Void) {
            self.onJump = onJump
        }

        // Matches: filename:line:column: 
        private let regex: NSRegularExpression = {
            let pattern = #"(?m)([^:\n]+):(\d+):(\d+):"#
            return try! NSRegularExpression(pattern: pattern)
        }()

        func attributedOutput(from output: String, exitCode: Int, theme: PaneTheme) -> NSAttributedString {
            let text = output.isEmpty ? "No output yet.\n" : output

            let baseAttributes: [NSAttributedString.Key: Any] = [
                .font: theme.nsFont,
                .foregroundColor: theme.textColor
            ]

            let result = NSMutableAttributedString(string: text, attributes: baseAttributes)
            
            // Only add links if an error occured
            guard exitCode != 0 else {
                return result
            }

            let fullRange = NSRange(location: 0, length: (text as NSString).length)

            regex.enumerateMatches(in: text, range: fullRange) { match, _, _ in
                guard
                    let match,
                    let line = Int((text as NSString).substring(with: match.range(at: 2))),
                    let col  = Int((text as NSString).substring(with: match.range(at: 3)))
                else { return }

                // Add link without changing appearance
                let url = URL(string: "editorjump://\(line)/\(col)")!
                result.addAttribute(.link, value: url, range: match.range(at: 0))
            }

            return result
        }

        func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
            guard let url = link as? URL, url.scheme == "editorjump" else { return false }

            let parts = url.absoluteString.replacingOccurrences(of: "editorjump://", with: "").split(separator: "/")

            guard
                parts.count == 2,
                let line = Int(parts[0]),
                let col = Int(parts[1])
            else { return false }

            onJump(line, col)
            return true
        }
    }
}

