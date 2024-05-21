/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Extensions and utilities.
*/

import Foundation
import RealityKit
import UIKit
import ARKit

extension GeometrySource {
    func asArray<T>(ofType: T.Type) -> [T] {
        assert(MemoryLayout<T>.stride == stride, "Invalid stride \(MemoryLayout<T>.stride); expected \(stride)")
        return (0..<count).map {
            buffer.contents().advanced(by: offset + stride * Int($0)).assumingMemoryBound(to: T.self).pointee
        }
    }
    
    func asSIMD3<T>(ofType: T.Type) -> [SIMD3<T>] {
        asArray(ofType: (T, T, T).self).map { .init($0.0, $0.1, $0.2) }
    }
    
    subscript(_ index: Int32) -> (Float, Float, Float) {
        precondition(format == .float3, "This subscript operator can only be used on GeometrySource instances with format .float3")
        return buffer.contents().advanced(by: offset + (stride * Int(index))).assumingMemoryBound(to: (Float, Float, Float).self).pointee
    }
}

extension GeometryElement {
    subscript(_ index: Int) -> [Int32] {
        precondition(bytesPerIndex == MemoryLayout<Int32>.size,
                     """
This subscript operator can only be used on GeometryElement instances with bytesPerIndex == \(MemoryLayout<Int32>.size).
This GeometryElement has bytesPerIndex == \(bytesPerIndex)
"""
        )
        var data = [Int32]()
        data.reserveCapacity(primitive.indexCount)
        for indexOffset in 0 ..< primitive.indexCount {
            data.append(buffer
                .contents()
                .advanced(by: (Int(index) * primitive.indexCount + indexOffset) * MemoryLayout<Int32>.size)
                .assumingMemoryBound(to: Int32.self).pointee)
        }
        return data
    }
    
    func asInt32Array() -> [Int32] {
        var data = [Int32]()
        let totalNumberOfInt32 = count * primitive.indexCount
        data.reserveCapacity(totalNumberOfInt32)
        for indexOffset in 0 ..< totalNumberOfInt32 {
            data.append(buffer.contents().advanced(by: indexOffset * MemoryLayout<Int32>.size).assumingMemoryBound(to: Int32.self).pointee)
        }
        return data
    }
    
    func asUInt16Array() -> [UInt16] {
        asInt32Array().map { UInt16($0) }
    }
    
    public func asUInt32Array() -> [UInt32] {
        asInt32Array().map { UInt32($0) }
    }
}

extension simd_float4x4 {
    init(translation vector: SIMD3<Float>) {
        self.init(SIMD4<Float>(1, 0, 0, 0),
                  SIMD4<Float>(0, 1, 0, 0),
                  SIMD4<Float>(0, 0, 1, 0),
                  SIMD4<Float>(vector.x, vector.y, vector.z, 1))
    }
    
    var translation: SIMD3<Float> {
        get {
            columns.3.xyz
        }
        set {
            self.columns.3 = [newValue.x, newValue.y, newValue.z, 1]
        }
    }
    
    var rotation: simd_quatf {
        simd_quatf(rotationMatrix)
    }
    
    var xAxis: SIMD3<Float> { columns.0.xyz }
    
    var yAxis: SIMD3<Float> { columns.1.xyz }
    
    var zAxis: SIMD3<Float> { columns.2.xyz }
    
    var rotationMatrix: simd_float3x3 {
        matrix_float3x3(xAxis,
                        yAxis,
                        zAxis)
    }
    
    /// Get a gravity-aligned copy of this 4x4 matrix.
    var gravityAligned: simd_float4x4 {
        // Project the z-axis onto the horizontal plane and normalize to length 1.
        let projectedZAxis: SIMD3<Float> = [zAxis.x, 0.0, zAxis.z]
        let normalizedZAxis = normalize(projectedZAxis)
        
        // Hardcode y-axis to point upward.
        let gravityAlignedYAxis: SIMD3<Float> = [0, 1, 0]
        
        let resultingXAxis = normalize(cross(gravityAlignedYAxis, normalizedZAxis))
        
        return simd_matrix(
            SIMD4(resultingXAxis.x, resultingXAxis.y, resultingXAxis.z, 0),
            SIMD4(gravityAlignedYAxis.x, gravityAlignedYAxis.y, gravityAlignedYAxis.z, 0),
            SIMD4(normalizedZAxis.x, normalizedZAxis.y, normalizedZAxis.z, 0),
            columns.3
        )
    }
}

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}

extension SIMD2<Float> {
    /// Checks whether this point is inside a given triangle defined by three vertices.
    func isInsideOf(_ vertex1: SIMD2<Float>, _ vertex2: SIMD2<Float>, _ vertex3: SIMD2<Float>) -> Bool {
        // This point lies within the triangle given by v1, v2 & v3 if its barycentric coordinates are in range [0, 1].
        let coords = barycentricCoordinatesInTriangle(vertex1, vertex2, vertex3)
        return coords.x >= 0 && coords.x <= 1 && coords.y >= 0 && coords.y <= 1 && coords.z >= 0 && coords.z <= 1
    }
    
    /// Computes the barycentric coordinates of this point relative to a given triangle defined by three vertices.
    func barycentricCoordinatesInTriangle(_ vertex1: SIMD2<Float>, _ vertex2: SIMD2<Float>, _ vertex3: SIMD2<Float>) -> SIMD3<Float> {
        // Compute vectors between the vertices.
        let v2FromV1 = vertex2 - vertex1
        let v3FromV1 = vertex3 - vertex1
        let selfFromV1 = self - vertex1
        
        // Compute the area of:
        // 1. the passed in triangle,
        // 2. triangle "u" (v1, v3, self) &
        // 3. triangle "v" (v1, v2, self).
        // Note: The area of a triangle is the length of the cross product of the two vectors that span the triangle.
        let areaOverallTriangle = cross(v2FromV1, v3FromV1).z
        let areaU = cross(selfFromV1, v3FromV1).z
        let areaV = cross(v2FromV1, selfFromV1).z

        // The barycentric coordinates of point self are vertices v1, v2 & v3 weighted by (u, v, w).
        // Compute these weights by dividing the triangle’s areas by the overall area.
        let u = areaU / areaOverallTriangle
        let v = areaV / areaOverallTriangle
        let w = 1.0 - v - u
        return SIMD3<Float>(u, v, w)
    }
}

extension PlaneAnchor {
    static let horizontalCollisionGroup = CollisionGroup(rawValue: 1 << 31)
    static let verticalCollisionGroup = CollisionGroup(rawValue: 1 << 30)
    static let allPlanesCollisionGroup = CollisionGroup(rawValue: horizontalCollisionGroup.rawValue | verticalCollisionGroup.rawValue)
}

extension MeshResource.Contents {
    init(planeGeometry: PlaneAnchor.Geometry) {
        self.init()
        self.instances = [MeshResource.Instance(id: "main", model: "model")]
        var part = MeshResource.Part(id: "part", materialIndex: 0)
        part.positions = MeshBuffers.Positions(planeGeometry.meshVertices.asSIMD3(ofType: Float.self))
        part.triangleIndices = MeshBuffer(planeGeometry.meshFaces.asUInt32Array())
        self.models = [MeshResource.Model(id: "model", parts: [part])]
    }
}
