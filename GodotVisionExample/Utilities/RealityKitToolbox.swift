//  Created by Kevin Watters on 9/25/24.

import RealityKit

extension Float {
    static let tau = Float.pi * 2.0
    mutating func mixTowards(_ targetValue: Self, t: Double) { mixTowards(targetValue, t: Float(t)) }
    mutating func mixTowards(_ targetValue: Self, t: Float) { self = mix(self, targetValue, t: t) }
}

func mix(_ value: Float, _ target: Float, t: Float) -> Float {
    mix(simd_float3(value, 0, 0), simd_float3(target, 0, 0), t: simd_float3(t, 0, 0)).x
}

extension simd_float4 {
    var xyz: simd_float3 { .init(x, y, z) }
}

extension simd_float3 {
    
    // Calculate the angle in radians between this vector and another
    func angleTo(_ other: simd_float3) -> Float {
        acos(dot(self, other) / (length(self) * length(other)))
    }
    
    mutating func mixTowards(_ targetValue: Self, t: Double) { mixTowards(targetValue, t: Float(t)) }
    mutating func mixTowards(_ targetValue: Self, t: Float) { self = mix(self, targetValue, t: t) }
    
    var hasNaN: Bool {
        x.isNaN || y.isNaN || z.isNaN
    }
    static let up = simd_float3(0, 1, 0)
    static let right = simd_float3(1, 0, 0)
    static let left = simd_float3(-1, 0, 0)
    static let forward = simd_float3(0, 0, 1)
    static func random(in range: Range<Float>) -> simd_float3 {
        .init(
            .random(in: range),
            .random(in: range),
            .random(in: range)
        )
    }
    
    static func random(_ min: simd_float3, _ max: simd_float3) -> simd_float3 {
        .init(
            .random(in: min.x...max.x),
            .random(in: min.y...max.y),
            .random(in: min.z...max.z)
        )
    }
}

extension simd_quatf {
    static func random() -> Self {
        var x, y, z, u, v, w, s: Float
        while true {
            x = .random(in: -1...1)
            y = .random(in: -1...1)
            z = x*x + y*y
            if z <= 1 {
                break
            }
        }
        while true {
            u = .random(in: -1...1)
            v = .random(in: -1...1)
            w = u*u + v*v;
            if w <= 1 {
                break
            }
        }
        s = sqrt((1-z) / w)
        return .init(ix:x, iy: y, iz: s*u, r: s*v)
    }
}

@MainActor
func findModelEntityInChildren(_ entity: Entity) -> ModelEntity? {
    if let modelEntity = entity as? ModelEntity {
        return modelEntity
    }
    for child in entity.children {
        if let modelEntity = findModelEntityInChildren(child) {
            return modelEntity
        }
    }
    return nil
}

extension Entity {
    convenience init(newWithName name: String) {
        self.init()
        self.name = name
    }
    
    func findComponentInChildren(_ type: any Component.Type) -> Entity? {
        if components.has(type) {
            return self
        }
        
        for child in children {
            if let e = child.findComponentInChildren(type) {
                return e
            }
        }
        
        return nil
    }
    func removeAllChildren() {
        for child in Array(children) {
            child.removeFromParent()
        }
    }
    
    /// Executes a closure for each of the entity's child and descendant
    /// entities, as well as for the entity itself.
    ///
    /// Set `stop` to true in the closure to abort further processing of the child entity subtree.
    func enumerateHierarchy(_ body: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
        var stop = false

        func enumerate(_ body: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
            if stop {
                return
            }

            body(self, &stop)
            
            for child in children {
                if stop {
                    break
                }
                child.enumerateHierarchy(body)
            }
        }
        
        enumerate(body)
    }
    
    func setComponentOnAllModelEntities(_ component: Component) {
        enumerateHierarchy { entity, stop in
            if entity is ModelEntity {
                entity.components.set(component)
            }
        }
    }
}

func lerpAngle(_ from: Float, _ to: Float, t: Float) -> Float {
    let diff = fmod(to - from, .pi * 2.0);
    let shortest = fmod(2.0 * diff, .pi * 2.0) - diff;
    return from + shortest * t;
}

func diffAngleRadians(_ x: Float, _ y: Float) -> Float {
    var arg = fmod(y-x, .tau);
    if arg < 0 { arg  = arg + .tau }
    if arg > .pi { arg  = arg - .tau };
    return -arg
}

func average(_ vectors: [simd_float3]) -> simd_float3 {
    let total = vectors.reduce(.zero) { $0 + $1 }
    return total / Float(vectors.count)
}

