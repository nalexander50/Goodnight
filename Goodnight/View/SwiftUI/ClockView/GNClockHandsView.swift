//
//  GNClockHandsView.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import SwiftUI

struct GNClockHandsView: View {

    var body: some View {
        GeometryReader { geomtry in
            Path { path in
                let center = self.center(of: geomtry.size)

            }
        }
    }

    // MAR: - Private Methods

    private func center(of size: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }
}

struct GNClockHandsView_Previews: PreviewProvider {
    static var previews: some View {
        GNClockHandsView().frame(width: 200, height: 200, alignment: .center).padding()
    }
}
