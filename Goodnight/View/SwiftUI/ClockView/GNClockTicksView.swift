//
//  GNClockTicksView.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import SwiftUI

struct GNClockTicksView: View {

    // MARK: - Constants

    private let circleDegrees = 360
    private let hoursCount = 12
    private let minutesCount = 60

    // MARK: - Properties

    var strokeColor: Color = Color.gray
    var relativeTickLength: CGFloat = 0.10

    // MARK: - State

    @State var includeHours: Bool = true
    @State var includeMinutes: Bool = false

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.hoursCount) { hour in
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height * self.relativeTickLength))
                }
                .stroke(self.strokeColor)
                .rotationEffect(Angle(degrees: Double(self.circleDegrees / self.hoursCount * hour)))
            }
        }
    }

    // todo maybe add numbers
}

// MARK: - Preview

struct GNClockTicksView_Previews: PreviewProvider {
    static var previews: some View {
        GNClockTicksView().frame(width: 200, height: 200, alignment: .center).padding()
    }
}
