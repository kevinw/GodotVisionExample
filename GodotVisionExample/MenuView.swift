//
//  MenuView.swift
//  GodotVisionExample
//
//  Created by Adam Watters on 5/16/24.
//

import SwiftUI

struct MenuView: View {
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.dismiss) var dismissWindow
    
    var body: some View {
        Toggle("Place Cubes", isOn: $showImmersiveSpace)
            .toggleStyle(.button)
            .padding()
            .onChange(of: showImmersiveSpace) { _, shouldShowImmersiveSpace in
                Task { @MainActor in
                    if shouldShowImmersiveSpace {
                        switch await openImmersiveSpace(id: "scene") {
                        case .opened:
                            immersiveSpaceIsShown = true
                            dismissWindow()
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
    }
}

#Preview {
    MenuView()
}
