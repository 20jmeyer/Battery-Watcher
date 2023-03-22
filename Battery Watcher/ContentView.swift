//
//  ContentView.swift
//  Battery Watcher
//
//  Created by Jacob Meyer on 3/21/23.
//

import SwiftUI
import UserNotifications



struct ContentView: View {
    
    let un = UNUserNotificationCenter.current()
    var body: some View {
        Text("Hello, world!")
            .padding()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
