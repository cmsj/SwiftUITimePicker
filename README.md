# Time Picker Experiment

This is an attempt to clone the watchOS Alarm app's time picker, using SwiftUI.

So far it's pretty functional, with a few differences in behaviour.

# Code

It's all in one file, [here](https://github.com/cmsj/SwiftUITimePicker/blob/main/HLYTimePickerExperiment%20WatchKit%20Extension/ContentView.swift)

# Demo
![demo](demo.gif)

# Todo

 * Figure out a way to make the Picker sizing more dynamic, it looks bad on 40mm watches and probably worse with large Dynamic Type sizing
 * Picker value scrolling doesn't wrap around like it does in the Alarm app. Not sure this is possible in SwiftUI
 * To be completely accurate, the orange ball should rotate smoothly as the Digital Crown turns, but at the moment it is driven purely by the Picker value changes
