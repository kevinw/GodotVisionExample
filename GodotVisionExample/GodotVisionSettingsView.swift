//  Created by Kevin Watters on 10/8/24.

import SwiftUI
import GodotVision

struct GodotVisionSettingsView: View {
    @ObservedObject var godotVision: GodotVisionCoordinator
    
    var body: some View {
        Text("Physics FPS")
        Picker("Physics FPS", selection: $godotVision.physicsTicksPerSecond) {
            Text("30").tag(30)
            Text("60").tag(60)
            Text("90").tag(90)
        }.frame(width: 150).pickerStyle(.palette)
    }
}
