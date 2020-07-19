//
//  HLYTimePicker.swift
//  Hourly 3
//
//  Created by Chris Jones on 16/07/2020.
//

import SwiftUI
import Combine

struct HLYTimePicker: View {
    @Binding var hour: Int
    @Binding var minute: Int

    @State var isEditingHour: Bool = true

    var indicatorHourAngle: Angle { .degrees(Double(hour * hourScale + 180)) }
    var indicatorMinuteAngle: Angle { .degrees(Double(minute * minuteScale + 180)) }

    let hourScale: Int = 15
    let minuteScale: Int = 6

    var body: some View {
        let ourView = GeometryReader { geometry in
            let tickOffset = min(geometry.size.height, geometry.size.width) / 2

            ZStack {
                // Dummy circle to define our boundary
                Circle()
                    .stroke(Color.blue)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .padding(1)
                    .opacity(0.0)

                // Render the ticks and labels
                ForEach(0..<60) { tickPosition in
                    let angle = tickPosition * minuteScale
                    if angle % 30 == 0 {
                        // This is an hour tick
                        let correctedAngle: Int = angle + 180

                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Color.white)
                            .frame(width:2, height: 3)
                            .offset(y: tickOffset - 1)
                            .rotationEffect(.degrees(Double(angle)))
                        HStack {
                            Text(String(format: "%02d", angle/(isEditingHour ? hourScale : minuteScale)))
                                .font(.footnote)
                                .rotationEffect(.degrees(Double(-correctedAngle)))
                        }
                        .offset(y: tickOffset - 15)
                        .rotationEffect(.degrees(Double(correctedAngle)))
                    } else {
                        // This is a minute tick
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Color.gray)
                            .frame(width: 1, height: 5)
                            .opacity(0.5)
                            .offset(y: tickOffset - 2)
                            .rotationEffect(.degrees(Double(angle)))
                    }
                }

                // Orange marker ball
                Circle()
                    .fill(Color.orange)
                    .frame(width: 5, height: 5)
                    .offset(y: tickOffset - 2)
                    .rotationEffect(self.isEditingHour ? self.indicatorHourAngle : self.indicatorMinuteAngle)
                    .animation(.linear)

                // Pickers
                HStack() {
                    // Hour
                    Picker("", selection: $hour) {
                        ForEach(0..<24) {
                            Text(String(format: "%02d", $0))
                                .font(.title3)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth:40, maxHeight: 40)
                    .onTapGesture {
                        self.isEditingHour = true
                    }

                    // Separator
                    Text(":")
                        .font(.title3)
                        .padding(.bottom, 5)

                    // Minute
                    Picker("", selection: $minute) {
                        ForEach(0..<60) {
                            Text(String(format: "%02d", $0))
                                .font(.title3)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: 40, maxHeight: 40)
                    .onTapGesture {
                        self.isEditingHour = false
                    }
                }
                .frame(height: 50)
            }
            .navigationTitle("Back")
        }
        return ourView
    }
}

#if DEBUG
struct HLYTimePicker_PreviewHelper: View {
    @State private var hour: Int = 9
    @State private var minute: Int = 41

    var body: some View {
        HLYTimePicker(hour: $hour, minute: $minute)
    }
}

struct HLYTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        HLYTimePicker_PreviewHelper()
    }
}
#endif
