//  Created by Kevin Watters on 12/27/23.

import SwiftUI
import RealityKit
import GodotVision
import RealityKitContent

struct ContentView: View {
    @StateObject private var godotVision = GodotVisionCoordinator()
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.openWindow) var openWindow
    @Environment(EntityModel.self) var model
    var body: some View {
        GeometryReader3D { (geometry: GeometryProxy3D) in
            RealityView { content in
                content.add(model.setupContentEntity())
                let pathToGodotProject = "Godot_Project" // The path to the folder containing the "project.godot" you wish Godot to load.
                if let scene = try? await Entity(named: "laser_two", in: realityKitContentBundle) {
                    content.add(scene)
                    if let capsule = scene.findEntity(named: "shaded_capsule"){
                        print(capsule)
                        if let usd = capsule.findEntity(named: "usdPrimitiveAxis") {
                            print(usd)
                            if let model = usd.components[ModelComponent.self] {
                                if let material = model.materials[0] as? ShaderGraphMaterial {
                                    godotVision.setCustomMaterial(material)
                                    // Initialize Godot
                                    let rkEntityGodotRoot = godotVision.setupRealityKitScene(content,
                                                                                             volumeSize: VOLUME_SIZE,
                                                                                             projectFileDir: pathToGodotProject)
                                    print("Godot scene root: \(rkEntityGodotRoot)")
                                }
                            }
                        }
                    }
                }
                
            } update: { content in
                // update called when SwiftUI @State in this ContentView changes. See docs for RealityView.
                // user can change the volume size from the default by selecting a different zoom level.
                // we watch for changes via the GeometryReader and scale the godot root accordingly
                let frame = content.convert(geometry.frame(in: .local), from: .local, to: .scene)
                let volumeSize = simd_double3(frame.max - frame.min)
//                godotVision.changeScaleIfVolumeSizeChanged(volumeSize)
            }
            .task {
                do {
                    if model.dataProvidersAreSupported && model.isReadyToRun {
                        try await model.session.run([model.planeDetection, model.sceneReconstruction])
                    } else {
                        await dismissImmersiveSpace()
                    }
                } catch {
                    print("Failed to start session: \(error)")
                    await dismissImmersiveSpace()
                    openWindow(id: "error")
                }
            }
            .task {
                await model.monitorSessionEvents()
            }
            .task(priority: .low) {
                await model.processSceneReconstructionUpdate(godotVision)
            }
//            .task {
//                // Monitor ARKit anchor updates once the user opens the immersive space.
//                //
//                // Tasks attached to a view automatically receive a cancellation
//                // signal when the user dismisses the view. This ensures that
//                // loops that await anchor updates from the ARKit data providers
//                // immediately end.
//                await model.processWorldAnchorUpdates()
//            }
//            .task {
//                await model.processDeviceAnchorUpdates()
//            }
            .task {
                await model.processPlaneDetectionUpdates(godotVision)
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
