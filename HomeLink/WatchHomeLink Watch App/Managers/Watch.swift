//
//  Watch.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 7/1/24.
//

import WatchConnectivity
import SwiftUI

class PhoneSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = PhoneSessionManager()

    @Published var isConnected: Bool = false
    @Published var getStarted: Bool = false
    @Published var temperature: Float = 0.0
    @Published var humidity: Float = 0.0
    @Published var airQuality: Float = 0.0
    @Published var signalStrength: Int = 0
    @Published var rssi: Int = 0
    @Published var sessionActive: Bool = false

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WatchConnectivity session activation failed: \(error.localizedDescription)")
        } else {
            print("WatchConnectivity session activated with state: \(activationState.rawValue)")
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Session State: \(session.isReachable)")
        DispatchQueue.main.async {
            self.sessionActive = session.isReachable
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            self.updateContext(with: userInfo)
        }
    }
    
    private func updateContext(with context: [String: Any]) {
        if let temperature = context["temperature"] as? Float {
            self.temperature = temperature
        }
        if let humidity = context["humidity"] as? Float {
            self.humidity = humidity
        }
        if let airQuality = context["airQuality"] as? Float {
            self.airQuality = airQuality
        }
        if let signal = context["signal"] as? Int {
            self.signalStrength = signal
        }
        if let rssi = context["rssi"] as? Int {
            self.rssi = rssi
        }
        if let connected = context["connected"] as? Bool {
            self.isConnected = connected
        }
        if let getStarted = context["getStarted"] as? Bool {
            self.getStarted = getStarted
        }
    }
}

class MockWatchSession: PhoneSessionManager {
    init(isConnected: Bool, getStarted: Bool = true) {
        super.init()
        self.isConnected = isConnected
        self.getStarted = getStarted
        self.sessionActive = true
        self.signalStrength = 3
        self.rssi = -69
        
        self.temperature = Sensor.mockTempData.data
        self.humidity = Sensor.mockHumidityData.data
        self.airQuality = Sensor.mockAirQualityData.data
    }
}
