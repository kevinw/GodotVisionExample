//  Created by Kevin Watters on 12/27/23.

import SwiftUI
import RealityKit
import GodotVision

struct ContentView: View {
    @StateObject private var coordinator = GodotVisionCoordinator()
    
    var body: some View {
        VStack {
            RealityView { content, attachments in
                // Initialize Godot
                let rkEntityGodotRoot = coordinator.setupRealityKitScene(content, volumeSize: VOLUME_SIZE)
                print("All Godot nodes going into \(rkEntityGodotRoot)")
                
                if let uiPanel = attachments.entity(for: "ui_panel") {
                    content.add(uiPanel)
                    
                    // TODO: better if we can base this on the height of the panel
                    uiPanel.position = .init(0, Float(VOLUME_SIZE.y / -2 + 0.1), Float(VOLUME_SIZE.z / 2 - 0.01))
                }
            } update: { _, _ in
                // Called when SwiftUI @State in this ContentView changes. See docs for RealityView.
            } attachments: {
                // Add SwiftUI attachments that live in the RealityKit scene.
                Attachment(id: "ui_panel") {
                    HStack {
                        Button {
                            coordinator.reloadScene()
                        } label: {
                            Text("Reload Scene")
                        }
                        
                        Button {
                            coordinator.changeSceneToFile(atResourcePath: "res://examples/physics_toy/physics_toy.tscn")
                        } label: {
                            Text("Physics Toy")
                        }
                        
                        Button {
                            coordinator.changeSceneToFile(atResourcePath: "res://examples/hello/example_godot_vision_scene.tscn")
                        } label: {
                            Text("Hello Scene")
                        }
                    }.padding(36).frame(width: 700).glassBackgroundEffect()
                }
            }
        }
        .modifier(GodotVisionRealityViewModifier(coordinator: coordinator))
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
