#include <SPI.h>

#include <Encoder.h>
#include <TaskScheduler.h>

const int dacChipSelectPin = 40;

const int lickSensorL = 3; //Left lick sensor out port
const int lickSensorR = 2; //Right lick sensor out port
const int solenoidL = 4; //left lick solenoid
const int solenoidR = 5; //right lick solenoid

const int resetPin = A4; //RFID reset pin
const int formPin = A5; //RFID form pin (keep low)dr
const int rfidGnd = A3; //ground pin for RFID reader (max current draw = 5 mA)
const int rfid5V = A2;
const int outputRFID = 28; //RFID soft output to prarie

const int triggerBNC = 22; //BNC connector that sends trigger to Prarie
const int outputSTIM = 24;
const int outputLICK_L = 26;
const int outputROTARY = 28; //also output for RFID sensor

const int FINAL_VALVE = 8;
const int TEST_VALVE = 43;

bool finalValve = false;
bool testValve = false;

//sensory stims
//const int airpuff = 43;
//const int audioON = 37;
//const int audioOFF = 39;
const int _4kHzTrigger = 38;
const int _10kHzTrigger = 40;
const int stopTrigger = 44;
const int valveM_NO_IN = 7;
const int valveM_NO_OUT = 33;
const int valveA_NC_IN = 10;
const int valveA_NC_OUT = 9;
const int valveB_NC_IN = 11;
const int valveB_NC_OUT = 12;
//const int lightY = 13;
//const int lightB = 47;
bool state_ctx = false;
bool enable_ctx = false;
bool state_odor_A = false;
bool enable_odor_A = false;
bool state_odor_B = false;
bool enable_odor_B = false;
//bool state_light_A = false;
//bool enable_light_A = false;
//bool state_light_B = false;
//bool enable_light_B = false;
//bool state_teensy_tone_A = false;
//bool enable_teensy_tone_A = false;
//bool state_teensy_tone_B = false;
//bool enable_teensy_tone_B = false;
bool state_mp3_tone_A = false;
bool enable_mp3_tone_A = false;
bool state_mp3_tone_B = false;
bool enable_mp3_tone_B = false;
//bool state_airpuff_A = false;
//bool enable_airpuff_A = false;
//bool state_airpuff_B = false;
//bool enable_airpuff_B = false;
int ctx_dial = 0;
int loop_ref = 0;
int loop_print = 0;
volatile float loop_time = 0;
int manual_DAC_check = 0;
///////////////////////////////////////////////////////////////////

//var for storing random position generated
long randPos = 0;
const int numRewardsPerLap = 100;
long randPosListGlobal[numRewardsPerLap];
long randPosListGlobalNext[numRewardsPerLap];
int currentRandPosIdx = 0;
const int alwaysDeliverWater = 1;
int stopWaterFromList = 0;


//randPosGenerator(randPosListGlobal,numRewardsPerLap)
//Serial.println(randPostListGlobal[0]);
//Serial.println(randPostListGlobal[1]);
//Serial.println(randPostListGlobal[2]);



//Calibrated by JM on 7/29/20
const int waterAmountL = 9500; //6500 //microseconds - 6500 us corresponds to roughly 1.0 - 1.1 uL of water delivered per droplet
const int waterAmountR = 9350; //6500 //microseconds - 6500 us corresponds to roughly 1.0 - 1.1 uL of water delivered per droplet
const float volPerDrop = 1.1; //in uL
const float cmConvFactor = 0.0155986;

volatile long previousPosition = 0;
volatile long currentPosition = 0;
volatile long currentPositionCm = 0.0;

volatile float currentTime = 0;
volatile float previousTime = 0;

volatile float speedOut = 0.00;
bool enableWaterL = true; //allow first droplet of water to dispense
bool enableWaterR = true; //allow first droplet of water to dispense

bool unlimited = true; //delivers water when mouse licks regardless of speed
bool drainValveL = false;
bool drainValveR = false;

bool onlyL = true;
bool onlyR = false;

int currentLickStateL = LOW;
int previousLickStateL = LOW;
int currentLickStateR = LOW;
int previousLickStateR = LOW;

int waterBankL = 0;
int waterBankR = 0;

int PHASE = 0;

//array holding previous run speeds - yes/no states - binary coding; NOT USED - easier and faster to do with counter
//int previousSpeeds[20]; //index address 0 - 19
volatile float timeStart = 0;
//unsigned long currentTime = 0;


float speedThreshold = 2; //speed that the mouse has to exceed in order to register as ON event in above array
int speedThresCount = 0; //counter that increments every time speed is above speedThres; once counter crosses sum of previous ON events (sum to 1s), water delivered
int countThres = 20; //if 20 previous checks (t4 timer) have returned speeds > speedThres, deliver water

float waterDispensedL = 0; //counter for how many water droplets were dispensed
float waterDispensedR = 9090; //counter for how many water droplets were dispensed

unsigned long clockStart = 0;

//lap counter - increase every time RFID tag is scanned
int lapCounter = 0;

//RFID-related variables
byte i = 0;
byte val = 0;
byte code[6]; //index from 0 to 5
byte checksum = 0;
byte bytesread = 0;
byte tempbyte = 0;

//Tag ID bytes
//byte tag1 = 0xF5; //0x88; //0x50;

//MH Novelty B
//byte tag1 = 0x99;
//MH C
//byte tag1 = 0x35;

//Jason's RFID (Red & Black plaid belt)
//byte tag1 = 0x0B;
//byte tag1 = 0x33;
//byte tag1 = 0x31;
//Maya's double sided bubble wrap
//byte tag1 = 0x71;

//byte tag1 = 0x21; //Mobius Belt 2
//byte tag1 = 0x62; //Mobius Belt 1
//byte tag1 = 0x38; //Neon plaid training belt
byte tag1 = 0x13; //Vincent Belt
//

Scheduler runner;

