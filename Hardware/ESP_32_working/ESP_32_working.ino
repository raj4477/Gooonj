#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <Arduino_JSON.h>
#include <Wire.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_GFX.h>
#include <ESP32Servo.h> 

#define OLED_WIDTH 128
#define OLED_HEIGHT 64
#define RXp2 16
#define TXp2 17
#define Null_maker 18

int httpResponseCode;
int httpResponseCodeMID;
int httpResponseCodeQNA;
int httpResponseCodeQNACardless;
int http1;
int http2;

String saveGID="";
String saveGREF="";

const int yes = 15;
const int no = 2;
const char* ssid = "Morningstar";
const char* password = "kivan321";
const char* serverName = "https://gooonj.cyclic.app/api/v1/verifyUser/card";
const char* serverNameCardless = "https://gooonj.cyclic.app/api/v1/verifyUser/cardless";
const char* serverNameQNA = "https://gooonj.cyclic.app/api/v1//dispatch/card";
const char* serverNameQNACardless = "https://gooonj.cyclic.app/api/v1//dispatch/cardless";

const int servo = 4;
static const int servoPin = 26;
const int qYes =12;
const int qNo =14;


/////////////////////////////////////////////////////////////////////////////////////////
const int arduino_restart = 25;
////////////////////////////////////////////////////////////////////////////////////////


bool isCard = false;
bool isMobile = false;

bool answered = false;
int myans =2;
bool ansarray[5];

String userId ="";
String userPin="";
String mobUserId="";
String mobUserOtp="";

Servo servo1;

#define OLED_ADDR   0x3C

Adafruit_SSD1306 display(OLED_WIDTH, OLED_HEIGHT);

void setup() {
  digitalWrite(arduino_restart, HIGH);
  Serial.begin(115200);
  while (!Serial) continue;
  Serial1.begin(9600, SERIAL_8N1, RXp2, TXp2);
  display.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR);
  display.clearDisplay();
  pinMode(15,INPUT);
  pinMode(16,INPUT);
  pinMode(Null_maker,OUTPUT);
  pinMode(qYes, INPUT);
  pinMode(qNo,INPUT);

 ////////////////////////////////////////////////////////////////////////////////////////
pinMode(arduino_restart, OUTPUT);

 /////////////////////////////////////////////////////////////////////////////////////

  servo1.attach(
    servoPin, 
    //Servo::CHANNEL_NOT_ATTACHED, 
    50,
    120
  );

  wifi();
}

void loop() {
  // http.begin(serverName);
  // http.addHeader("Content-Type", "application/json");

  option();
  display.clearDisplay();
}

void option(){
    if(!isMobile && !isCard) {
      display.clearDisplay();
      display.setTextSize(1);
      display.setTextColor(WHITE);
      display.setCursor(10, 0);
      display.println("Select access mode");
      display.setTextSize(1);
      display.setTextColor(WHITE);
      display.setCursor(2, 50);
      display.println("Phone");
      display.setCursor(60, 50);
      display.println("Gooonj Card");
      display.display();
      if (digitalRead(yes) == 1){
        delay(500);
        isMobile = true;
      }
        
      if (digitalRead(no) == 1){
        delay(500);
        isCard = true;
      }

    }
    if (isMobile && !isCard){
      mobile_user();
    }
    if (!isMobile && isCard ){
      gooonj_card();
    }


}
void gooonj_card(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(15, 0);
  display.println("Tap Gooonj Card");
  display.display();
  display.setCursor(31,13);
  display.println("Gooonj ID");
  display.setCursor(33,25);
  dataFromMega(); 
  display.println(userId);
  display.display();
  display.setCursor(22,45);
  display.println("Enter Password");
  display.setCursor(50,55);
  display.print(userPin);
  display.display();
  delay(500);
}
void mobile_user(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(8, 0);
  display.println("Enter your details");
  display.display();
  display.setCursor(31,13);
  display.println("Gooonj ID");
  display.setCursor(33,25);  
  mobiledataFromMega();  
  display.println(mobUserId);
  display.display();
  display.setCursor(22,45);
  display.println("Enter Password");
  display.setCursor(50,55);
  display.print(mobUserOtp);
  display.display();
  delay(500);  
}

