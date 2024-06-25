#include <DHT.h>
#include <ArduinoBLE.h>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>

#define DHTPIN 4  
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);
LiquidCrystal_I2C lcd(0x27, 20, 4);

BLEService environmentalService("181A"); // Environmental Sensing Service UUID
BLEFloatCharacteristic tempCharacteristic("2A6E", BLERead | BLENotify); // Temperature characteristic UUID
BLEFloatCharacteristic humidityCharacteristic("2A6F", BLERead | BLENotify); // Humidity characteristic UUID
BLEIntCharacteristic airQualityCharacteristic("2BD3", BLERead | BLENotify); // Air Quality (Volatile Compounds) characteristic UUID

String getAirQuality(int gasLevel) {
  if(gasLevel < 181) {
    return "Good ";
  } else if (gasLevel >= 181 && gasLevel < 225) {
    return "Poor ";
  } else if (gasLevel >=225 && gasLevel < 300) {
    return "Bad  ";
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

  // Init DHT22
  pinMode(DHTPIN, INPUT);
  dht.begin();

  BLE.setLocalName("Arduino");
  BLE.setAdvertisedService(environmentalService);

  environmentalService.addCharacteristic(tempCharacteristic);
  environmentalService.addCharacteristic(humidityCharacteristic);
  environmentalService.addCharacteristic(airQualityCharacteristic);
  BLE.addService(environmentalService);

  // Set initial values
  tempCharacteristic.writeValue(0.0);
  humidityCharacteristic.writeValue(0.0);
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
    float temperature = 0;
    float humidity = 0;
    int aqi = 0;

    while (central.connected()) {
      int airSensorValue = analogRead(0); 
      float tempTemp = temperature;
      float tempHumid = humidity;
    
      tempHumid = dht.readHumidity();
      tempTemp = dht.readTemperature();

      // Display temp on LCD
      lcd.setCursor(0, 2);
      lcd.print("Temp:");
      lcd.setCursor(6, 2);
      lcd.print(tempTemp, 1);

      // Display humidity on LCD
      lcd.setCursor(0, 3);
      lcd.print("Humid:");
      lcd.setCursor(7, 3);
      lcd.print(tempHumid, 1);

      // // Display air quality
      lcd.setCursor(12, 2);
      lcd.print("AQI:");
      lcd.setCursor(17, 2);
      lcd.print(airSensorValue);
      lcd.setCursor(15, 3);
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

      if (airSensorValue != aqi) {
        // Only update AQI when needed
        airQualityCharacteristic.writeValue(airSensorValue);
        aqi = airSensorValue;
      }

      delay(100);
    }

    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
}
