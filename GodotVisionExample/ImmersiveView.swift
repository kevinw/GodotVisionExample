//  Created by Kevin Watters on 12/27/23.

import SwiftUI
import RealityKit
// import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            /*
            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(scene)
            }
             */
            
            print("TODO: I removed the RealityKitContent bundle for now, trying to get commandline builds working.")
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