//Callback prototypes
void readPosAndSpeed();
void printSpeed();
void printDistance();
void checkSpeed();
void dispTimeSinceStart();
void checkLickState();
void checkRFID();
void checkKeyboardIn();
void randWaterDeliverCheck();

Task t1(10, TASK_FOREVER, &readPosAndSpeed, &runner, true); //read position and calculate speed
//Task t2(100, TASK_FOREVER, &printSpeed, &runner, true); //print speed to serial
Task t3(1000, TASK_FOREVER, &printDistance, &runner, true);  //calculate distance traveled since the beginning
//Task t4(50,TASK_FOREVER, &checkSpeed, &runner, true); //poll at 50 - record 20 positions
Task t5(1000, TASK_FOREVER, &dispTimeSinceStart, &runner, true); //display total runtime of program
Task t6(1, TASK_FOREVER, &checkLickState, &runner, true); //check if the mouse is licking every 1 ms
Task t7(20, TASK_FOREVER, &checkRFID, &runner, true); //check RFID and do something...reset position, deliver reward, reset # of licks
Task t8(100, TASK_FOREVER, &checkKeyboardIn, &runner, true);
Task t9(10, TASK_FOREVER, &randWaterDeliverCheck, &runner, true);

//rotary encoder setup using 2 interrupts - place this on a serial port coming in from Atilla encoder chip
Encoder wheel(18, 19);

void readPosAndSpeed()
{
  previousPosition = currentPosition;
  previousTime = currentTime;
  currentPosition = -wheel.read(); //current position always stored
  currentPositionCm = currentPosition * cmConvFactor;

  currentTime = millis();
  speedOut = ((currentPosition - previousPosition) * cmConvFactor) / ((currentTime - previousTime) / 1000);
}

void printSpeed()
{
  Serial.print("Speed is: "); Serial.print(speedOut, DEC); Serial.println(" cm/s");
  Serial.println(speedThresCount, DEC);
}

void printDistance()
{
  Serial.print("Rewards/Lap: ");
  if(unlimited == true)
  {
    Serial.println("Unlimited");
  }
  else
  {
    Serial.println(numRewardsPerLap);
  }
  Serial.print("Left Port: ");
  if(!onlyR)
  {
    Serial.print("ENABLED");
  }
  else
  {
    Serial.print("DISABLED");
  }
  Serial.print("     Right Port: ");
  if(!onlyL)
  {
    Serial.println("ENABLED");
  }
  else
  {
    Serial.println("DISABLED");
  }
  
  Serial.print("Distance traveled forward: "); Serial.print(currentPosition * cmConvFactor, 3); Serial.println(" cm");
  Serial.print("Amount of water dispensed left: "); Serial.print((int) waterDispensedL, DEC); Serial.println(" drops");
  Serial.print("Amount of water dispensed right: "); Serial.print((int) waterDispensedR, DEC); Serial.println(" drops");
  //Serial.print("Volume dispensed: "); Serial.print((waterDispensedL + waterDispensedR)* volPerDrop, 2); Serial.println(" uL");
  Serial.print("Volume dispensed: "); Serial.print((waterDispensedL)* volPerDrop, 2); Serial.println(" uL");
  Serial.print("Full laps traveled "); Serial.println(lapCounter - 1);
  Serial.println("");

  //  randPosGenerator(randPosListGlobal,numRewardsPerLap);
  //  for(int idx=0; idx <= (numRewardsPerLap-1); idx++)
  //  {
  //    Serial.println(randPosListGlobal[idx]);
  //  }


}


void indexAlert()
{
  Serial.println("index!");
}

void deliverWaterL()
{
  if (enableWaterL)
  {
    digitalWrite(solenoidL, HIGH);
    Serial.println("Water delivered Left"); Serial.println("");
    waterDispensedL++;
    delayMicroseconds(waterAmountL);
    digitalWrite(solenoidL, LOW);

    enableWaterL = false; //must clear this state to true before next drop of water is delivered
  }
}

void deliverWaterR()
{
  if (enableWaterR)
  {
    digitalWrite(solenoidR, HIGH);
    Serial.println("Water delivered Right"); Serial.println("");
    waterDispensedR++;
    delayMicroseconds(waterAmountR);
    digitalWrite(solenoidR, LOW);

    enableWaterR = false; //must clear this state to true before next drop of water is delivered
  }
}
void randPosGenerator(long randPosList[], int numRewards)
{
  //randomSeed(millis());
  for (int idx = 0; idx <= (numRewards - 1); idx++)
  {
    randPosList[idx] =  random(0, 200);
    //Serial.println(randPosList[idx]);
  }

}

void GOLPosGenerator(long randPosList[], int numRewards)
{
  //randomSeed(millis());
  for (int idx = 0; idx <= (numRewards - 1); idx++)
  {
    randPosList[idx] =  random(80, 90);
    //Serial.println(randPosList[idx]);
  }

}

void GOLPosGenerator2(long randPosList[], int numRewards)
{
  //randomSeed(millis());
  for (int idx = 0; idx <= (numRewards - 1); idx++)
  {
    randPosList[idx] =  random(140, 150);
    //Serial.println(randPosList[idx]);
  }

}

void GOLPosGenerator3(long randPosList[], int numRewards)
{
  //randomSeed(millis());
  for (int idx = 0; idx <= (numRewards - 1); idx++)
  {
    randPosList[idx] =  random(20, 30);
    //Serial.println(randPosList[idx]);
  }

}

void randWaterDeliverCheck()
{
  //Serial.println(currentRandPosIdx);
  //Serial.println(((int) currentPositionCm));
  if (currentRandPosIdx <= (numRewardsPerLap - 1))
  {
    if (((int) currentPositionCm) > randPosListGlobal[currentRandPosIdx])
    {
      if (random(0, 100) > 50)
      {
        if (alwaysDeliverWater == 1)
        {
          enableWaterL = true;
        }
        Serial.println("XXXXXXXXXXXXXX");
        Serial.println(((int) currentPositionCm));
        Serial.println(randPosListGlobal[currentRandPosIdx]);
        waterBankL++;
        //deliverWaterL();
        signalStim();
        currentRandPosIdx++;
      }
      else
      {
        if (alwaysDeliverWater == 1)
        {
          enableWaterR = true;
        }
        Serial.println("XXXXXXXXXXXXXX");
        Serial.println(((int) currentPositionCm));
        Serial.println(randPosListGlobal[currentRandPosIdx]);
        waterBankR++;
        //deliverWaterR();
        signalStim();
        currentRandPosIdx++;
      }
    }
  }

}

