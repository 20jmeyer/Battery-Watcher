//
//  BatteryView.swift
//  Battery Watcher
//
//  Created by Jacob Meyer on 3/21/23.
//

import SwiftUI
import IOKit.ps
import UserNotifications


struct BatteryView: View {
    @State var batteryPercentage: Int = 50
    @State private var showAlert = false
    @State private var allowAlert = true;
    
    var body: some View {
        Text("Battery Percentage \(batteryPercentage)")
            .onReceive(timer) {
                firedDate in
                batteryPercentage = pollBatteryPercent()
                if (allowAlert && (batteryPercentage <= 20 || batteryPercentage >= 80)){
                    showAlert = true
                    allowAlert = false
                }
            }
            .onReceive(otherTimer){
                _ in
                allowAlert=true;
            }
            .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Battery Alert"),
                        message: Text("Stop/Start charging!")
                    )
                }
        
    }
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    let otherTimer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    /*
    func checkBattery(per: Int)-> Bool{
        let currentPercent = pollBatteryPercent()
        if (currentPercent <= 20 || currentPercent >= 80){
            return true
           // show=true
            //pushNotification(_percent: currentPercent)
        }
    }
    */
    func pollBatteryPercent() -> Int{
        // Take a snapshot of all the power source info
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()

        // Pull out a list of power sources
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

        // For each power source...
        for ps in sources {
            // Fetch the information for a given power source out of our snapshot
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as? [String: Any]

            // Pull out the name and capacity
            if let capacity = info?[kIOPSCurrentCapacityKey as String] as? Int,
               let max = info?[kIOPSMaxCapacityKey] as? Int {
                return (capacity * 100)
            }
        }
        return -1
    }
    
    func pushNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
       // let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
       
        center.add(request)
    }
    
}

struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryView()
    }
}
