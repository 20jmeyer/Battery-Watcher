//
//  BatteryManager.swift
//  Battery Watcher
//
//  Created by Jacob Meyer on 4/26/25.
//
import Foundation
import UserNotifications
import IOKit.ps

class BatteryManager: ObservableObject {
    private var timer: Timer?
    
    init() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "interval") == nil {
                print("no interval found")
                defaults.set(60.0, forKey: "interval")  // Set to 60 seconds if missing
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                    print("Notification permission granted!")
            } else if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
            }
        }
        startMonitoring()
    }
    func updateCheckInterval(_ newInterval: Double){
        print("Updating timer interval to: \(newInterval)")
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: newInterval, repeats: true) { _ in
            self.checkBattery()
        }
    }
    private func startMonitoring() {
        var checkInterval = UserDefaults.standard.double(forKey: "interval")
        if checkInterval <= 0{
            print("interval was \(checkInterval)")
            checkInterval = 60
        } else {
            print(checkInterval)
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { _ in
            self.checkBattery()
        }
    }
    private func checkBattery() {
        let level = pollBatteryLevel()
        let lowThreshold = UserDefaults.standard.integer(forKey: "lowThreshold")
        let highThreshold = UserDefaults.standard.integer(forKey: "highThreshold")
        print("Level is : \(level)")
        if level <= lowThreshold {
            self.sendNotification(title: "Battery Low", body: "Your battery is low!")
        } else if level >= highThreshold {
            self.sendNotification(title: "Battery High", body: "Your battery is high!")
        }
    }
    private func sendNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
       // let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
       
        center.add(request)
    }
    private func pollBatteryLevel() -> Int{
        // Take a snapshot of all the power source info
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()

        // Pull out a list of power sources
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

        for ps in sources {
            
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as? [String: Any]

            if let capacity = info?[kIOPSCurrentCapacityKey as String] as? Int {
                return (capacity)
            }
        }
        return -1
    }
}
