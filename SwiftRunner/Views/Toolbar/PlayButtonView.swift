//
//  PlayButtonView.swift
//  GUItool
//
//  Created by Sofia KL on 09.12.25.
//

import SwiftUI

struct PlayButtonView: View {
    let isRunning: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Run", systemImage: "play.fill")
        }
        .disabled(isRunning)
    }
}
