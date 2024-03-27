//  Created by Kevin Watters on 12/27/23.

import SwiftUI
import RealityKit
import GodotVision

struct ContentView: View {
    @StateObject private var coordinator = GodotVisionCoordinator()
    
    var body: some View {
        GeometryReader3D { (geometry: GeometryProxy3D) in
            RealityView { content, attachments in
                // Initialize Godot
                let rkEntityGodotRoot = coordinator.setupRealityKitScene(content, volumeSize: VOLUME_SIZE)
                print("All Godot nodes going into \(rkEntityGodotRoot)")
                if let uiPanel = attachments.entity(for: "ui_panel") {
                    content.add(uiPanel)
                    uiPanel.position = .init(0, Float(VOLUME_SIZE.y / -2 + 0.1), Float(VOLUME_SIZE.z / 2 - 0.01))
                }
            } update: { content, attachments in
                // update called when SwiftUI @State in this ContentView changes. See docs for RealityView.
                // user can change the volume size from the default by selecting a different zoom level.
                // we watch for changes via the GeometryReader and scale the godot root accordingly
                let frame = content.convert(geometry.frame(in: .local), from: .local, to: .scene)
                let volumeSize = simd_double3(frame.max - frame.min)
                coordinator.changeScaleIfVolumeSizeChanged(volumeSize)
                if let uiPanel = attachments.entity(for: "ui_panel") {
                    // swiftui attachment also needs to be repositioned
                    uiPanel.position = .init(0, Float(volumeSize.y / -2 + 0.1), Float(volumeSize.z / 2 - 0.01))
                }
            } attachments: {
                Attachment(id: "ui_panel") {
                    HStack {
                        Button {
                            coordinator.reloadScene()
                        } label: {
                            Text("Reload Scene")
                        }
                        
                        Button {
                            coordinator.changeSceneToFile(atResourcePath: "res://examples/hello/example_godot_vision_scene.tscn")
                        } label: {
                            Text("Hello")
                        }
                        
                        Button {
                            coordinator.changeSceneToFile(atResourcePath: "res://examples/physics_toy/physics_toy.tscn")
                        } label: {
                            Text("Physics")
                        }
                        
                        Button {
                            coordinator.changeSceneToFile(atResourcePath: "res://examples/materials/materials.tscn")
                        } label: {
                            Text("Materials")
                        }
                        
                        Button {
                            coordinator.changeSceneToFile(atResourcePath: "res://examples/rigged_models/example_rigged_models.tscn")
                        } label: {
                            Text("Rigged Models")
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