void checkSpeed()
{

  if (speedOut > speedThreshold)
  {
    speedThresCount++;

    if (speedThresCount == countThres)
    {
      //enableWaterL = true;
      deliverWaterL();
      speedThresCount = 0;
    }

  }
  else
  {
    speedThresCount = 0;
  }
}

void checkLickState()
{
  int currentLickStateL = digitalRead(lickSensorL);

  if ((currentLickStateL == HIGH) && (previousLickStateL == LOW))
  {

    Serial.println("Mouse licking left");
    enableWaterL = true;

    if (unlimited == true & random(0, 100) > 100 * ((waterDispensedL + 10)/ (waterDispensedL + waterDispensedR + 21)))
    {
      deliverWaterL();
    }
    else
    {
      if ((waterBankL > 0) && (!onlyR))
      {
        if (PHASE==1)
        {
          //Serial.println("PHASE 1");
          if ((currentPosition*cmConvFactor>90) && (currentPosition*cmConvFactor<100))
          {          
            deliverWaterL();
            waterBankL--;
          }
        }
        else if( PHASE==2 )
        {
          if ((currentPosition*cmConvFactor>150) && (currentPosition*cmConvFactor<160))
          {          
            deliverWaterL();
            waterBankL--;
          }
        }
        else if( PHASE==3 )
        {
          if ((currentPosition*cmConvFactor>30) && (currentPosition*cmConvFactor<40))
          {          
            deliverWaterL();
            waterBankL--;
          }
        }
        else
        {
          //Serial.println("PHASE 2");
          deliverWaterL();
          waterBankL--;
        }
      }
    }
    previousLickStateL = currentLickStateL;
  }
  else if (currentLickStateL != previousLickStateL)
  {
    previousLickStateL = currentLickStateL;
  }

  int currentLickStateR = digitalRead(lickSensorR);
  //Serial.println("L");
  //Serial.println(currentLickStateL);
  //Serial.println("R");
  //Serial.println(currentLickStateR);
  
  if ((currentLickStateR == HIGH) && (previousLickStateR == LOW))
  {

    Serial.println("Mouse licking right");
    enableWaterR = true;

    if (unlimited == true & random(0, 100) > 100 * ((waterDispensedR + 10)/ (waterDispensedL + waterDispensedR + 21)))
    {
      deliverWaterR();
    }
    else
    {
      if ((waterBankR > 0) && (!onlyL))
      {
        if (PHASE==1)
        {
          if ((currentPosition*cmConvFactor>90) && (currentPosition*cmConvFactor<100))
          {          
            deliverWaterR();
            waterBankR--;  
          }
        }
        else if( PHASE==2 )
        {
          if ((currentPosition*cmConvFactor>150) && (currentPosition*cmConvFactor<160))
          {          
            deliverWaterR();
            waterBankR--;
          }
        }
        else if( PHASE==3 )
        {
          if ((currentPosition*cmConvFactor>30) && (currentPosition*cmConvFactor<40))
          {          
            deliverWaterR();
            waterBankR--;
          }
        }
        else
        {
          deliverWaterR();
          waterBankR--;
        }
      }
    }
    previousLickStateR = currentLickStateR;
  }
  else if (currentLickStateR != previousLickStateR)
  {
    previousLickStateR = currentLickStateR;
  }

}

void dispTimeSinceStart()
{
  unsigned long currentClock = millis() - clockStart;

  unsigned long currentSec = currentClock / 1000; //works
  unsigned long currentMin = currentSec / 60;
  unsigned long currentSecLeft = currentSec % 60;

  Serial.print("Program running for: "); Serial.print(currentMin, DEC); Serial.print(":");
  if (currentSecLeft < 10)
  {
    Serial.print("0");
  }
  Serial.println(currentSecLeft, DEC);
}

void checkRFID()
{
  i = 0;
  val = 0;
  code[6];
  checksum = 0;
  bytesread = 0;
  tempbyte = 0;

  if (Serial2.available() > 0) {
    Serial.println("Available!");
    unsigned long timeStart = millis();

    if ((val = Serial2.read()) == 2) {                 // check for header
      bytesread = 0;

      while (bytesread < 12) {                        // read 10 digit code + 2 digit checksum
        if ( Serial2.available() > 0) {
          val = Serial2.read();

          if ((val == 0x0D) || (val == 0x0A) || (val == 0x03) || (val == 0x02)) { // DEC: 13 = \r ,10 = \n,3 - stop,2 - start if header or stop bytes before the 10 digit reading
            break;                                    // stop reading
          }

          // Do Ascii --> Hex conversion:
          if ((val >= '0') && (val <= '9')) {
            val = val - '0';
          } else if ((val >= 'A') && (val <= 'F')) {
            val = 10 + val - 'A';
          }
          // val is now hex value

          // Every two hex-digits, add byte to code: //look at how the LSB changes
          if (bytesread & 1 == 1) {
            // make some space for this hex-digit by
            // shifting the previous hex-digit with 4 bits to the left:
            code[bytesread >> 1] = (val | (tempbyte << 4)); //divide by 2 with every run and use as index for ea

            if (bytesread >> 1 != 5) {                // If we're at the checksum byte,
              checksum ^= code[bytesread >> 1];       // Calculate the checksum... (XOR) - XOR each value into ongoing checksum
            };
          } else {
            tempbyte = val;                           // Store the first hex digit first...
          };

          bytesread++;                                // ready to read next digit
          Serial.println(bytesread, BIN);
        }
      }

      // Output to Serial:

      if (bytesread == 12) {                          // if 12 digit read is complete
        //unsigned long timeDiff = millis() - timeStart;
        Serial.println("Tag!");
        Serial.println(code[4]);
        //Serial.println(timeDiff);
        if (code[4] == tag1)
        {
          Serial.println("Lap!");
          signalRFID();
          lapCounter++;
          //deliverWater(); enable water on every lap
          wheel.write(0); //zeros out the position on the rotary encoder read
          //need to update before check on next index
          readPosAndSpeed();
          //          currentPosition = -wheel.read(); //current position always stored
          //          currentPositionCm = currentPosition*cmConvFactor;

          //Assign next positions to current
          //memcpy(randPosListGlobal,randPosListGlobalNext,numRewardsPerLap);

          //Generate next positions
          if(PHASE==1)
          {
            GOLPosGenerator(randPosListGlobal, numRewardsPerLap);
          } 
          else if(PHASE==2)
          {
            GOLPosGenerator2(randPosListGlobal, numRewardsPerLap);
          }
          else if(PHASE==3)
          {
            GOLPosGenerator3(randPosListGlobal, numRewardsPerLap);
          }
          else
          {
            randPosGenerator(randPosListGlobal, numRewardsPerLap);             
          }
          //randPosGenerator(randPosListGlobal, numRewardsPerLap);
          sort(randPosListGlobal, numRewardsPerLap);

          for (int idx = 0; idx <= (numRewardsPerLap - 1); idx++)
          {
            Serial.println(randPosListGlobal[idx]);
          }
          currentRandPosIdx = 0;
          //stopWaterFromList = 0;

          waterBankL = waterBankL / 2;
          waterBankR = waterBankR / 2;
        }
      }
      bytesread = 0;
    }
  }
}

