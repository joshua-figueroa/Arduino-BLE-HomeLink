//
//  Sensor.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/23/24.
//

import Foundation

struct Sensor: Identifiable, Codable {
    let id: UUID
    var data: Float
    var fetching: Bool
    
    init(id: UUID = UUID(), data: Float = 0, fetching: Bool = true) {
        self.id = id
        self.data = data
        self.fetching = fetching
    }
    
    static var newSensor: Sensor {
        Sensor()
    }
    
    mutating func updateSensorData(from data: Float) {
        self.data = data
        self.fetching = false
    }
    
    mutating func resetSensorData() {
        self.data = 0
        self.fetching = true
    }
}

extension Sensor {
    static var mockTempData = Sensor(data: 24.5, fetching: false)
    static var mockHumidityData = Sensor(data: 69.8, fetching: false)
    static var mockAirQualityData = Sensor(data: 50, fetching: false)
}
