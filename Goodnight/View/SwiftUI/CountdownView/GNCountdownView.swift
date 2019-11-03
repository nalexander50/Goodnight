//
//  GNCountdownView.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/27/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Combine
import SwiftUI

struct GNCountdownView: View {
    @ObservedObject var viewModel: GNCountdownViewModel

    var body: some View {
        VStack {
            if self.viewModel.isFinished {
                Text("Goodnight!")
            } else {
                VStack {
                    Text("Countdown").bold().offset(x: 0, y: 20)
                    Spacer()
                    VStack {
                        Text("Sleeping in").fontWeight(.light).offset(x: 0, y: -10)
                        Text(self.viewModel.countdownMessage)
                    }
                    Spacer()
                    Button(
                        action: { self.viewModel.cancelSleepTimer() },
                        label: { Text("Cancel Sleep Timer") }
                    ).offset(x: 0, y: -20)
                }
            }
        }.frame(width: 230, height: 230, alignment: .center)
    }
}

struct GNCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        GNCountdownView(viewModel: GNCountdownViewModel(targetDate: Date().addingTimeInterval(10)))
    }
}
