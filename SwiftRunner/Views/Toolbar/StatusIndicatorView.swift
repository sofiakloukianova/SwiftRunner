//
//  StatusIndicatorView.swift
//  GUItool
//
//  Created by Sofia KL on 16.12.25.
//

import SwiftUI

struct StatusIndicatorView: View {
    let isRunning: Bool
    let exitCode: Int?
    
    private var color: Color {
        if isRunning { .blue }
        else if let exitCode, exitCode != 0 { .red }
        else if exitCode == 0 { .green }
        else { .gray }
    }

    private var text: String {
        if isRunning { "Running..." }
        else if let exitCode {
            exitCode == 0 ? "Success (exit \(exitCode))" : "Failed (exit \(exitCode))"
        } else {
            "Ready"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
    }
}
