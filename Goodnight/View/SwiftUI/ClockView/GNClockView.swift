//
//  GNClockView.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import SwiftUI

struct GNClockView: View {

    var strokeColor: Color = Color.white

    var body: some View {
        ZStack {
            Circle().stroke(self.strokeColor)
            GNClockTicksView()
            GNClockHandsView()
        }
    }
}

struct GNClockView_Previews: PreviewProvider {
    static var previews: some View {
        GNClockView().frame(width: 200, height: 200, alignment: .center).padding()
    }
}