void checkKeyboardIn()
{
  char serialInput = Serial.read();

  if (serialInput == 'w')
  {
    enableWaterL = true;
    deliverWaterL();
  }
  else if (serialInput == 'e')
  {
    enableWaterR = true;
    deliverWaterR();
  }
  else if (serialInput == 'd')
  {
    if (drainValveL == false)
    {
      drainValveL = true;
      digitalWrite(solenoidL, HIGH);
      Serial.println("%%%%%%%%%% DRAINING LEFT VALVE %%%%%%%%%%%%%%!!!");
    }
    else if (drainValveL == true)
    {
      drainValveL = false;
      digitalWrite(solenoidL, LOW);
      Serial.println("%%%%%%%%%% LEFT VALVE CLOSED %%%%%%%%%%%%%%!!!");
    }
  }
  else if (serialInput == 'f')
  {
    if (drainValveR == false)
    {
      drainValveR = true;
      digitalWrite(solenoidR, HIGH);
      Serial.println("%%%%%%%%%% DRAINING RIGHT VALVE %%%%%%%%%%%%%%!!!");
    }
    else if (drainValveR == true)
    {
      drainValveR = false;
      digitalWrite(solenoidR, LOW);
      Serial.println("%%%%%%%%%% RIGHT VALVE CLOSED %%%%%%%%%%%%%%!!!");
    }
  }
  else if (serialInput == 'x')
  {
    onlyL = true;
    onlyR = false;
  }
  else if (serialInput == 'c')
  {
    onlyL = false;
    onlyR = true;
  }
  else if (serialInput == 'z')
  {
    onlyL = false;
    onlyR = false;
  }
  else if (serialInput == 'p')
  {
    PHASE = (PHASE+1) % 4;
    if (PHASE == 0)
    {
      int waterBankL = 0;
      Serial.println("^^^^^^^^^^^^^^^^^^^^^^^^^^ RF ^^^^^^^^^^^^^^^^^^^^^^^^^^");
    }
    else if (PHASE == 1)
    {
      int waterBankL = 10000;
      Serial.println("^^^^^^^^^^^^^^^^^^^^^^^^^^ GOL 1 ^^^^^^^^^^^^^^^^^^^^^^^^^^");
    }
    else if (PHASE == 2)
    {
      int waterBankL = 10000;
      Serial.println("^^^^^^^^^^^^^^^^^^^^^^^^^^ GOL 2 ^^^^^^^^^^^^^^^^^^^^^^^^^^");
    }
    else if (PHASE == 3)
    {
      int waterBankL = 10000;
      Serial.println("^^^^^^^^^^^^^^^^^^^^^^^^^^ GOL 3 ^^^^^^^^^^^^^^^^^^^^^^^^^^");
    }
  }
  else if (serialInput == 'u')
  {
    unlimited = !unlimited;
    if(unlimited == true)
    {
      onlyL = true;
      onlyR = false;
      Serial.println("+++++++++++++++++++++ WATER UNLIMITED +++++++++++++++++++++");
    }
    else if (unlimited == false)
    {
      onlyL = true;
      onlyR = false;
      Serial.println("+++++++++++++++++++++ WATER RESTRAINED +++++++++++++++++++++");
    }
  }
  else if (serialInput == 'h')
  {
    if (finalValve == false)
    {
      finalValve = true;
      digitalWrite(FINAL_VALVE, HIGH);
      Serial.println("%%%%%%%%%% FINAL VALVE HIGH %%%%%%%%%%%%%%!!!");
    }
    else if (finalValve == true)
    {
      finalValve = false;
      digitalWrite(FINAL_VALVE, LOW);
      Serial.println("%%%%%%%%%% FINAL VALVE LOW %%%%%%%%%%%%%%!!!");
    }
  }
  else if (serialInput == 'j')
  {
    if (testValve == false)
    {
      testValve = true;
      digitalWrite(TEST_VALVE, HIGH);
      Serial.println("%%%%%%%%%% TEST VALVE HIGH %%%%%%%%%%%%%%!!!");
    }
    else if (testValve == true)
    {
      testValve = false;
      digitalWrite(TEST_VALVE, LOW);
      Serial.println("%%%%%%%%%% TEST VALVE LOW %%%%%%%%%%%%%%!!!");
    }
  }
  else if (serialInput == 'n')
  {
    if (manual_DAC_check == 0)
    {
      manual_DAC_check = 1;
      setDAC(4000, 0);
      Serial.println("_____________________ DAC check HIGH _____________________");
    }
    else if (manual_DAC_check == 1)
    {
      manual_DAC_check = 0;
      setDAC(0, 0);
      Serial.println("_____________________ DAC check LOW _____________________");
    }
  }
//sensory stims
  else if (serialInput == 'v')
  {
    if (enable_ctx == false)
    {
      enable_ctx = true;
      ctx_dial = 0;
      Serial.println("******************** context ENABLED ********************"); 
    }
    else if (enable_ctx == true)
    {
      enable_ctx = false;
      ctx_dial = 0;
      Serial.println("******************** context DISABLED ********************");  
    }
  }
  else if (serialInput == 'b')
  {
    if (enable_ctx == true)
    {
      if (ctx_dial == 1)
      {
        ctx_dial = 0;
        Serial.println("######################## CONTEXT A ########################");
        /*enable_airpuff_A = true;
        t10.enable();
        Serial.println("airpuff_A ENABLED");  
        enable_airpuff_B = false;
        t15.disable();
        Serial.println("airpuff_B DISABLED");
        enable_teensy_tone_A = true;
        t11.enable();
        Serial.println("teensy tone_A ENABLED");
        enable_teensy_tone_B = false;
        t16.disable();
        Serial.println("teensy tone_B DISABLED");*/
        enable_mp3_tone_A = true;
        //t12.enable();
        Serial.println("mp3 tone_A ENABLED");
        enable_mp3_tone_B = false;
        //t17.disable();
        Serial.println("mp3 tone_B DISABLED");
        /*enable_light_A = true;
        t13.enable();
        Serial.println("light_A ENABLED");
        enable_light_B = false;
        t18.disable();
        Serial.println("light_B DISABLED");*/
        enable_odor_A = true;
        //t14.enable();
        Serial.println("odor_A ENABLED");
        enable_odor_B = false;
        //t19.disable();
        Serial.println("odor_B DISABLED");
      }
      else if (ctx_dial == 0)
      {
        ctx_dial = 1;
        Serial.println("######################## CONTEXT B ########################");
        /*enable_airpuff_A = false;
        t10.disable();
        Serial.println("airpuff_A DISABLED");  
        enable_airpuff_B = true;
        t15.enable();
        Serial.println("airpuff_B ENABLED");
        enable_teensy_tone_A = false;
        t11.disable();
        Serial.println("teensy tone_A DISABLED");
        enable_teensy_tone_B = true;
        t16.enable();
        Serial.println("teensy tone_B ENABLED");*/
        enable_mp3_tone_A = false;
        //t12.disable();
        Serial.println("mp3 tone_A DISABLED");
        enable_mp3_tone_B = true;
        //t17.enable();
        Serial.println("mp3 tone_B ENABLED");
        /*enable_light_A = false;
        t13.disable();
        Serial.println("light_A DISABLED");
        enable_light_B = true;
        t18.enable();
        Serial.println("light_B ENABLED");*/
        enable_odor_A = false;
        //t14.disable();
        Serial.println("odor_A DISABLED");
        enable_odor_B = true;
        //t19.enable();
        Serial.println("odor_B ENABLED");
      }
    }
    else if (enable_ctx == false)  
    {
      ctx_dial = 0;
      /*enable_airpuff_A = false;
      t10.disable(); 
      enable_airpuff_B = false;
      t15.disable();
      enable_teensy_tone_A = false;
      t11.disable();
      enable_teensy_tone_B = false;
      t16.disable();*/
      enable_mp3_tone_A = false;
      //t12.disable();
      enable_mp3_tone_B = false;
      //t17.disable();
      /*enable_light_A = false;
      t13.disable();
      enable_light_B = false;
      t18.disable();*/
      enable_odor_A = false;
      //t14.disable();
      enable_odor_B = false;
      //t19.disable();
      Serial.println("#################### CONTEXT TERMINATED ####################");
    }
  }
  /*else if (serialInput == 'b')
  {
    if (enable_airpuff_2 == false)
    {
      enable_airpuff_2 = true;
      t15.enable();
      Serial.println("airpuff_2 ENABLED");  
    } 
    else if (enable_airpuff_2 == true)
    {
      enable_airpuff_2 = false;
      t15.disable();
      Serial.println("airpuff_2 DISABLED");  
    } 
  }*/
 /* else if (serialInput == 't')
  {
    if (enable_teensy_tone == false)
    {
      enable_teensy_tone = true;
      t11.enable();
      Serial.println("tone ENABLED");  
    } 
    else if (enable_teensy_tone == true)
    {
      enable_teensy_tone = false;
      t11.disable();
      Serial.println("tone DISABLED");  
    } 
  }*/
  /*else if (serialInput == 'm')
  {
    if (enable_mp3_tone == false)
    {
      enable_mp3_tone = true;
      t12.enable();
      Serial.println("tone ENABLED");  
    } 
    else if (enable_mp3_tone == true)
    {
      enable_mp3_tone = false;
      t12.disable();
      Serial.println("tone DISABLED");  
    } 
  }*/
  /*else if (serialInput == 'l')
  {
    if (enable_light == false)
    {
      enable_light = true;
      t13.enable();
      Serial.println("light ENABLED");  
    } 
    else if (enable_light == true)
    {
      enable_light = false;
      t13.disable();
      Serial.println("light DISABLED");  
    } 
  }*/
  /*else if (serialInput == 'o')
  {
    if (enable_odor == false)
    {
      enable_odor = true;
      t14.enable();
      Serial.println("odor ENABLED");  
    } 
    else if (enable_odor == true)
    {
      enable_odor = false;
      t14.disable();
      Serial.println("odor DISABLED");  
    } 
  }*/
///////////////////////////////////////////////////////////////////
}

