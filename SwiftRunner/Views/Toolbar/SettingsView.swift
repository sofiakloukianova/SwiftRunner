//
//  SettingsButtonView.swift
//  GUItool
//
//  Created by Sofia KL on 09.12.25.
//

import SwiftUI

struct SettingsView: View {
    @State var paneTheme: PaneTheme
    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            Label("Settings", systemImage: "gearshape.fill")
        }
        .popover(isPresented: $isPresented, arrowEdge: .bottom) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Appearance Settings")
                    .font(.headline)
                    .padding(.bottom, 4)
                fontSizeAdjuster
                colorSchemes
            }
            .padding()
            .frame(width: 240)
        }
    }
    
    var fontSizeAdjuster: some View {
        HStack {
            Text("Font Size")
            Slider(
                value: $paneTheme.fontSize,
                in: 11...18,
                step: 1
            )
            .tint(Color(.white))
            Text("\(Int(paneTheme.fontSize))")
                .frame(width: 30, alignment: .trailing)
        }
    }
    
    var colorSchemes: some View {
        // Light / Dark mode
        HStack {
            Text("Appearance")
            Picker("", selection: $paneTheme.colorScheme) {
                Text("Dark").tag(PaneTheme.ColorScheme.dark)
                Text("Light").tag(PaneTheme.ColorScheme.light)
            }
            .tint(Color(.white))
            .pickerStyle(.segmented)
        }
    }
    
    
}


