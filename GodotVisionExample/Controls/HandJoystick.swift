//  Created by Kevin Watters on 10/1/24.

import simd
import ARKit

final class HandJoystick {
    enum Mode {
        case ThumbJoystick, HoldingInvisibleJoystick
    }
    
    var mode: Mode = .HoldingInvisibleJoystick
    var deadZoneRadians: Float = 0.15
    
    var activated: Bool = false
    var smoothedWP: simd_float3 = .zero
    var smoothedNormal: simd_float3 = .zero
    
    func checkNaNs() -> Bool {
        var foundNaN = false
        if smoothedWP.hasNaN { print("hasNaN: smoothedThumbWorldPos"); foundNaN = true }
        if smoothedNormal.hasNaN { print("hasNaN: smoothedThumbDirNormal"); foundNaN = true }
        return foundNaN
    }
    
    func update(handAnchor: HandAnchor, deltaTime: TimeInterval) {
        guard handAnchor.isTracked, let skel = handAnchor.handSkeleton else {
            activated = false
            return
        }
        
        let handOriginFromAnchorTransform = handAnchor.originFromAnchorTransform
        func worldPos(_ jointName: HandSkeleton.JointName) -> simd_float3 {
            matrix_multiply(handOriginFromAnchorTransform, skel.joint(jointName).anchorFromJointTransform).columns.3.xyz
        }
        
        let wristWP = worldPos(.forearmWrist)
        
        let fingerTips: [HandSkeleton.JointName] = [ .indexFingerTip, .middleFingerTip, .ringFingerTip, .littleFingerTip ]
        let deltas  = fingerTips.map { wristWP - worldPos($0) }
        let T: Float = 0.16
        activated = deltas.allSatisfy { length($0) < T }
        
        let normalsDelta = deltaTime * 20
        
        if mode == .ThumbJoystick {
            let thumbTipWP = worldPos(.thumbTip)
            let thumbIntermediateTipWP = worldPos(.thumbIntermediateTip)
            let positionDelta = Float(deltaTime * 14.0) * (0.8 + distance(smoothedWP, thumbTipWP))
            let thumbPointDir = normalize(thumbTipWP - thumbIntermediateTipWP)
            smoothedNormal.mixTowards(thumbPointDir, t: normalsDelta)
            smoothedWP.mixTowards(thumbTipWP, t: positionDelta)
        } else if mode == .HoldingInvisibleJoystick {
            let wps = fingerTips.map { worldPos($0) }
            let vectors = (0..<fingerTips.count - 1).map { wps[$0] - wps[$0 + 1] }
            var averageNormalAlongFingers = normalize(average(vectors))
            
            if averageNormalAlongFingers.angleTo(.up) < deadZoneRadians {
                averageNormalAlongFingers = .up // TODO smoothstep
            }
            
            
            smoothedNormal.mixTowards(averageNormalAlongFingers, t: normalsDelta)
            let posTarget = worldPos(.indexFingerTip)
            let positionDelta = Float(deltaTime * 14.0) * (0.8 + distance(smoothedWP, posTarget))
            smoothedWP.mixTowards(posTarget, t: positionDelta)
        } else {
            fatalError("unknown mode \(mode)")
        }
        
        if checkNaNs() {
            activated = false
            smoothedWP = .zero
            smoothedNormal = .up
        }
    }
    
}