void dataFromMega(){
  StaticJsonDocument<300> doc;
  if (Serial1.available()) {

    DeserializationError err = deserializeJson(doc, Serial1);

    if (err == DeserializationError::Ok) {

      Serial.print("ID = ");
      Serial.println(doc["ID"].as<String>());
      String userid = doc["ID"];
      userId = userid;

      Serial.print("Pin = ");
      Serial.println(doc["PIN"].as<String>());
      String userpin = doc["PIN"];
      userPin = userpin;

      // Serial.println(doc["MID"].as<String>());
      // String mob_userpin = doc["MID"];
      // mobUserId = mob_userpin;

      // Serial.println(doc["OTP"].as<String>());
      // String mobileOTP = doc["OTP"];
      // mobUserOtp = mobileOTP; 
      if(userPin.length() == 4 && userId.length() == 8 && userPin != "null" && userId != "null"){
        saveGID = userId;
        verifyGID_PIN();  
      }


      
    } 
    else {
      Serial.print("deserializeJson() returned ");
      Serial.println(err.c_str());
  
      while (Serial1.available() > 0)
        Serial1.read();
    }
  }
}



void verifyGID_PIN(){
  while( httpResponseCode != 200 ||  httpResponseCode != 400){
       if ((userId.length()==8) && (userPin.length()==4) && userPin != "null"){
        
        HTTPClient http;
        http.begin(serverName);
         String body = "{\"gooonjId\":\"" + userId+ "\",\"pin\":\"" + userPin + "\"}" ;
        http.addHeader("Content-Type", "application/json");
        
          httpResponseCode = http.POST(body);
          // hit++; }
            
            // delay(8000);
                  if(httpResponseCode>0){
            Serial.println(body);
              String response = http.getString(); 
              Serial.println(httpResponseCode);   //Print return code
              Serial.println(response);           //Print request answer
              JSONVar obj = JSON.parse(response);
              if (JSON.typeof(obj) == "undefined") {
                  Serial.println("Parsing input failed!");
                  
                }
                Serial.println("JSON object = ");
                Serial.println(obj);
                
                JSONVar keys = obj.keys();
                for (int i = 0; i < keys.length(); i++) {
                  JSONVar value = obj[keys[i]];
                  Serial.print(keys[i]);
                  Serial.print(" = ");
                  Serial.println(value);
                  // if(value == true){
                  //   servomotor();
                  //   delay(100);
                  //   display.clearDisplay();
                  //   // to start from here 
                  //  questionAnswer();                                         
                                        
                  // }
                  
                }
                if((bool)obj["authenticated"]){
                     servomotor();
                    delay(100);
                    display.clearDisplay();
                    // to start from here 
                   questionAnswer();  
                }

                else{
                   display.clearDisplay();
                   delay(1000);
                   display.clearDisplay();
                    display.setTextSize(1);
                    display.setTextColor(WHITE);
                    display.setCursor(10, 0);
                    display.println("Access Denied!!");
                    display.display();
                     //////////////////////////////////////////////////////////////
                      display.clearDisplay();
                     delay(3000);
                      digitalWrite(arduino_restart, LOW);
                      delay(1000);
                      /////////////////////////////////////////////////////////////
                    reset_Screen();
                }
            
            
            }
            else{
            
              Serial.print("Error on sending POST: ");
              Serial.println(httpResponseCode);
            
            }
            
            http.end();

              // delay(3000);
           userId ="";
             userPin="";
            digitalWrite(Null_maker,1);
            
             
            

            delay(100);

            digitalWrite(Null_maker,0);

    
     
      } 

  }
}


void mobiledataFromMega(){
  StaticJsonDocument<300> doc1;
  if (Serial1.available()) {

    DeserializationError err = deserializeJson(doc1, Serial1);

    if (err == DeserializationError::Ok) {

      // Serial.print("ID = ");
      // Serial.println(doc["ID"].as<String>());
      // String userid = doc["ID"];
      // userId = userid;

      // Serial.print("ID = ");
      // Serial.println(doc["PIN"].as<String>());
      // String userpin = doc["PIN"];
      // userPin = userpin;

      Serial.println(doc1["MID"].as<String>());
      String mob_userpin = doc1["MID"];
      mobUserId = mob_userpin;

      Serial.println(doc1["OTP"].as<String>());
      String mobileOTP = doc1["OTP"];
      mobUserOtp = mobileOTP;
         if(mobUserOtp.length() == 4 && mobUserId.length() == 8 && mobUserOtp != "null" && mobUserId != "null"){
              saveGREF =  mobUserId;
              verifyMID_OPT();

      }   
    } 
    else {
      Serial.print("deserializeJson() returned ");
      Serial.println(err.c_str());
  
      while (Serial1.available() > 0)
        Serial1.read();
    }
  }
}


