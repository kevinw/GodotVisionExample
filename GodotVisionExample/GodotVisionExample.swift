//  Created by Kevin Watters on 12/27/23.

import SwiftUI

// visionOS will silently clamp to volume size if set above or below limits
// max for all dimensions is 1.98
// min for all dimensions is 0.24
let VOLUME_SIZE = simd_double3(1.8, 1.0, 1.5)

#if true // multiplayer
let SHAREPLAY_ACTIVITY_ID = Bundle.main.bundleIdentifier! + ".example-activity"
let multiplayerExternalEvents: Set<String> = [SHAREPLAY_ACTIVITY_ID]
#else
let multiplayerExternalEvents: Set<String> = []
#endif

@main
struct GodotVisionExample: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .handlesExternalEvents(preferring: multiplayerExternalEvents,
                                       allowing: multiplayerExternalEvents)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: VOLUME_SIZE.x, height: VOLUME_SIZE.y, depth: VOLUME_SIZE.z, in: .meters)
    }
}
