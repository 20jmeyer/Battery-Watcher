//
//  SettingsView.swift
//  Battery Watcher
//
//  Created by Jacob Meyer on 4/26/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("lowThreshold") private var lowThreshold = 20
    @AppStorage("highThreshold") private var highThreshold = 80
    @AppStorage("interval") private var interval = 60.0
    var body: some View {
        Form {
            Section(header: Text("Battery Thresholds")) {
                Stepper("Low Battery Threshold: \(lowThreshold)%", value: $lowThreshold, in: 5...50)
                Stepper("High Battery Threshold: \(highThreshold)%", value: $highThreshold, in: 50...100)
            }
            Section(header: Text("Check Interval")){
                Stepper("Check every \(Int(interval)) seconds", value: $interval, in: 10...600, step: 10)
            }
        }
        .padding()
        .frame(width: 300)
    }
}

#Preview {
    SettingsView()
}
