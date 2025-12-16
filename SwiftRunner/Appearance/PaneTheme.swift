//
//  PaneTheme.swift
//  SwiftRunner
//
//  Created by Sofia KL on 16.12.25.
//

import AppKit
import SwiftUI
import Foundation

@Observable
final class PaneTheme {

    enum ColorScheme {
        case dark
        case light
    }

    // MARK: - User settings
    var fontSize: CGFloat = 13
    var fontWeight: NSFont.Weight = .regular
    var colorScheme: ColorScheme = .dark

    // MARK: - Font
    var nsFont: NSFont {
        NSFont.monospacedSystemFont(ofSize: fontSize, weight: fontWeight)
    }

    // MARK: - Editor colors
    var editorBackground: NSColor {
        switch colorScheme {
        case .dark:
            return NSColor(Color(red: 41/255, green: 42/255, blue: 47/255))
        case .light:
            return .white
        }
    }

    var outputBackground: NSColor {
        switch colorScheme {
        case .dark:
            return NSColor(Color(red: 0x1E/255, green: 0x1E/255, blue: 0x1E/255))
        case .light:
            return NSColor(white: 0.96, alpha: 1)
        }
    }

    var textColor: NSColor {
        switch colorScheme {
        case .dark:
            return .white
        case .light:
            return .black
        }
    }

    // MARK: - Syntax colors
    var baseColor: NSColor { textColor }
    var commentColor: NSColor { .systemGray }
    var keywordColor: NSColor {
        colorScheme == .dark
        ? NSColor(calibratedRed: 1.0, green: 0.48, blue: 0.7, alpha: 1)
        : NSColor(calibratedRed: 0.6, green: 0.1, blue: 0.4, alpha: 1)
    }
    var stringColor: NSColor {
        colorScheme == .dark
        ? NSColor(calibratedRed: 1.0, green: 0.51, blue: 0.48, alpha: 1)
        : NSColor(calibratedRed: 0.6, green: 0.2, blue: 0.2, alpha: 1)
    }
    var numberColor: NSColor {
        colorScheme == .dark
        ? NSColor(calibratedRed: 0.85, green: 0.79, blue: 0.5, alpha: 1)
        : NSColor(calibratedRed: 0.5, green: 0.45, blue: 0.2, alpha: 1)
    }

    // MARK: - Layout
    let textInsets = NSSize(width: 10, height: 10)
    let linkColor = NSColor.systemRed
    let underlineStyle = NSUnderlineStyle.single.rawValue
}
