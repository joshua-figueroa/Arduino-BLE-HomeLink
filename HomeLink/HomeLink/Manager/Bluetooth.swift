//
//  Bluetooth.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/19/24.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    
    @Published var isConnected = false
    @Published var deviceState: CBManagerState = .unknown
    @Published var temperature = Sensor.newSensor
    @Published var humidity = Sensor.newSensor
    @Published var airQuality = Sensor.newSensor
    @Published var signalStrength: Int = 0
    
    let serviceUUID = CBUUID(string: "181A")
    let tempCharacteristicUUID = CBUUID(string: "2A6E")
    let humidityCharacteristicUUID = CBUUID(string: "2A6F")
    let airQualityCharacteristicUUID = CBUUID(string: "2BD3")
    
    override init() {
        super.init()
    }
    
    func startScanning() {
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        } else {
            centralManager?.scanForPeripherals(withServices: [serviceUUID], options: nil)
        }
    }
}

extension BLEManager {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.deviceState = central.state
        
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name, name == "Arduino" {
            self.peripheral = peripheral
            self.peripheral?.delegate = self
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
            
            DispatchQueue.main.async { [self] in
                signalStrength = getSignalStrength(rssi: RSSI.intValue)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.isConnected = true
        self.deviceState = central.state
        peripheral.discoverServices([serviceUUID])
        peripheral.readRSSI()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        print("Device is disconnected")
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        
        self.isConnected = false
        self.temperature.resetSensorData()
        self.humidity.resetSensorData()
        self.airQuality.resetSensorData()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, timestamp: CFAbsoluteTime, isReconnecting: Bool, error: (any Error)?) {
        print("Device is disconnected")
        if isReconnecting {
            print("Reconnecting...")
        }
        
        self.isConnected = false
        self.temperature.resetSensorData()
        self.humidity.resetSensorData()
        self.airQuality.resetSensorData()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([tempCharacteristicUUID, humidityCharacteristicUUID, airQualityCharacteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Characteristic: \(characteristic.uuid)")
                if [tempCharacteristicUUID, humidityCharacteristicUUID, airQualityCharacteristicUUID].contains(characteristic.uuid) {
                    peripheral.readValue(for: characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Characteristic UUID: \(characteristic.uuid)")
        
        if characteristic.uuid == tempCharacteristicUUID {
            let tempValue: Float = readValue(from: characteristic.value!)
            
            print("Temperature: \(tempValue) °C")
            DispatchQueue.main.async {
                self.temperature.updateSensorData(from: tempValue)
            }
        } else if characteristic.uuid == humidityCharacteristicUUID {
            let humidValue: Float = readValue(from: characteristic.value!)
            
            print("Humidity: \(humidValue) %")
            DispatchQueue.main.async {
                self.humidity.updateSensorData(from: humidValue)
            }
        } else if characteristic.uuid == airQualityCharacteristicUUID {
            let qualityValue: UInt8 = readValue(from: characteristic.value!)
            
            print("Air Quality: \(qualityValue) ppm")
            DispatchQueue.main.async {
                self.airQuality.updateSensorData(from: Float(qualityValue))
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: (any Error)?) {
        if let error = error {
            print("Error reading RSSI: \(error.localizedDescription)")
            return
        }
        DispatchQueue.main.async { [self] in
            signalStrength = getSignalStrength(rssi: RSSI.intValue)
        }
        
        // Update RSSI frequently
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            peripheral.readRSSI()
        }
    }
    
    private func readValue<T>(from data: Data) -> T {
        return data.withUnsafeBytes { $0.load(as: T.self) }
    }
    
    private func getSignalStrength(rssi: Int) -> Int {
        var signalStrength: Int {
            switch rssi {
                case ..<(-90):
                    return 0
                case (-90)..<(-70):
                    return 1
                case (-70)..<(-50):
                    return 2
                case (-50)...:
                    return 3
                default:
                    return 0
            }
        }
        
        return signalStrength
    }
}

class MockBLEManager: BLEManager {
    init(isConnected: Bool) {
        super.init()
        
        self.isConnected = isConnected
        self.deviceState = .poweredOn
        self.signalStrength = 3
        
        self.temperature = Sensor.mockTempData
        self.humidity = Sensor.mockHumidityData
        self.airQuality = Sensor.mockAirQualityData
    }
    
    override func startScanning() {
        print("Mock Scanning...")
    }
}
