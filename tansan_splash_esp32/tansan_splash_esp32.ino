#include <Wire.h>
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run ｀make menuconfig｀ to and enable it
#endif

BluetoothSerial SerialBT;

#define MPU6050_ADDR 0x68
#define MPU6050_AX  0x3B
#define MPU6050_AY  0x3D
#define MPU6060_AZ  0x3F
short int AccX, AccY, AccZ;
float AccX_f = 0.0f, AccY_f = 0.0f, AccZ_f = 0.0f;
int count = 0;
int send_count = 0;
boolean a = true;

void setup() {
  SerialBT.begin("Tansan");
  //  i2c as a master
  Wire.begin();
  // wake it up
  Wire.beginTransmission(MPU6050_ADDR);
  Wire.write(0x6B);
  Wire.write(0);
  Wire.endTransmission();
}

void loop() {
  // send start address
  Wire.beginTransmission(MPU6050_ADDR);
  Wire.write(MPU6050_AX);
  Wire.endTransmission();
  // request 6bytes
  Wire.requestFrom(MPU6050_ADDR, 6);
  // get 6bytes
  AccX = Wire.read() << 8;  AccX |= Wire.read();
  AccY = Wire.read() << 8;  AccX |= Wire.read();
  AccZ = Wire.read() << 8;  AccZ |= Wire.read();
  // filtering
  AccX_f = 0.9 * AccX_f + 0.1 * AccX;
  AccY_f = 0.9 * AccY_f + 0.1 * AccY;
  AccZ_f = 0.9 * AccZ_f + 0.1 * AccZ;
  /*// debug monitor
    SerialBT.print(AccX_f, 5);
    SerialBT.print("  ");
    SerialBT.print(AccY_f, 5);
    SerialBT.print("  ");
    SerialBT.print(AccZ_f, 5);
    SerialBT.println("");*/
  if ( AccY_f > -1000) {
    if (a) {
      count++;
      a = false;
    }
  } else {
    a = true;
  }
  if (-200 < AccX_f && AccX_f < 250  && -16700 < AccY_f &&  AccY_f < -16500) {
    send_count++;
  } else {
    send_count = 0;
  }
  if (send_count > 10) {
    if (count > 0) {
      SerialBT.println(count);
      count = 0;
      send_count = 0;
    }
  }
  delay(20);
}
