//  Created by Kevin Watters on 12/27/23.

import SwiftUI
import RealityKit
import GodotVision

struct ContentView: View {
    @StateObject private var coordinator = GodotVisionCoordinator()
    
    var body: some View {
        VStack {
            RealityView { content in
                let rkEntityGodotRoot = coordinator.setupRealityKitScene(content, volumeSize: VOLUME_SIZE)
                print("All Godot nodes going into \(rkEntityGodotRoot)")
            }
        }
        .modifier(GodotVisionRealityViewModifier(coordinator: coordinator))
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
