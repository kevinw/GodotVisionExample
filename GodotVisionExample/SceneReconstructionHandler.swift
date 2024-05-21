/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A handler that keeps track of plane anchors.
*/

import Foundation
import ARKit
import RealityKit
import GodotVision

class SceneReconstructionHandler {
    var rootEntity: Entity
    
    init(rootEntity: Entity) {
        self.rootEntity = rootEntity
    }

    @MainActor
    func process(_ anchorUpdate: AnchorUpdate<MeshAnchor>, _ godotVisionCoordinator: GodotVisionCoordinator) async {
        let anchor = anchorUpdate.anchor
        let id = anchor.id
        switch anchorUpdate.event {
        case .added, .updated:
            var id = anchor.id
            let vertices = anchor.geometry.vertices.asSIMD3(ofType: Float.self)
            let faces = anchor.geometry.faces.asUInt16Array()
            let transform = anchor.originFromAnchorTransform
            godotVisionCoordinator.addOrUpdateReconstructionMesh(id: id, vertices: vertices, faces: faces, transform: transform)
        case .removed:
            print("remove the mesh")
            godotVisionCoordinator.removeMesh(id: id)
        }
    }
}