void verifyMID_OPT(){
        while( httpResponseCodeMID != 200 ||  httpResponseCodeMID != 400){
       if ((mobUserId.length()==8) && (mobUserOtp.length()==4) && mobUserOtp != "null"){
        
        HTTPClient http;
        http.begin(serverNameCardless);
         String body = "{\"refId\":\"" + mobUserId+ "\",\"otp\":\"" + mobUserOtp + "\"}" ;
        http.addHeader("Content-Type", "application/json");
        
          httpResponseCodeMID = http.POST(body);
          // hit++; }
            
            // delay(8000);
                  if(httpResponseCodeMID>0){
            Serial.println(body);
              String response = http.getString(); 
              Serial.println(httpResponseCodeMID);   //Print return code
              Serial.println(response);           //Print request answer
              JSONVar obj = JSON.parse(response);
              if (JSON.typeof(obj) == "undefined") {
                  Serial.println("Parsing input failed!");
                  
                }
                Serial.println("JSON object = ");
                Serial.println(obj);
                
                JSONVar keys = obj.keys();
                for (int i = 0; i < keys.length(); i++) {
                  JSONVar value = obj[keys[i]];
                  Serial.print(keys[i]);
                  Serial.print(" = ");
                  Serial.println(value);
                  
                }


                if((bool)obj["authenticated"]){
                     servomotor();
                    delay(100);
                    display.clearDisplay();
                     questionAnswer();  
                }


                else{
                   display.clearDisplay();
                   delay(1000);
                   display.clearDisplay();
                    display.setTextSize(1);
                    display.setTextColor(WHITE);
                    display.setCursor(10, 0);
                    display.println("Access Denied!!");
                    display.display();
                   //////////////////////////////////////////////////////////////
                    display.clearDisplay();
                      delay(3000);                   
                      digitalWrite(arduino_restart, LOW);
                      delay(1000);
                      /////////////////////////////////////////////////////////////

                    reset_Screen();
                }
            
            
            }
            else{
            
              Serial.print("Error on sending POST: ");
              Serial.println(httpResponseCodeMID);
            
            }
            
            http.end();

              // delay(3000);
           mobUserOtp ="";
             mobUserId="";
            digitalWrite(Null_maker,1);
            
             
            

            delay(100);

            digitalWrite(Null_maker,0);

    
     
      } 

  }

}

void wifi(){
  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
}



/// question answer section

void questionAnswer(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(13, 0);
  display.println("Answer Questions?");
  display.setCursor(0,55);
  display.println("Yes");
  display.setCursor(115,55);
  display.print("No");
  display.display();  
  delay(500); 
              while(!answered){
                Serial.println("waiting for button --------------------->");
                      if(digitalRead(qYes) == 1){
                        answered = true;
                        myans = 1;
                Serial.println("1 pressed --------------------->");

                      }
                      if(digitalRead(qNo) == 1){
                        answered = true;
                        myans = 0;                                                
                Serial.println("0 pressed --------------------->");
                      }
                      if(myans == 1){
                      display.clearDisplay();
                      delay(3000);
                      first_question();                                
                      }
                      if(myans == 0){
                        
                Serial.println("display cleared --------------------->");
                // delay(3000);
                Serial.println("entering Option -------------------------->");
                         display.clearDisplay();
                       if(isCard){
                         
                         hitAPI_QNA_Empty_Card();
                         
                         
                         }
                       if(isMobile){
                         hitAPI_QNA_Empty_Cardless();
                     
                       
                         }
                       delay(3000);
                       ///////////////////////////////
                       digitalWrite(arduino_restart, LOW);
                       delay(1000);
                       ////////////////////////////
                       reset_Screen();
                        
                      }

                      
                    }  
}


