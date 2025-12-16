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
    @State var jumpController: OutputPaneViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
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
        textView.font = PaneTheme.nsFont
        textView.backgroundColor = PaneTheme.editorBackground
        textView.textColor = PaneTheme.textColor
        textView.insertionPointColor = .white
        textView.textContainerInset = PaneTheme.textInsets
        // Layout
        textView.textContainer?.widthTracksTextView = true
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        jumpController.textView = textView
        
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

        if textView.string != rawText {
            textView.string = rawText
            SyntaxHighlighter.highlight(textView.textStorage!)
        }
    }
    
    final class Coordinator: NSObject, NSTextViewDelegate {
        let parent: EditorPaneView

        init(_ parent: EditorPaneView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }

            parent.rawText = textView.string
            SyntaxHighlighter.highlight(textView.textStorage!)
        }
    }
}
