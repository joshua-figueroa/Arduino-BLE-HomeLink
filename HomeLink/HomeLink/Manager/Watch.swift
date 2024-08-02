//
//  Watch.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 7/1/24.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    var getStarted: Bool = false
    
    override init() {
        super.init()
    }
    
    func activateSession(_ getStarted: Bool) {
        if WCSession.isSupported() {
            self.getStarted = getStarted
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func checkPermission(getStarted: Bool) {
        sendMessage(["getStarted": getStarted])
    }
    
    func checkConnection(isArduinoConnected: Bool) {
        sendMessage(["connected": isArduinoConnected])
    }
    
    func sendCharacteristicValue(key: String, val: Float) {
        sendMessage([key: val])
    }
    
    func sendSignalValue(key: String, val: Int) {
        sendMessage([key: val])
    }
    
    private func sendMessage(_ data: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("Session is not activated")
            return
        }
        
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        WCSession.default.transferUserInfo(data)
    }

    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WatchConnectivity session activation failed: \(error.localizedDescription)")
        } else {
            print("WatchConnectivity session activated with state: \(activationState.rawValue)")
            // Send get started data
            self.checkPermission(getStarted: self.getStarted)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive
        session.activate()
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        session.activate()
    }

    // Additional required delegate methods
    func sessionWatchStateDidChange(_ session: WCSession) {
        // Handle changes in the watch state
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.checkConnection(isArduinoConnected: session.isReachable)
            print("Reachability changed: \(session.isReachable)")
        }
    }
}