void first_question(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(13, 0);
  display.println("heavy blood loss");
  display.setCursor(0,55);
  display.println("Yes");
  display.setCursor(115,55);
  display.print("No");
  display.display();
              answered = false;
              int myans =2;  
              while(!answered){
                      if(digitalRead(qYes) == 1){
                        answered = true;
                        myans = 1;                                                
                      }
                      if(digitalRead(qNo) == 1){
                        answered = true;
                        myans = 0;                                                
                      }
                      if(myans == 1){
                          ansarray[0] = 1;
                      display.clearDisplay();
                      delay(3000);
                        secound_question();                              
                      }
                      if(myans == 0){
                        ansarray[0] = 0;
                      display.clearDisplay();
                      delay(3000);
                        secound_question();                       
                      }

                       
                     }  
delay(500); 
}

void secound_question(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(13, 0);
  display.println("Had excess crams");
  display.setCursor(0,55);
  display.println("Yes");
  display.setCursor(115,55);
  display.print("No");
  display.display();
              answered = false; 
              myans = 2; 
              while(!answered){
                      if(digitalRead(qYes) == 1){
                        answered = true;
                        myans = 1;                                                
                      }
                      if(digitalRead(qNo) == 1){
                        answered = true;
                        myans = 0;                                                
                      }
                      if(myans == 1){
                          ansarray[1] = 1;
                      display.clearDisplay();
                      delay(3000);                      
                        third_question();                              
                      }
                      if(myans == 0){
                        ansarray[1] = 0;
                      display.clearDisplay();
                      delay(3000);
                        third_question();                       
                      }

                       
                     }
  delay(500);
}

void third_question(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(13, 0);
  display.println("nausea or vomiting");
  display.setCursor(0,55);
  display.println("Yes");
  display.setCursor(115,55);
  display.print("No");
  display.display();
              answered = false; 
              myans = 2; 
              while(!answered){
                      if(digitalRead(qYes) == 1){
                        answered = true;
                        myans = 1;                                                
                      }
                      if(digitalRead(qNo) == 1){
                        answered = true;
                        myans = 0;                                                
                      }
                      if(myans == 1){
                          ansarray[2] = 1;
                      display.clearDisplay();
                      delay(3000);
                        fourth_question();                              
                      }
                      if(myans == 0){
                        ansarray[2] = 0;
                      display.clearDisplay();
                      delay(3000);
                        fourth_question();                       
                      }

                       
                     }

  delay(500);

}

void fourth_question(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(14, 0);
  display.println("Itching or Rashes");
  display.setCursor(0,55);
  display.println("Yes");
  display.setCursor(115,55);
  display.print("No");
  display.display();
              answered = false; 
              myans = 2; 
              while(!answered){
                      if(digitalRead(qYes) == 1){
                        answered = true;
                        myans = 1;                                                
                      }
                      if(digitalRead(qNo) == 1){
                        answered = true;
                        myans = 0;                                                
                      }
                      if(myans == 1){
                          ansarray[3] = 1;
                      display.clearDisplay();
                      delay(3000);
                        fifth_question();                              
                      }
                      if(myans == 0){
                        ansarray[3] = 0;
                      display.clearDisplay();
                      delay(3000);
                        fifth_question();                       
                      }

                       
                     }


  delay(500); 
}

void fifth_question(){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(13, 0);
  display.println("having bloating");
  display.setCursor(0,55);
  display.println("Yes");
  display.setCursor(115,55);
  display.print("No");
  display.display();
              answered = false; 
              myans = 2; 
              while(!answered){
                      if(digitalRead(qYes) == 1){
                        answered = true;
                        myans = 1;                                                
                      }
                      if(digitalRead(qNo) == 1){
                        answered = true;
                        myans = 0;                                                
                      }
                      if(myans == 1){
                          ansarray[4] = 1;
                      display.clearDisplay();
                      // hitAPI_QNA();


                          if(isCard)
                      {
                        hitAPI_QNA();
                        }
                        if(isMobile){
                          hitAPI_QNA_Cardless();
                        }

                      delay(3000);
                      //////////////////////////////////////////////////////////////
                      digitalWrite(arduino_restart, LOW);
                      delay(1000);
                      /////////////////////////////////////////////////////////////
                      reset_Screen();
                      myans = 1;
                      answered = true;

                                                      
                      }
                      if(myans == 0){
                        ansarray[4] = 0;
                      display.clearDisplay();
                      delay(3000);
                      if(isCard)
                      {
                        hitAPI_QNA();
                        }
                        if(isMobile){
                          hitAPI_QNA_Cardless();
                        }
                      Serial.print("Entering option -------------------------------->");
                       //////////////////////////////////////////////////////////////
                      digitalWrite(arduino_restart, LOW);
                      delay(1000);
                      /////////////////////////////////////////////////////////////
                      reset_Screen();
                      myans = 1;
                      answered = true;
                      
                                              
                      }

                       
                     }

  delay(500); 
}

