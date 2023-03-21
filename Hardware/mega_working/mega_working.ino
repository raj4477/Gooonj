#include <SPI.h>
#include <MFRC522.h>
#include <ArduinoJson.h>
#include <Keypad.h>

StaticJsonDocument<200> doc;
StaticJsonDocument<200> doc1;

const byte ROWS = 4; //four rows
const byte COLS = 4; //four columns

char keys[ROWS][COLS] = {
  {'1','2','3','A'},
  {'4','5','6','B'},
  {'7','8','9','C'},
  {'*','0','#','D'}   };



byte rowPins[ROWS] = {30, 31, 32, 33}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {34, 35, 36, 37}; //connect to the column pinouts of the keypad

bool readRFID = true;
bool readPIN = false;
bool readMID = true;
bool readOTP = false;
bool isCard = false;
bool isMobile = false;


#define gooonjCard 2
#define mobile 3
#define SS_PIN 9
#define RST_PIN 8
#define Null_maker 4

////////////////////////////////////////////////////////////////
// #define arduino_restart 7

///////////////////////////////////////////////////////////////
MFRC522 mfrc522(SS_PIN, RST_PIN);
Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );
//////////////////////////////////////////////////////////////////
  // void(* resetFunc) (void) = 0;
///////////////////////////////////////////////////////////////////
void setup() 
{

  SPI.begin(); 
  mfrc522.PCD_Init();

  Serial.begin(115200);
  Serial.println("Started--------------->>>>>>>");
  while (!Serial) continue;
  Serial3.begin(9600);

  pinMode(gooonjCard,INPUT);
  pinMode(mobile,INPUT);
  pinMode(Null_maker,INPUT);

///////////////////////////////////////////////////////////////////////////
  // pinMode(arduino_restart, INPUT);
//////////////////////////////////////////////////////////////////////////


}
void loop() {
////////////////////////////////////////////////////////////////////////
  // if(digitalRead(arduino_restart)){
  //   Serial.println("Reseting------------::::::::::--------------->");
  //         resetFunc();

  // }
//////////////////////////////////////////////////////////////////////
   if (digitalRead(gooonjCard)==1 && digitalRead(mobile)==0){
      isCard = true;
      isMobile = false;
       Serial.println("Card ---->");
   }


  if (digitalRead(mobile)==1 && digitalRead(gooonjCard)==0 ){
   isMobile = true;
   isCard = false;
    Serial.println("Mobile --->>>");
  }  
  
  delay(1000);
  if(isCard){
    
    Serial.println("Card");
    card();  
  }
  if(isMobile){
    
    Serial.println("Mobile");
      mobile_user();
  }

 
} 




void readRfid(){
  String userid="";
       if ( ! mfrc522.PICC_IsNewCardPresent()) {
    return;
  }
  if ( ! mfrc522.PICC_ReadCardSerial()) {
    return;
  }
  Serial.print("UID tag :");
  for (byte i = 0; i < mfrc522.uid.size; i++) {
  userid += String(mfrc522.uid.uidByte[i], HEX);
  }
  if (userid != ""){
  Serial.print("userid ");
  Serial.println(userid);

  doc["ID"] = userid;
  readRFID = false;
  readPIN = true;  
  }
  Serial.println("Inside rfid");
}

void keyPressedPin(){
   String Pin="";
     Pin="";
  char key;
  while(key != '*'  &&  Pin.length() <= 4){
   key = keypad.getKey();
  if (key){
    if (  key != '*' &&Pin.length()<4){
      Pin = Pin + key;
      //Serial.print("Key --->>> " +  Pin);
    }
    if(key == '*'){
      Serial.print("Key Pressed : ");
      Serial.println(Pin);
      doc["PIN"] = Pin;
      // Pin = "";
      readRFID = true;
      readPIN = false;
		}
  }
  }
}


void keyPressedOtp(){
   String Pin="";
     Pin="";
  char key;
  while(key != '*'  &&  Pin.length() <= 4){
   key = keypad.getKey();
  if (key){
    if (  key != '*' &&Pin.length()<4){
      Pin = Pin + key;
      //Serial.print("Key --->>> " +  Pin);
    }
    if(key == '*'){
      Serial.print("Key Pressed : ");
      Serial.println(Pin);
      doc1["OTP"] = Pin;
      // Pin = "";
      readMID = true;
      readOTP = false;
		}
  }
  }
}

void mobileUID(){
    String Pin="";
  Serial.println("inside mobileUID");   
      //Pin="";
    char key;
    while(key != '*'  &&  Pin.length() <= 8){
    key = keypad.getKey();
    if (key){
      if (  key != '*' && Pin.length()<8){
        Pin = Pin + key;
        //Serial.print("Key --->>> " +  Pin);
      }
      if(key == '*' && Pin.length() == 8 ){
        Serial.print("Key Pressed : ");
        Serial.println(Pin);
        doc1["MID"] = Pin;
         readMID = false;
         readOTP = true; 
        //  serializeJson(doc1, Serial3);
        
      }
    }
    }
}

void card(){
  if(readRFID && !readPIN){
    Serial.println("Reading RFID --->>>");
    readRfid();
    serializeJson(doc, Serial3);
  }
  if(!readRFID && readPIN){
    keyPressedPin();
  }
  serializeJson(doc, Serial3);
    delay(1000);
    if (digitalRead(Null_maker)==1){
        Serial.println("Null maker Called : Carddd------------------>>>>>");
       doc["PIN"] ="";
      doc["ID"] = "";
    }


}

void mobile_user(){
   if(readMID && !readOTP){
   Serial.println("Reading input --->>>");
   mobileUID();
    serializeJson(doc1, Serial3);
  }
  if(!readMID && readOTP){
     keyPressedOtp();
  }
  serializeJson(doc1, Serial3);
    delay(1000);
      if (digitalRead(Null_maker)==1){
        Serial.println("Null maker Called : Mobile ------------------>>>>>");
           doc["PIN"] ="";
            doc["ID"] = "";
      }
  // serializeJson(doc, Serial3);
 
  // serializeJson(doc, Serial3);
}