void signalRFID()
{
  digitalWrite(outputRFID, HIGH); //PORTA = PORTA | B01000000; //set 28 high
  delayMicroseconds(200);
  digitalWrite(outputRFID, LOW); //PORTA = PORTA | B00000000; //set 28 low
  //delayMicroseconds(200);
}

void signalStim()
{
  digitalWrite(outputSTIM, HIGH); //PORTA = PORTA | B00000100; //set 24 high
  delayMicroseconds(200);
  digitalWrite(outputSTIM, LOW); //PORTA = PORTA | B00000000; //set 24 low
  //delayMicroseconds(200);
}

void signalTrigger()
{
  digitalWrite(triggerBNC, HIGH); //PORTA = PORTA | B00000100; //set 24 high
  delayMicroseconds(200);
  digitalWrite(triggerBNC, LOW); //PORTA = PORTA | B00000000; //set 24 low
  //delayMicroseconds(200);
}


void sort(long a[], int size)
{
  for (int i = 0; i < (size - 1); i++) {
    for (int o = 0; o < (size - (i + 1)); o++) {
      if (a[o] > a[o + 1]) {
        long t = a[o];
        a[o] = a[o + 1];
        a[o + 1] = t;
      }
    }
  }
}

void setup() {
  // put your setup code here, to run once:

  //DAC chip select pin setup
  pinMode (dacChipSelectPin, OUTPUT);
  // set the ChipSelectPins high ini tially:
  digitalWrite(dacChipSelectPin, HIGH);

  // initialise SPI:
  SPI.begin();
  SPI.setBitOrder(MSBFIRST);         // Not strictly needed but just to be sure.
  SPI.setDataMode(SPI_MODE0);        // Not strictly needed but just to be sure.
  // Set SPI clock divider to 16, therfore a 1 MhZ signal due to the maximum frequency of the ADC.
  SPI.setClockDivider(SPI_CLOCK_DIV16);

  //set the DAC to Prarie to 0V output (digital value from 0 - 4095)
  //setDAC(4000, 0); ///set out to zero volts
  setDAC(0, 0); ///set out to zero volts

  randomSeed(analogRead(0));

  Serial.begin(115200);
  Serial2.begin(9600);
  //Serial.println("Encoder start");

  pinMode(solenoidL, OUTPUT);
  digitalWrite(solenoidL, LOW);
  if (drainValveL == true)
  {
    digitalWrite(solenoidL, HIGH);
  }
  else
  {
    digitalWrite(solenoidL, LOW);
  }

  pinMode(solenoidR, OUTPUT);
  digitalWrite(solenoidR, LOW);
  if (drainValveR == true)
  {
    digitalWrite(solenoidR, HIGH);
  }
  else
  {
    digitalWrite(solenoidR, LOW);
  }

  pinMode(lickSensorL, INPUT); //A9
  pinMode(lickSensorR, INPUT); //A9
  digitalWrite(lickSensorL, LOW);
  digitalWrite(lickSensorR, LOW);
  
  //pinMode(lickSensorR, INPUT);
  //pinMode(A8, OUTPUT);
  //pinMode(A10, OUTPUT);

//sensory stims
  /*pinMode(airpuff, OUTPUT);
  digitalWrite(airpuff,LOW);
  if (enable_airpuff_A == true || enable_airpuff_B == true)
  {
    if (state_airpuff_A == true || state_airpuff_B == true)
    {
      digitalWrite(airpuff, HIGH);
    }
    else
    {
      digitalWrite(airpuff, LOW);
    }
  }
  else
  {
    digitalWrite(airpuff, LOW);
  }*/

  //COMPLETE OTHER SENSORY SETUPS
  
  //Teensy communication for audio tone frequency/
  //Serial3.begin(38400);
  
  //audio controls for teensy board
  /*pinMode(audioON, OUTPUT);
  pinMode(audioOFF, OUTPUT);
  digitalWrite(audioON, LOW);
  digitalWrite(audioOFF, HIGH);
  if (enable_teensy_tone_A == true || enable_teensy_tone_B == true)
  {
    if (state_teensy_tone_A == true || state_teensy_tone_B == true)
    {
      digitalWrite(audioON, HIGH);
      digitalWrite(audioOFF, LOW);
    }
    else
    {
      digitalWrite(audioON, LOW);
      digitalWrite(audioOFF, HIGH);
    }
  }
  else
  {
    digitalWrite(audioON, LOW);
    digitalWrite(audioOFF, HIGH);
  }

  //setup serial with Teensy for audio comm
  Serial3.println('A');
  char teensyCompare = 'B';
  while(teensyCompare != 'A')
  {
    teensyCompare = Serial3.read();
  }

  Serial.println("Teensy handshake passed");*/

  pinMode(valveM_NO_IN, OUTPUT);
  pinMode(valveM_NO_OUT, OUTPUT);
  pinMode(valveA_NC_IN, OUTPUT);
  pinMode(valveA_NC_OUT, OUTPUT);
  pinMode(valveB_NC_IN, OUTPUT);
  pinMode(valveB_NC_OUT, OUTPUT);
  pinMode(FINAL_VALVE, OUTPUT);
  digitalWrite(valveM_NO_IN, LOW); 
  digitalWrite(valveM_NO_OUT, LOW);
  digitalWrite(valveA_NC_IN, LOW); 
  digitalWrite(valveA_NC_OUT, LOW);
  digitalWrite(valveB_NC_IN, LOW); 
  digitalWrite(valveB_NC_OUT, LOW); 
  digitalWrite(FINAL_VALVE, LOW);
  if (enable_odor_A == true || enable_odor_B == true)
  {
    if (state_odor_A == true || state_odor_B == true)
    {
      digitalWrite(valveM_NO_IN, HIGH); 
      digitalWrite(valveM_NO_OUT, HIGH); 
      digitalWrite(valveA_NC_IN, HIGH);  
      digitalWrite(valveA_NC_OUT, HIGH); 
      digitalWrite(valveB_NC_IN, HIGH); 
      digitalWrite(valveB_NC_OUT, HIGH); 
      digitalWrite(FINAL_VALVE, HIGH);
    }
    else
    {
      digitalWrite(valveM_NO_IN, LOW); 
      digitalWrite(valveM_NO_OUT, LOW);
      digitalWrite(valveA_NC_IN, LOW); 
      digitalWrite(valveA_NC_OUT, LOW);
      digitalWrite(valveB_NC_IN, LOW); 
      digitalWrite(valveB_NC_OUT, LOW); 
      digitalWrite(FINAL_VALVE, LOW);
    }
  }
  else
  {
    digitalWrite(valveM_NO_IN, LOW); 
    digitalWrite(valveM_NO_OUT, LOW);
    digitalWrite(valveA_NC_IN, LOW);  
    digitalWrite(valveA_NC_OUT, LOW); 
    digitalWrite(valveB_NC_IN, LOW); 
    digitalWrite(valveB_NC_OUT, LOW); 
    digitalWrite(FINAL_VALVE, LOW);
  }

  /*pinMode(lightY, OUTPUT);
  pinMode(lightB, OUTPUT);
  digitalWrite(lightB,LOW);
  digitalWrite(lightY,LOW);
  if (enable_light_A == true || enable_light_B == true)
  {
    if (state_light_A == true || state_light_B == true)
    {
      digitalWrite(lightB,HIGH);
      digitalWrite(lightY,HIGH);
    }
    else
    {
      digitalWrite(lightB,LOW);
      digitalWrite(lightY,LOW);
    }
  }
  else
  {
    digitalWrite(lightB,LOW);
    digitalWrite(lightY,LOW);
  }*/

  pinMode(_4kHzTrigger, OUTPUT);
  pinMode(_10kHzTrigger, OUTPUT);
  pinMode(stopTrigger, OUTPUT);
  digitalWrite(_4kHzTrigger, HIGH);
  digitalWrite(_10kHzTrigger, HIGH);
  digitalWrite(stopTrigger, LOW);
  if (enable_mp3_tone_A == true || enable_mp3_tone_B == true)
  {
    if (state_mp3_tone_A == true || state_mp3_tone_B == true)
    {
      digitalWrite(_4kHzTrigger, LOW);
      digitalWrite(_10kHzTrigger, LOW);
      digitalWrite(stopTrigger, HIGH);
    }
    else
    {
      digitalWrite(_4kHzTrigger, HIGH);
      digitalWrite(_10kHzTrigger, HIGH);
      digitalWrite(stopTrigger, LOW);
    }
  }
  else
  {
    digitalWrite(_4kHzTrigger, HIGH);
    digitalWrite(_10kHzTrigger, HIGH);
    digitalWrite(stopTrigger, LOW);
  }

  
///////////////////////////////////////////////////////////////////

  //Signal to prarie that RFID tag detected
  pinMode(outputRFID, OUTPUT);
  digitalWrite(outputRFID, LOW);
  //
  //digitalWrite(A8, HIGH); //+5V for lick sensor
  //digitalWrite(A10, LOW); //GND for lick sensor

  pinMode(formPin, OUTPUT); //RFID form pin (keep low)
  pinMode(rfidGnd, OUTPUT); //RFID ground pin
  digitalWrite(formPin, LOW);
  digitalWrite(rfidGnd, HIGH);


  //Signal to prarie that RFID tag detected
  pinMode(outputRFID, OUTPUT);
  digitalWrite(outputRFID, LOW);
  //
  //digitalWrite(A8, HIGH); //+5V for lick sensor
  //digitalWrite(A10, LOW); //GND for lick sensor

  pinMode(formPin, OUTPUT); //RFID form pin (keep low)
  pinMode(rfidGnd, OUTPUT); //RFID ground pin
  digitalWrite(formPin, LOW);
  digitalWrite(rfidGnd, HIGH);


  pinMode(FINAL_VALVE, OUTPUT);
  pinMode(TEST_VALVE, OUTPUT);
  digitalWrite(FINAL_VALVE, LOW);
  digitalWrite(TEST_VALVE, LOW);


  pinMode(triggerBNC, OUTPUT); //set the output mode of the trigger BNC port
  digitalWrite(triggerBNC, LOW); //set to 0 volt state as default

  digitalWrite(triggerBNC, HIGH); //set to 0 volt state as default
  delay(500);
  digitalWrite(triggerBNC, LOW); //set to 0 volt state as default

  pinMode(outputSTIM, OUTPUT); //set the output mode of the trigger BNC port
  digitalWrite(outputSTIM, LOW); //set to 0 volt state as default

  pinMode(outputLICK_L, OUTPUT); //set the output mode of the trigger BNC port
  digitalWrite(outputLICK_L, LOW); //set to 0 volt state as default

  pinMode(outputROTARY, OUTPUT); //set the output mode of the trigger BNC port
  digitalWrite(outputROTARY, LOW); //set to 0 volt state as default

  //initialize list of randow positions for next lap

  //Generate random positions for current lap
  //randPosGenerator(randPosListGlobal, numRewardsPerLap);
  GOLPosGenerator(randPosListGlobal, numRewardsPerLap);
  sort(randPosListGlobal, numRewardsPerLap);

  for (int idx = 0; idx <= (numRewardsPerLap - 1); idx++)
  {
    Serial.println(randPosListGlobal[idx]);
  }

  ////Generate random positions for next lap
  //randPosGenerator(randPosListGlobalNext,numRewardsPerLap);
  //sort(randPosListGlobalNext, numRewardsPerLap);
  //
  //  for(int idx=0; idx <= (numRewardsPerLap-1); idx++)
  //  {
  //    Serial.println(randPosListGlobalNext[idx]);
  //  }

  //attachInterrupt(digitalPinToInterrupt(21), indexAlert, RISING);

  //attachInterrupt(digitalPinToInterrupt(lickSensor), deliverWater, RISING);

  //Serial.println("Enabled t1");

  unsigned long clockStart = millis();
  runner.startNow();

}

