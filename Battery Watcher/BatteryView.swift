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
    
    var body: some View {
        Text("Battery Percentage \(batteryPercentage)")
            .onReceive(timer) {
                firedDate in
                batteryPercentage = pollBatteryPercent()
                if (batteryPercentage <= 20 || batteryPercentage >= 80){
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Battery Alert"),
                        message: Text("Stop/Start charging!")
                    )
                }
    }
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
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
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]

            // Pull out the name and capacity
            if let name = info[kIOPSNameKey] as? String,
                let capacity = info[kIOPSCurrentCapacityKey] as? Int,
                let max = info[kIOPSMaxCapacityKey] as? Int {
                print("\(name): \(capacity) of \(max)")
                return capacity
            }
        }
        return -1
    }
    
    func pushNotification(_percent: Int) {
        let content = UNMutableNotificationContent()
        content.title="Battery Watcher Update"
        if (_percent != -1 && _percent <= 20){
            content.body="Charge your computer!"
        }
        else if (_percent != -1 && _percent >= 80){
            content.body="Stop charging your computer!"
        }
        
       // let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: nil)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
      
       
        notificationCenter.add(request) { (error) in
           if error != nil {
               print("error")
           }
        }
        print("hello???")
    }
    
}

struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryView()
    }
}