// Reset Screen 
void reset_Screen(){

                    ESP.restart();  
                      // isCard=false;
                      // isMobile=false;
                      // answered = false;
                      // myans = 2;
                      // option();
}
/// servo motion

void servomotor(){
    for(int posDegrees = 75; posDegrees <= 95; posDegrees++) {
        servo1.write(posDegrees);
        Serial.println(posDegrees);
        delay(50);
        
    }
    delay(500);

    for(int posDegrees = 95; posDegrees >= 75; posDegrees--) {
        servo1.write(posDegrees);
        Serial.println(posDegrees);
        delay(50);
    }
    delay(500);

}



void hitAPI_QNA(){
        Serial.println("HIT API.... normal ...............------------->");
      while( httpResponseCodeQNA != 200 ||  httpResponseCodeQNA != 400){
        Serial.println("QNA------------->");
          if ((saveGID.length()==8) && saveGID != "null"){
        
        HTTPClient http;
        http.begin(serverNameQNA);
         String body = "{\"gooonjId\":\"" + saveGID + "\",\"machineId\":\"6417e42b15d58e4dbd7a4c34\",\"answers\":[" + String(ansarray[0]) + ","+ String(ansarray[1]) +","+String(ansarray[2])+"," +String(ansarray[3]) +"," +String(ansarray[4]) +"]}" ;
        http.addHeader("Content-Type", "application/json");
        
          httpResponseCodeQNA = http.PUT(body);
          // hit++; }
            
            // delay(8000);
                  if(httpResponseCodeQNA>0){
            Serial.println(body);
              String response = http.getString(); 
              Serial.println(httpResponseCodeQNA);   //Print return code
              Serial.println(response);           //Print request answer
              JSONVar obj = JSON.parse(response);
              if (JSON.typeof(obj) == "undefined") {
                  Serial.println("Parsing input failed!");
                  
                }
                Serial.println("JSON object = ");
                Serial.println(obj);
                
                JSONVar keys = obj.keys();
                for (int i = 0; i < keys.length(); i++) {
                  JSONVar value = obj[keys[i]];
                  Serial.print(keys[i]);
                  Serial.print(" = ");
                  Serial.println(value);
                  
                }
            
            
            }
            else{
            
              Serial.print("Error on sending POST: ");
              Serial.println(httpResponseCodeQNA);
            
            }
            
            http.end();

             
             
             
              // delay(3000);
          //  mobUserOtp ="";
          //    mobUserId="";
          //   digitalWrite(Null_maker,1);
            
             
            

          //   delay(100);

          //   digitalWrite(Null_maker,0);

    
     
      }

     if(httpResponseCodeQNA != 200 ||  httpResponseCodeQNA != 400)
                    break;  

  }  
}




void hitAPI_QNA_Cardless(){
        Serial.println("HITAPI....... Cardless............------------->");
      while( httpResponseCodeQNACardless != 200 ||  httpResponseCodeQNACardless != 400){
        Serial.println("QNA------------->");
          if ((saveGREF.length()==8) && saveGREF != "null"){
        
        HTTPClient http;
        http.begin(serverNameQNACardless);
         String body = "{\"refId\":\"" + saveGREF + "\",\"machineId\":\"6417e42b15d58e4dbd7a4c34\",\"answers\":[" + String(ansarray[0]) + ","+ String(ansarray[1]) +","+String(ansarray[2])+"," +String(ansarray[3]) +"," +String(ansarray[4]) +"]}" ;
        http.addHeader("Content-Type", "application/json");
        
          httpResponseCodeQNACardless = http.PUT(body);
          // hit++; }
            
            // delay(8000);
                  if(httpResponseCodeQNACardless>0){
            Serial.println(body);
              String response = http.getString(); 
              Serial.println(httpResponseCodeQNACardless);   //Print return code
              Serial.println(response);           //Print request answer
              JSONVar obj = JSON.parse(response);
              if (JSON.typeof(obj) == "undefined") {
                  Serial.println("Parsing input failed!");
                  
                }
                Serial.println("JSON object = ");
                Serial.println(obj);
                
                JSONVar keys = obj.keys();
                for (int i = 0; i < keys.length(); i++) {
                  JSONVar value = obj[keys[i]];
                  Serial.print(keys[i]);
                  Serial.print(" = ");
                  Serial.println(value);
                  
                }
            
            
            }
            else{
            
              Serial.print("Error on sending POST: ");
              Serial.println(httpResponseCodeQNACardless);
            
            }
            
            http.end();

             
             
             
              // delay(3000);
          //  mobUserOtp ="";
          //    mobUserId="";
          //   digitalWrite(Null_maker,1);
            
             
            

          //   delay(100);

          //   digitalWrite(Null_maker,0);

    
     
      }

     if(httpResponseCodeQNACardless != 200 ||  httpResponseCodeQNACardless != 400)
                    break;  

  }  
}












