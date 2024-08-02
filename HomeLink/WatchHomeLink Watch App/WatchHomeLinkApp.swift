//
//  WatchHomeLinkApp.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 6/29/24.
//

import SwiftUI

@main
struct WatchHomeLink_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(watchManager: PhoneSessionManager())
        }
    }
}
