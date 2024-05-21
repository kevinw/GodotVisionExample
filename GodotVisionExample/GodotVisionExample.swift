//  Created by Kevin Watters on 12/27/23.

import SwiftUI

// visionOS will silently clamp to volume size if set above or below limits
// max for all dimensions is 1.98
// min for all dimensions is 0.24
let VOLUME_SIZE = simd_double3(1.8, 1.0, 1.5)

@main
@MainActor
struct GodotVisionExample: App {
    @State private var model = EntityModel()
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
        .windowStyle(.plain)
        
        WindowGroup(id: "error") {
            Text("An error occurred; check the app's logs for details.")
        }
        
        ImmersiveSpace(id: "scene") {
            ContentView().environment(model)
        }
    }
}
