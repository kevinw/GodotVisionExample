//  Created by Kevin Watters on 12/27/23.

import SwiftUI

let VOLUME_SIZE = simd_double3(2.0, 1.0, 1.5)

@main
struct GodotVisionExample: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: VOLUME_SIZE.x, height: VOLUME_SIZE.y, depth: VOLUME_SIZE.z, in: .meters)
    }
}
