//
//  HLYTimePickerExperimentApp.swift
//  HLYTimePickerExperiment WatchKit Extension
//
//  Created by Chris Jones on 16/07/2020.
//

import SwiftUI

@main
struct HLYTimePickerExperimentApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
