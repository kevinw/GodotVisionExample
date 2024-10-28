//  Created by Kevin Watters on 10/11/24.

import ARKit
import UIKit

final class HandTracking: ObservableObject {
    private let session = ARKitSession()
    private let provider = HandTrackingProvider()
    private var handJoystick = HandJoystick()
    private var sessionRunTask: Task<Void, Error>? = nil
    
    var leftAxis: simd_float3 { get {
        if handJoystick.activated {
            return handJoystick.smoothedNormal
        } else {
            return .zero
        }
    }}
    
    func update(deltaTime: TimeInterval) {
        if provider.state == .running {
            let (leftHandAnchor, _) = provider.handAnchors(at: CACurrentMediaTime())
            if let leftHandAnchor {
                handJoystick.update(handAnchor: leftHandAnchor, deltaTime: deltaTime)
            }
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        if enabled {
            if sessionRunTask == nil {
                sessionRunTask = Task {
                    do {
#if !targetEnvironment(simulator)
                        print("starting ARKitSession...")
                        try await session.run([provider])
                        print("started ARKitSession")
#endif
                    } catch {
                        print("ERROR starting ARKitSession:", error)
                    }
                }
            }
        } else {
            handJoystick.activated = false
            sessionRunTask?.cancel()
            sessionRunTask = nil
        }
    }
}
