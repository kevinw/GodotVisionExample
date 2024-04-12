//  Created by Kevin Watters on 12/27/23.

import SwiftUI
import RealityKit
import GodotVision

struct ContentView: View {
    @StateObject private var godotVision = GodotVisionCoordinator()
    
    var body: some View {
        GeometryReader3D { (geometry: GeometryProxy3D) in
            RealityView { content, attachments in
                
                let pathToGodotProject = "Godot_Project" // The path to the folder containing the "project.godot" you wish Godot to load.
                
                // Initialize Godot
                let rkEntityGodotRoot = godotVision.setupRealityKitScene(content,
                                                                         volumeSize: VOLUME_SIZE,
                                                                         projectFileDir: pathToGodotProject)
                
                print("Godot scene root: \(rkEntityGodotRoot)")
                
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
                godotVision.changeScaleIfVolumeSizeChanged(volumeSize)
                if let uiPanel = attachments.entity(for: "ui_panel") {
                    // swiftui attachment also needs to be repositioned
                    uiPanel.position = .init(0, Float(volumeSize.y / -2 + 0.1), Float(volumeSize.z / 2 - 0.01))
                }
            } attachments: {
                Attachment(id: "ui_panel") {
                    HStack {
                        Button {
                            godotVision.reloadScene()
                        } label: {
                            Text("Reload Scene")
                        }
                        
                        Button {
                            godotVision.changeSceneToFile(atResourcePath: "res://examples/hello/example_godot_vision_scene.tscn")
                        } label: {
                            Text("Hello")
                        }
                        
                        Button {
                            godotVision.changeSceneToFile(atResourcePath: "res://examples/physics_toy/physics_toy.tscn")
                        } label: {
                            Text("Physics")
                        }
                        
                        Button {
                            godotVision.changeSceneToFile(atResourcePath: "res://examples/materials/materials.tscn")
                        } label: {
                            Text("Materials")
                        }
                        
                        Button {
                            godotVision.changeSceneToFile(atResourcePath: "res://examples/rigged_models/example_rigged_models.tscn")
                        } label: {
                            Text("Rigged Models")
                        }
                    }.padding(36).frame(width: 700).glassBackgroundEffect()
                }
            }
        }
        .modifier(GodotVisionRealityViewModifier(coordinator: godotVision))
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
