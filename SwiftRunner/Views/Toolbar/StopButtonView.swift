//
//  StopButtonView.swift
//  SwiftRunner
//
//  Created by Sofia KL on 16.12.25.
//

import SwiftUI

struct StopButtonView: View {
    let isRunning: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "stop.fill")
        }
        .disabled(!isRunning)
        .help("Stop script execution")
    }
}