void loop() {
  // put your main code here, to run repeatedly:

  runner.execute();
//sensory stims
  if (enable_ctx == true)
  {
    if (ctx_dial == 0)
    {
      if (millis() - loop_time > 2000)
      {
        loop_time = millis();
        loop_ref = loop_ref + 1;
        loop_ref = loop_ref % 5;
        loop_print = 0;
      }
      if (loop_ref == 1)
      {
        digitalWrite(stopTrigger, HIGH);
        digitalWrite(_4kHzTrigger, LOW);
        digitalWrite(_10kHzTrigger, HIGH);
        state_mp3_tone_A = true;
        setDAC(1000, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("mp3 tone_A ON"); Serial.println("");
        }
      }
      else if (loop_ref == 2)
      {
        digitalWrite(stopTrigger, LOW);
        digitalWrite(_4kHzTrigger, HIGH);
        digitalWrite(_10kHzTrigger, HIGH);
        digitalWrite(stopTrigger, HIGH);
        state_mp3_tone_A = false;
        setDAC(0, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("mp3 tone_A OFF"); Serial.println("");
        }
      }
      else if (loop_ref == 3)
      {
        digitalWrite(valveM_NO_IN, HIGH); //charge
        digitalWrite(valveM_NO_OUT, HIGH);
        digitalWrite(valveA_NC_IN, HIGH);
        digitalWrite(valveA_NC_OUT, HIGH);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("odor_A CHARGE"); Serial.println("");
        }
      }
      else if (loop_ref == 4)
      {
        digitalWrite(FINAL_VALVE, HIGH); //deliver
        state_odor_A = true;
        setDAC(2000, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("odor_A ON"); Serial.println("");
        }
      }
      else if (loop_ref == 0)
      {
        digitalWrite(FINAL_VALVE, LOW); //stop
        digitalWrite(valveM_NO_IN, LOW); //discharge
        digitalWrite(valveM_NO_OUT, LOW);
        digitalWrite(valveA_NC_IN, LOW);
        digitalWrite(valveA_NC_OUT, LOW);
        state_odor_A = false;
        setDAC(0, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("odor_A OFF"); Serial.println("");
        }
      }
    }
    else if (ctx_dial == 1)
    {
      if (millis() - loop_time > 2000)
      {
        loop_time = millis();
        loop_ref = loop_ref + 1;
        loop_ref = loop_ref % 5;
        loop_print = 0;
      }
      if (loop_ref == 1)
      {
        digitalWrite(stopTrigger, HIGH);
        digitalWrite(_4kHzTrigger, HIGH);
        digitalWrite(_10kHzTrigger, LOW);
        state_mp3_tone_B = true;
        setDAC(3000, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("mp3 tone_B ON"); Serial.println("");
        }
      }
      else if (loop_ref == 2)
      {
        digitalWrite(stopTrigger, LOW);
        digitalWrite(_4kHzTrigger, HIGH);
        digitalWrite(_10kHzTrigger, HIGH);
        digitalWrite(stopTrigger, HIGH);
        state_mp3_tone_B = false;
        setDAC(0, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("mp3 tone_B OFF"); Serial.println("");
        }
      }
      else if (loop_ref == 3)
      {
        digitalWrite(valveM_NO_IN, HIGH); //charge
        digitalWrite(valveM_NO_OUT, HIGH);
        digitalWrite(valveB_NC_IN, HIGH);
        digitalWrite(valveB_NC_OUT, HIGH);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("odor_B CHARGE"); Serial.println("");
        }
      }
      else if (loop_ref == 4)
      {
        digitalWrite(FINAL_VALVE, HIGH); //deliver
        state_odor_B = true;
        setDAC(4000, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("odor_B ON"); Serial.println("");
        }
      }
      else if (loop_ref == 0)
      {
        digitalWrite(FINAL_VALVE, LOW); //stop
        digitalWrite(valveM_NO_IN, LOW); //discharge
        digitalWrite(valveM_NO_OUT, LOW);
        digitalWrite(valveB_NC_IN, LOW);
        digitalWrite(valveB_NC_OUT, LOW);
        state_odor_B = false;
        setDAC(0, 0);
        if (loop_print == 0)
        {
          loop_print = 1;
          Serial.println("odor_B OFF"); Serial.println("");
        }
      }
    }
  }
