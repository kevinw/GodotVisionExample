//  Created by Kevin Watters on 10/11/24.

import SwiftGodot
import simd

func sendJoypadInput(_ leftAxis: simd_float2) {
    let JOY_FACTOR = 2.0
    
    // Left X axis
    let e = InputEventJoypadMotion()
    e.axis = JoyAxis.leftX
    e.axisValue = Double(leftAxis.x) * JOY_FACTOR
    Input.parseInputEvent(e)
    
    // Right X axis
    let e2 = InputEventJoypadMotion()
    e2.axis = JoyAxis.leftY
    e2.axisValue = Double(leftAxis.y) * JOY_FACTOR
    Input.parseInputEvent(e2)
}

