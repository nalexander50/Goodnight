//
//  DatePickerView.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import SwiftUI

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
            }.padding(.horizontal, 20).tabItem {
                Text("For")
            }.tag(0)

            Text("Until").tabItem {
                Text("Until")
            }.tag(1)
        }.padding(.all, 20).frame(width: 230, height: 300, alignment: .center)
    }

    private var forView: some View {
        Text("")
    }

    private var clockView: some View {
        Text("")
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        GNDatePickerView(viewModel: GNDatePickerViewModel())
    }
}
