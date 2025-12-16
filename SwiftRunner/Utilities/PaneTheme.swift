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

    static let editorBackground = NSColor(Color(red: 41 / 255, green: 42 / 255, blue: 47 / 255))
    static let outputBackground = NSColor(Color(red: 0x1E / 255, green: 0x1E / 255, blue: 0x1E / 255))
    static let textColor = NSColor.white
    static let linkColor = NSColor.red
    static let unterlineStyle = NSUnderlineStyle.single.rawValue
    static let textInsets = NSSize(width: 10, height: 10)
}
