//
//  DatePickerView.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import SwiftUI
// https://github.com/ivicamil/clock-swiftui-sample/blob/master/Clock/Clock%20View/ClockView.swift
struct GNDatePickerView: View {
    let viewModel: GNDatePickerViewModel

    @State var selectedHours: Int = 0
    var selectedHoursString: Binding<String> {
        Binding<String>.init(get: {
            self.selectedHours.description
        }, set: { value in
            self.selectedHours = Int(value) ?? 0
            if self.selectedHours > 24 {
                self.selectedHours = 0
            }
        })
    }

    @State var selectedMinutes: Int = 0
    var selectedMinutesString: Binding<String> {
        Binding<String>.init(get: {
            self.selectedMinutes.description
        }, set: { value in
            self.selectedMinutes = Int(value) ?? 0
            if self.selectedMinutes > 59 {
                self.selectedMinutes = 0
            }
        })
    }

    @State var selectedDate: Date = Date()

    var body: some View {
        TabView {
            self.untilView.tabItem {
                Text("Until")
            }.tag(1)

            self.forView.tabItem {
                Text("For")
            }.tag(0)
        }.padding(.all, 20).frame(width: 230, height: 300, alignment: .center)
    }

    private var forView: some View {
        VStack {
            Spacer()
            TextField("hours", text: self.selectedHoursString).multilineTextAlignment(.center).frame(width: 45, alignment: .center)
            Text("hours").fontWeight(.bold)
            Divider().padding(.horizontal, 20)
            TextField("minutes", text: self.selectedMinutesString).multilineTextAlignment(.center).frame(width: 45, alignment: .center)
            Text("minutes").fontWeight(.bold)
            Spacer()
            Button(
                action: { self.viewModel.createTimer(hours: self.selectedHours, minutes: self.selectedMinutes) },
                label: { Text("Start") }
            ).padding(.bottom, 10)
        }.padding(.horizontal, 20)
    }

    private var untilView: some View {
        ZStack {
            Circle().stroke(Color.white)
            self.clockMarks
            self.clockHands
        }
        .padding()
        .aspectRatio(contentMode: .fit)

    }

    private var clockMarks: some View {
        GeometryReader { geometry in
            ForEach(0..<12) { hour in
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height * 0.10))
                }
                .stroke(Color.gray)
                .rotationEffect(Angle(degrees: Double(360 / 12 * hour)))
            }
        }
    }

    private var clockHands: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2 - 25))
            }
            .stroke(Color.red)
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        GNDatePickerView(viewModel: GNDatePickerViewModel())
    }
}