void hitAPI_QNA_Empty_Card(){
        Serial.println("HI TAPI........ empyty card...........------------->");
      while( http1 != 200 ||  http1 != 400){
        Serial.println("QNA------------->");
          if ((saveGID.length()==8) && saveGID != "null"){
        
        HTTPClient http;
        http.begin(serverNameQNA);
         String body = "{\"gooonjId\":\"" + saveGID + "\",\"machineId\":\"6417e42b15d58e4dbd7a4c34\",\"answers\":[" +"]}" ;
        http.addHeader("Content-Type", "application/json");
        
          http1 = http.PUT(body);
          // hit++; }
            
            // delay(8000);
                  if(http1>0){
            Serial.println(body);
              String response = http.getString(); 
              Serial.println(http1);   //Print return code
              Serial.println(response);           //Print request answer
              JSONVar obj = JSON.parse(response);
              if (JSON.typeof(obj) == "undefined") {
                  Serial.println("Parsing input failed!");
                  
                }
                Serial.println("JSON object = ");
                Serial.println(obj);
                
                JSONVar keys = obj.keys();
                for (int i = 0; i < keys.length(); i++) {
                  JSONVar value = obj[keys[i]];
                  Serial.print(keys[i]);
                  Serial.print(" = ");
                  Serial.println(value);
                  
                }
            
            
            }
            else{
            
              Serial.print("Error on sending POST: ");
              Serial.println(http1);
            
            }
            
            http.end();

             
             
             
              // delay(3000);
          //  mobUserOtp ="";
          //    mobUserId="";
          //   digitalWrite(Null_maker,1);
            
             
            

          //   delay(100);

          //   digitalWrite(Null_maker,0);

    
     
      }

     if(http1 != 200 ||  http1 != 400)
                    break;  

  }  
}







void hitAPI_QNA_Empty_Cardless(){
        Serial.println("HIT API.......... emptycardless.........------------->");
      while( 2 != 200 ||  http2 != 400){
        Serial.println("QNA------------->");
          if ((saveGREF.length()==8) && saveGREF != "null"){
        
        HTTPClient http;
        http.begin(serverNameQNACardless);
         String body = "{\"refId\":\"" + saveGREF + "\",\"machineId\":\"6417e42b15d58e4dbd7a4c34\",\"answers\":[" +"]}" ;
        http.addHeader("Content-Type", "application/json");
        
          http2 = http.PUT(body);
          // hit++; }
            
            // delay(8000);
                  if(http2>0){
            Serial.println(body);
              String response = http.getString(); 
              Serial.println(http2);   //Print return code
              Serial.println(response);           //Print request answer
              JSONVar obj = JSON.parse(response);
              if (JSON.typeof(obj) == "undefined") {
                  Serial.println("Parsing input failed!");
                  
                }
                Serial.println("JSON object = ");
                Serial.println(obj);
                
                JSONVar keys = obj.keys();
                for (int i = 0; i < keys.length(); i++) {
                  JSONVar value = obj[keys[i]];
                  Serial.print(keys[i]);
                  Serial.print(" = ");
                  Serial.println(value);
                  
                }
            
            
            }
            else{
            
              Serial.print("Error on sending POST: ");
              Serial.println(http2);
            
            }
            
            http.end();

             
             
             
              // delay(3000);
          //  mobUserOtp ="";
          //    mobUserId="";
          //   digitalWrite(Null_maker,1);
            
             
            

          //   delay(100);

          //   digitalWrite(Null_maker,0);

    
     
      }

     if(http2 != 200 ||  http2 != 400)
                    break;  

  }  
}
