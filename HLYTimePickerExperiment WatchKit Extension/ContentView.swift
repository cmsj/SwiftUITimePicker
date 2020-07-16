//
//  ContentView.swift
//  HLYTimePickerExperiment WatchKit Extension
//
//  Created by Chris Jones on 16/07/2020.
//

import SwiftUI
import Combine

let hourScale = 15
let minuteScale = 6

class TimeModel: ObservableObject {
    @Published var hour: Int = 9
    @Published var minute: Int = 41
    @Published var hourAngle: Angle = .degrees(0)
    @Published var minuteAngle: Angle = .degrees(0)
    @Published var isHour: Bool = true

    private var angleHourCancellable: AnyCancellable? = nil
    private var angleMinuteCancellable: AnyCancellable? = nil

    init() {
        angleHourCancellable = $hour.sink(receiveValue: { [self] (hour) in
            hourAngle = .degrees(Double(hour * hourScale) + 180)
        })
        angleMinuteCancellable = $minute.sink(receiveValue: { [self] (minute) in
            minuteAngle = .degrees(Double(minute * minuteScale) + 180)
        })
    }
}

struct MainTickView: View {
    let tickOffset: CGFloat
    let angle: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
            .fill(Color.white)
            .frame(width:2, height: 3)
            .offset(y: tickOffset - 1)
            .rotationEffect(.degrees(Double(angle)))
    }
}

struct SubTickView: View {
    let tickOffset: CGFloat
    let angle: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
            .fill(Color.gray)
            .frame(width: 1, height: 5)
            .opacity(0.5)
            .offset(y: tickOffset - 2)
            .rotationEffect(.degrees(Double(angle)))
    }
}

struct ContentView: View {
    @EnvironmentObject var lolTime: TimeModel

    var body: some View {
        GeometryReader { geometry in
            let tickOffset = min(geometry.size.height, geometry.size.width) / 2

            ZStack {
                // Dummy circle to define our boundary
                Circle()
                    .stroke(Color.blue)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .padding(0)
                    .opacity(0.0)

                // Orange marker ball
                Circle()
                    .fill(Color.orange)
                    .frame(width: 5, height: 5)
                    .offset(y: tickOffset - 2)
                    .rotationEffect(lolTime.isHour ? lolTime.hourAngle : lolTime.minuteAngle)
                    .animation(.linear)

                // Main ticks
                ForEach(0..<12) { hour in
                    MainTickView(tickOffset: tickOffset, angle: hour * hourScale * 2)
                }

                // Sub ticks
                ForEach(0..<60) { minute in
                    let angle = minute * minuteScale
                    if angle % 30 != 0 {
                        SubTickView(tickOffset: tickOffset, angle: minute * minuteScale)
                    }
                }

                // Numbers (hours or minutes)
                ForEach(0..<12) { hour in
                    let angle = hour * hourScale * 2
                    let correctedAngle = angle + 180
                    HStack {
                        Text(String(format: "%02d", angle/(lolTime.isHour ? hourScale : minuteScale)))
                            .font(.footnote)
                            .rotationEffect(.degrees(Double(-correctedAngle)))
                    }
                    .offset(y: tickOffset - 15)
                    .rotationEffect(.degrees(Double(correctedAngle)))
                }

                // Pickers
                HStack() {
                    // Hour
                    Picker("", selection: $lolTime.hour) {
                        ForEach(0..<24) {
                            Text(String(format: "%02d", $0))
                                .font(.title3)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth:40, maxHeight: 40)
                    .onTapGesture {
                        self.lolTime.isHour = true
                    }

                    // Separator
                    Text(":")
                        .font(.title3)
                        .padding(.bottom, 5)

                    // Minute
                    Picker("", selection: $lolTime.minute) {
                        ForEach(0..<60) {
                            Text(String(format: "%02d", $0))
                                .font(.title3)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: 40, maxHeight: 40)
                    .onTapGesture {
                        self.lolTime.isHour = false
                    }
                }
                .frame(height: 50)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(TimeModel())
        }
    }
}