//////////////////////////////////////////////////////////////////////
}


//////////////DAC OUTPUT FUNCTION MCP4922///////////////
void setDAC(int value, int channel) {
  byte dacRegister = 0b00110000;                        // Sets default DAC registers B00110000, 1st bit choses DAC, A=0 B=1, 2nd Bit bypasses input Buffer, 3rd bit sets output gain to 1x, 4th bit controls active low shutdown. LSB are insignifigant here.
  int dacSecondaryByteMask = 0b0000000011111111;        // Isolates the last 8 bits of the 12 bit value, B0000000011111111.
  byte dacPrimaryByte = (value >> 8) | dacRegister;     //Value is a maximum 12 Bit value, it is shifted to the right by 8 bytes to get the first 4 MSB out of the value for entry into th Primary Byte, then ORed with the dacRegister
  byte dacSecondaryByte = value & dacSecondaryByteMask; // compares the 12 bit value to isolate the 8 LSB and reduce it to a single byte.
  // Sets the MSB in the primaryByte to determine the DAC to be set, DAC A=0, DAC B=1
  switch (channel) {
    case 0:
      dacPrimaryByte &= ~(1 << 7);
      break;
    case 1:
      dacPrimaryByte |= (1 << 7);
  }
  noInterrupts(); // disable interupts to prepare to send data to the DAC
  digitalWrite(dacChipSelectPin, LOW); // take the Chip Select pin low to select the DAC:
  SPI.transfer(dacPrimaryByte); //  send in the Primary Byte:
  SPI.transfer(dacSecondaryByte);// send in the Secondary Byte
  digitalWrite(dacChipSelectPin, HIGH); // take the Chip Select pin high to de-select the DAC:
  interrupts(); // Enable interupts
}

