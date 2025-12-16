//
//  EditorPanelView.swift
//  GUItool
//
//  Created by Sofia KL on 09.12.25.
//

import SwiftUI
import AppKit

struct EditorPaneView: NSViewRepresentable {
    @Binding var rawText: String
    @State var errorNavigatior: ErrorNavigationService
    let paneTheme: PaneTheme
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, paneTheme: paneTheme)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        // === 1) Make text view ===
        let textView = NSTextView()
        // Behavior
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextCompletionEnabled = false
        textView.delegate = context.coordinator
        // Appearance
        textView.font = paneTheme.nsFont
        textView.backgroundColor = paneTheme.editorBackground
        textView.textColor = paneTheme.textColor
        textView.insertionPointColor = .white
        textView.textContainerInset = paneTheme.textInsets
        // Layout
        textView.textContainer?.widthTracksTextView = false
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        errorNavigatior.textView = textView
        
        // === 2) Make scroll view ===
        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        
        // === 3) Make line number ruler view ===
        let ruler = LineNumberRulerView(textView: textView)
        scrollView.verticalRulerView = ruler
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true

        return scrollView
    }
    
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        
        // Keep text in sync
        if textView.string != rawText {
            textView.string = rawText
        }

        // Keep appearance in sync
        textView.font = paneTheme.nsFont
        textView.backgroundColor = paneTheme.editorBackground
        textView.textColor = paneTheme.textColor

        // SINGLE source of rendering truth
        SyntaxHighlighter.highlight(
            textView.textStorage!,
            theme: paneTheme
        )
    }
    
    final class Coordinator: NSObject, NSTextViewDelegate {
        let parent: EditorPaneView
        let paneTheme: PaneTheme

        init(parent: EditorPaneView, paneTheme: PaneTheme) {
            self.parent = parent
            self.paneTheme = paneTheme
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }

            // 1) Update SwiftUI model
            parent.rawText = textView.string

            // 2) REAL-TIME highlighting (AppKit side)
            SyntaxHighlighter.highlight(
                textView.textStorage!,
                theme: paneTheme
            )
        }
    }
}
