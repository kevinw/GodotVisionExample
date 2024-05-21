/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model that holds app state and the logic for updating the scene and placing cubes.
*/

import ARKit
import RealityKit
import GodotVision

/// A model type that holds app state and processes updates from ARKit.
@Observable
@MainActor
class EntityModel {
    let godotVisionCoordinator: GodotVisionCoordinator? = nil
    let session = ARKitSession()
    let planeDetection = PlaneDetectionProvider()
    let sceneReconstruction = SceneReconstructionProvider()
    var planeAnchorHandler: PlaneAnchorHandler?
    var sceneReconstructionHandler: SceneReconstructionHandler?
    
    var contentEntity = Entity()
    
    var errorState = false

    /// Sets up the root entity in the scene.
    func setupContentEntity() -> Entity {
        planeAnchorHandler = PlaneAnchorHandler(rootEntity: contentEntity)
        sceneReconstructionHandler = SceneReconstructionHandler(rootEntity: contentEntity)
        return contentEntity
    }
    
    var dataProvidersAreSupported: Bool {
        PlaneDetectionProvider.isSupported && SceneReconstructionProvider.isSupported
    }
    
    var isReadyToRun: Bool {
        planeDetection.state == .initialized && sceneReconstruction.state == .initialized
    }
    
    func processPlaneDetectionUpdates(_ godotVisionCoordinator: GodotVisionCoordinator) async {
        for await anchorUpdate in planeDetection.anchorUpdates {
            await planeAnchorHandler?.process(anchorUpdate, godotVisionCoordinator)
        }
    }
    
    func processSceneReconstructionUpdate(_ godotVisionCoordinator: GodotVisionCoordinator) async {
        for await anchorUpdate in sceneReconstruction.anchorUpdates {
            await sceneReconstructionHandler?.process(anchorUpdate, godotVisionCoordinator)
        }
    }
    
    /// Responds to events like authorization revocation.
    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(type: _, status: let status):
                print("Authorization changed to: \(status)")
                
                if status == .denied {
                    errorState = true
                }
            case .dataProviderStateChanged(dataProviders: let providers, newState: let state, error: let error):
                print("Data provider changed: \(providers), \(state)")
                if let error {
                    print("Data provider reached an error state: \(error)")
                    errorState = true
                }
            @unknown default:
                fatalError("Unhandled new event type \(event)")
            }
        }
    }
}
