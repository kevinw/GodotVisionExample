//  Created by Kevin Watters on 10/11/24.

import SwiftUI

struct ScenePhaseWatcher: ViewModifier {
    @Environment(\.scenePhase) private var enviornmentScenePhase
    @Binding var scenePhase: ScenePhase
    
    func body(content: Content) -> some View {
        content.onChange(of: enviornmentScenePhase) { oldValue, newValue in
            scenePhase = newValue
        }
    }
}

extension View {
    func readScenePhaseTo(_ scenePhase: Binding<ScenePhase>) -> some View {
        modifier(ScenePhaseWatcher(scenePhase: scenePhase))
    }
}
