//
//  Battery_WatcherApp.swift
//  Battery Watcher
//
//  Created by Jacob Meyer on 3/21/23.
//

import SwiftUI

@main
struct Battery_WatcherApp: App {
    @StateObject private var batteryManager = BatteryManager()
    var body: some Scene {
        WindowGroup {
            SettingsView()
            //BatteryView()
        }
    }
}
