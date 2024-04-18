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
                        // A button to reload the current scene.
                        Button { godotVision.reloadScene() } label: {
                            Text("Reload")
                        }
                        
                        // Buttons for loading example scenes.
                        sceneButton(label: "Hello", resourcePath: "res://examples/hello/example_godot_vision_scene.tscn")
                        sceneButton(label: "Physics", resourcePath: "res://examples/physics_toy/physics_toy.tscn")
                        //sceneButton(label: "Materials", resourcePath: "res://tests/materials/materials.tscn")
                        sceneButton(label: "Skeletons", resourcePath: "res://examples/rigged_models/example_rigged_models.tscn")
                        sceneButton(label: "CSG", resourcePath: "res://examples/csg/csg.tscn")
                        
                    }.padding(36).frame(width: 700).glassBackgroundEffect()
                }
            }
        }
        .modifier(GodotVisionRealityViewModifier(coordinator: godotVision))
    }
        
    @ViewBuilder
    func sceneButton(label: String, resourcePath: String) -> some View {
        Button {
            godotVision.changeSceneToFile(atResourcePath: resourcePath)
        } label: {
            Text(label)
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
