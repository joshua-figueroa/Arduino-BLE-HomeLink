#include <DHT11.h>
#include <ArduinoBLE.h>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>

DHT11 dht11(4);
LiquidCrystal_I2C lcd(0x27, 20, 4);

BLEService environmentalService("181A"); // Environmental Sensing Service UUID
BLEIntCharacteristic tempCharacteristic("2A6E", BLERead | BLENotify); // Temperature characteristic UUID
BLEIntCharacteristic humidityCharacteristic("2A6F", BLERead | BLENotify); // Humidity characteristic UUID
BLEIntCharacteristic airQualityCharacteristic("2BD3", BLERead | BLENotify); // Air Quality (Volatile Compounds) characteristic UUID

String getAirQuality(int gasLevel) {
  if(gasLevel < 181) {
    return "Good";
  } else if (gasLevel >= 181 && gasLevel < 225) {
    return "Poor";
  } else if (gasLevel >=225 && gasLevel < 300) {
    return "Bad";
  }

  return "Toxic";
}

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // Init LCD
  lcd.init();
  lcd.backlight();

  // Initialize BLE
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");
    while (1);
  }

  BLE.setLocalName("Arduino");
  BLE.setAdvertisedService(environmentalService);

  environmentalService.addCharacteristic(tempCharacteristic);
  environmentalService.addCharacteristic(humidityCharacteristic);
  environmentalService.addCharacteristic(airQualityCharacteristic);
  BLE.addService(environmentalService);

  // Set initial values
  tempCharacteristic.writeValue(0);
  humidityCharacteristic.writeValue(0);
  airQualityCharacteristic.writeValue(0);

  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");
}

void loop() {
  lcd.setCursor(0,0);
  lcd.print("Arduino BLE HomeLink");

  lcd.setCursor(0,1);
  lcd.print("Status: Connecting..");
  // Listen for BLE peripherals to connect
  BLEDevice central = BLE.central();

  if (central) {
    lcd.setCursor(0, 1);
    lcd.print("Status: Connected   ");
    Serial.print("Connected to central: ");
    Serial.println(central.address());
    int temperature = 0;
    int humidity = 0;

    while (central.connected()) {
      int airSensorValue = analogRead(0); 
      int tempTemp = temperature;
      int tempHumid = humidity;
      int result = dht11.readTemperatureHumidity(tempTemp, tempHumid);

      // Display temp on LCD
      lcd.setCursor(0, 2);
      lcd.print("Temp:");
      lcd.setCursor(6, 2);
      lcd.print(tempTemp);

      // Display humidity on LCD
      lcd.setCursor(10, 2);
      lcd.print("Humid:");
      lcd.setCursor(17, 2);
      lcd.print(tempHumid);

      // Display air quality
      lcd.setCursor(0, 3);
      lcd.print("AQI:");
      lcd.setCursor(5, 3);
      lcd.print(airSensorValue);
      lcd.setCursor(10, 3);
      lcd.print(getAirQuality(airSensorValue));

      Serial.print("Temperature:");
      Serial.print(tempTemp);
      Serial.print(",");
      Serial.print("Humidity:");
      Serial.println(tempHumid);

      if (tempTemp != temperature) {
        // Only update temp when needed
        tempCharacteristic.writeValue(tempTemp);
        temperature = tempTemp;
      }

      if (tempHumid != humidity) {
        // Only update humidity when needed
        humidityCharacteristic.writeValue(tempHumid);
        humidity = tempHumid;
      }

      // Always rewrite air quality
      airQualityCharacteristic.writeValue(airSensorValue);

      delay(100);
    }

    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
}
