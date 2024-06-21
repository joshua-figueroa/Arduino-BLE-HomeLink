#include <DHT11.h>
#include <ArduinoBLE.h>

DHT11 dht11(4);

BLEService environmentalService("181A"); // Environmental Sensing Service UUID
BLEIntCharacteristic tempCharacteristic("2A6E", BLERead | BLENotify); // Temperature characteristic UUID
BLEIntCharacteristic humidityCharacteristic("2A6F", BLERead | BLENotify); // Humidity characteristic UUID

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // Initialize BLE
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");
    while (1);
  }

  BLE.setLocalName("ArduinoBLE");
  BLE.setAdvertisedService(environmentalService);

  environmentalService.addCharacteristic(tempCharacteristic);
  environmentalService.addCharacteristic(humidityCharacteristic);
  BLE.addService(environmentalService);

  // Set initial values
  tempCharacteristic.writeValue(0.0);
  humidityCharacteristic.writeValue(0.0);

  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");
}

void loop() {
  // Listen for BLE peripherals to connect
  BLEDevice central = BLE.central();

  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());
    int temperature = 0;
    int humidity = 0;

    while (central.connected()) {
      int tempTemp = temperature;
      int tempHumid = humidity;
      int result = dht11.readTemperatureHumidity(tempTemp, tempHumid);

      Serial.print("Temperature:");
      Serial.print(temperature);
      Serial.print(",");
      Serial.print("Humidity:");
      Serial.println(humidity);

      if (tempTemp != temperature) {
        // Only update temp when needed
        tempCharacteristic.writeValue(temperature);
        temperature = tempTemp;
      }

      if (tempHumid != humidity) {
        // Only update humidity when needed
        humidityCharacteristic.writeValue(humidity);
        humidity = tempHumid;
      }

      delay(100);
    }

    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
}