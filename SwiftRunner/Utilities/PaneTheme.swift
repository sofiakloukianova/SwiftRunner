//
//  PaneTheme.swift
//  SwiftRunner
//
//  Created by Sofia KL on 16.12.25.
//

import Foundation
import AppKit
import SwiftUI

enum PaneTheme {
    static let fontSize: CGFloat = 13
    static let fontWeight: NSFont.Weight = .regular

    static let nsFont: NSFont = {
        NSFont.monospacedSystemFont(ofSize: fontSize, weight: fontWeight)
    }()

    static let swiftUIFont: Font = {
        Font(nsFont)
    }()

    static let editorBackground = NSColor(Color.editorBackground)
    static let outputBackground = NSColor(Color.outputBackground)
    static let textColor = NSColor.white
    static let linkColor = NSColor.red
    static let textInsets = NSSize(width: 10, height: 10)
}
