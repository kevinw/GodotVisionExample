/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A handler that keeps track of plane anchors.
*/

import Foundation
import ARKit
import RealityKit
import GodotVision

class PlaneAnchorHandler {
    var rootEntity: Entity
    
    init(rootEntity: Entity) {
        self.rootEntity = rootEntity
    }

    @MainActor
    func process(_ anchorUpdate: AnchorUpdate<PlaneAnchor>, _ godotVisionCoordinator: GodotVisionCoordinator) async {
        let anchor = anchorUpdate.anchor
        let id = anchor.id
        switch anchorUpdate.event {
        case .added, .updated:
            break
            var id = anchor.id
            let vertices = anchor.geometry.meshVertices.asSIMD3(ofType: Float.self)
            let faces = anchor.geometry.meshFaces.asUInt16Array()
            let transform = anchor.originFromAnchorTransform
            godotVisionCoordinator.addOrUpdatePlane(id: id, vertices: vertices, faces: faces, transform: transform)
        case .removed:
            break
            godotVisionCoordinator.removePlane(id: id)
        }
    }
}
