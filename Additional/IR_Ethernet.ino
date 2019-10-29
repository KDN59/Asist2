
#include <SPI.h>
#include <Ethernet.h>
#include <IRremote.h>

IRsend irsend;

#define br_sensor A0
int br_level = 0;
int count_br_level = 0;
int pir_btn = 33;
bool pir_state = false;
bool pr_light_RPi = false;
bool pr_light_Hue1 = false;
bool pr_light_Hue2 = false;
bool pr_light_Hall = false;
bool pr_security = false;
bool pr_msg_time = false;

unsigned long time_curr;
unsigned long time_msg = 0;
unsigned long time_light_Hall = 0;

IPAddress url_RPi_server(192, 168, 1, 183);
IPAddress url_HueLight_server(192, 168, 1, 190);
IPAddress url_MacMini(192, 168, 1, 187);

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192, 168, 1, 177);

// Initialize the Ethernet server library
// with the IP address and port you want to use
// (port 80 is default for HTTP):
EthernetServer server(80);
EthernetClient client;

void setup() {
  Serial.begin(9600);
  pinMode(pir_btn, INPUT);
  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);
  delay(1000);
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
  // switch off lightRPi & Hue lamps --- 
  set_light_RPi(client, "off");
  pr_light_RPi = get_light_RPi(client);
  set_light_Hue(client, 1, "off");
  pr_light_Hue1 = get_light_Hue(client, 1);
  set_light_Hue(client, 2, "off");
  pr_light_Hue2 = get_light_Hue(client, 2);
  // if all of lights is off -> pr_light_Hall = false ---
  if (!pr_light_RPi && !pr_light_Hue1 && !pr_light_Hue2){
    pr_light_Hall = false;
    Serial.println("All lights in Hall is Off");
  }
  // Send message to log
  send_msg_toLog(client, "IRServer is start");

}

void loop(){
  String request = "";
  // listen for incoming clients
  client = server.available();
  if (client) {
    Serial.println("new client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) {            
      if (client.available()) {
            String line = client.readStringUntil('\n');
 //           Serial.println(line);
            if(line.startsWith("GET ")){ //get request from GET method
                  request = line.substring( 
                     line.indexOf('/') + 1, 
                     line.lastIndexOf(' '));                             
                  char filename[request.length()+1];
                  request.toCharArray(filename, sizeof(filename));
                  Serial.println(request);
                  // Analize request
               // Power buttons ---     
                   if(request == "IR_TVSYSTEM"){
                      send_IR_command(0xA90, 12, "SONY", 3);           
                      send_IR_command(0x540A, 15, "SONY", 3);           
                      send_IR_command(0x80BF3BC4, 32, "NEC", 2);           
                   } else if(request == "IR_TV"){
                      send_IR_command(0xA90, 12, "SONY", 3);
                   } else if(request == "IR_Rcv"){
                      send_IR_command(0x80BF3BC4, 32, "NEC", 2);
                   } else if(request == "IR_Amp"){
                      send_IR_command(0x540A, 15, "SONY", 3);
               // Volume buttons ---       
                   } else if(request == "IR_Vol+"){
                      send_IR_command(0x80BF817E, 32, "NEC", 1);
                   } else if(request == "IR_Vol-"){
                      send_IR_command(0x80BFA15E, 32, "NEC", 1);
                   } else if(request == "IR_Mute"){
                      send_IR_command(0x80BF39C6, 32, "NEC", 1);
               // navigation buttons ---
                   } else if(request == "IR_Left"){
                      send_IR_command(0x80BF9966, 32, "NEC", 1);
                   } else if(request == "IR_Right"){
                      send_IR_command(0x80BF837C, 32, "NEC", 1);
                   } else if(request == "IR_Up"){
                      send_IR_command(0x80BF53AC, 32, "NEC", 1);
                   } else if(request == "IR_Down"){
                      send_IR_command(0x80BF4BB4, 32, "NEC", 1);
                   } else if(request == "IR_Ok"){
                      send_IR_command(0x80BF738C, 32, "NEC", 1);              
               // Cannel buttons ---    
                   } else if(request == "IR_C1"){
                      send_IR_command(0x80BF49B6, 32, "NEC", 1);
                   } else if(request == "IR_C2"){
                      send_IR_command(0x80BFC936, 32, "NEC", 1);
                   } else if(request == "IR_C3"){
                      send_IR_command(0x80BF33CC, 32, "NEC", 1);
                   } else if(request == "IR_C4"){
                      send_IR_command(0x80BF718E, 32, "NEC", 1);
                   } else if(request == "IR_C5"){
                      send_IR_command(0x80BFF10E, 32, "NEC", 1);
                   } else if(request == "IR_C6"){
                      send_IR_command(0x80BF13EC, 32, "NEC", 1);
                   } else if(request == "IR_C7"){
                      send_IR_command(0x80BF51AE, 32, "NEC", 1);
                   } else if(request == "IR_C8"){
                      send_IR_command(0x80BFD12E, 32, "NEC", 1);
                   } else if(request == "IR_C9"){
                      send_IR_command(0x80BF23DC, 32, "NEC", 1);
                   } else if(request == "IR_C0"){
                      send_IR_command(0x80BFE11E, 32, "NEC", 1);
                   } else if(request == "IR_C-"){
                      send_IR_command(0x80BF7986, 32, "NEC", 1);
                   } else if(request == "IR_C+"){
                      send_IR_command(0x80BFB14E, 32, "NEC", 1);
               // Navigation buttons ---
                   } else if(request == "IR_Ok"){
                      send_IR_command(0x80BF738C, 32, "NEC", 1);
                   } else if(request == "IR_Left"){
                      send_IR_command(0x80BF9966, 32, "NEC", 1);
                   } else if(request == "IR_Right"){
                      send_IR_command(0x80BF837C, 32, "NEC", 1);
                   } else if(request == "IR_Up"){
                      send_IR_command(0x80BF53AC, 32, "NEC", 1);
                   } else if(request == "IR_Down"){
                      send_IR_command(0x80BF4BB4, 32, "NEC", 1);
                   } else if(request == "IR_Menu"){
                      send_IR_command(0x80BFA956, 32, "NEC", 1);
                   } else if(request == "IR_Exit"){
                      send_IR_command(0x80BFA35C, 32, "NEC", 1);              
               // Motion detection ---
                   } else if(request == "Sec_on"){
                      pr_security = true;
                      // control time of last msg (prevent 3 times request from browser)
                      if (millis() - time_msg  > 3000){ // set 3 sec between messages
                        // Send message to clear log
                        send_msg_toLog(client, "clean");
                        // Send message to log
                        send_msg_toLog(client, "Start Motion Mode in Hall");
                        // Send a message through Prowl 
                        sendPushNotification(client, "Kalkan Security", "Start Motion Mode", "Hall");     
                        time_msg = millis();     
                      }
                   } else if(request == "Sec_off"){
                      pr_security = false;
                      // control time of last msg (prevent 3 times request from browser)
                      if (millis() - time_msg  > 3000){ // set 3 sec between messages
                        // Send message to log
                        send_msg_toLog(client, "Stop Motion Mode in Hall");
                       // Send a message through Prowl 
                        sendPushNotification(client, "Kalkan Security", "Stop Motion Mode", "Hall");     
                        time_msg = millis();     
                      }
                   }                
             } else if(line == "\r") { // send success header
 //                 Serial.println("End of HTTP Request");
                  client.println("HTTP/1.1 200 OK");
                  client.println("Content-Type: text/html");
                  client.println("Connnection: close");
                  client.println();

                  if(request == "Status" || request == "Sec_on" || request == "Sec_off"){
                      client.print(pr_security);
                   }
                  break;              
             }
      }
    }
//    client.println("Ok");  
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
  }
  
  // detecting pir ---
  pir_state = (bool)digitalRead(pir_btn); 
  // redefine time_light_Hall if motion detected ---
  if (pir_state && pr_light_Hall){
    time_light_Hall = millis();   
  }
  // check brightness sensor ---
  br_level = analogRead(br_sensor);
  if (br_level > 970 && pir_state) {
    count_br_level += 1;
    if (count_br_level > 500 && !pr_light_Hall){
      if (!pr_light_RPi){
        set_light_RPi(client, "on");
        pr_light_RPi = get_light_RPi(client);
      }
      if (!pr_light_Hue1){      
        set_light_Hue(client, 1, "on");
        pr_light_Hue1 = get_light_Hue(client, 1);
      }
      if (!pr_light_Hue2){      
        set_light_Hue(client, 2, "on");
        pr_light_Hue2 = get_light_Hue(client, 2);
      }
      // if any of lights is on -> pr_light_Hall = true, time_light_Hall is start ---
      if (pr_light_RPi || pr_light_Hue1 || pr_light_Hue2){
        time_light_Hall = millis();
        pr_light_Hall = true;
        Serial.println("All lights in Hall is On");
      }
    }
  } else {
    count_br_level = 0;
  }

    if (pr_security && pir_state ){ // Alarm, motion detected
      // control time of last msg & how long lightRPi is On
      if (millis() - time_msg  > 5*60000){ // set 5 min between alarm messages
        // Send message to log
        send_msg_toLog(client, "Detected motion in Hall");
        // Send a message through Prowl 
        sendPushNotification(client, "Kalkan Security", "Detected Motion", "Hall");
        time_msg = millis();     
      }
    }

    if (pr_light_Hall){
      if (millis() - time_light_Hall  > 10*60000){ // set 10 min before switch off lamps in Hall
        if (get_light_RPi(client)){
          set_light_RPi(client, "off");
          pr_light_RPi = get_light_RPi(client);
        } 
                 
        if (get_light_Hue(client, 1)){
          set_light_Hue(client, 1, "off");
          pr_light_Hue1 = get_light_Hue(client, 1);
        }            
        if (get_light_Hue(client, 2)){
          set_light_Hue(client, 2, "off");
          pr_light_Hue2 = get_light_Hue(client, 2);
        }
        // if all of lights is off -> pr_light_Hall = false ---
        if (!pr_light_RPi && !pr_light_Hue1 && !pr_light_Hue2){
          pr_light_Hall = false;
          Serial.println("All lights in Hall is Off");
        }
     }                  
    } 
}


void send_msg_toLog(EthernetClient client, String msg){
    String line;
        // Send message to Kalkan_log.txt file
            // Соединяемся с сервером
        if (client.connect(url_MacMini, 3704)){ 
          delay(1);
          // Replace space symbol to %20, need for http request
          msg.replace(" ", "%20");
          client.println("GET /env/logKalkan.php?msg=" + msg);         
          client.println();
          while (client.connected()){    
            if (client.available()) {
              line = client.readStringUntil('\n');
//              Serial.println(line);
            }
          }
        }
        client.stop();  
}

bool get_light_Hue(EthernetClient client, int lamp_id){
    String line;
    // Соединяемся с сервером
      if (client.connect(url_HueLight_server, 80)){ 
        delay(1);
        client.println("GET /api/lDsSkeCR4uOVc1eKINVdVeEybe5gV1c9XoVlozKv/lights/" + String(lamp_id));         
        client.println();
        while (client.connected()){    
          if (client.available()) {
            line = client.readStringUntil('\n');
          }
        }
        client.stop();
        if (line.startsWith("{\"state\":{\"on\":true")) {
          return true;      
        } else {
          return false;
        }
      } else {
        Serial.println("get_light_Hue connection failed");
        return false;
      }      
}

void set_light_Hue(EthernetClient client, int lamp_id, String action){
    String line;
    // Соединяемся с сервером
      if (client.connect(url_HueLight_server, 80)){ 
        delay(1);
//        Serial.println("111");
        if (action == "on"){
          line = "{\"on\":true}";
        } else if (action == "off"){
          line = "{\"on\":false}";
        }
        unsigned int line_length = line.length();
        client.println("PUT /api/lDsSkeCR4uOVc1eKINVdVeEybe5gV1c9XoVlozKv/lights/" + String(lamp_id) + "/state HTTP/1.1");         
        client.println("Host: 192.168.1.177");                          
        client.println("Connection: close");
        client.println("Content-Type: application/x-www-form-urlencoded");
        client.println("Content-Length: " + String(line_length) + "\r\n");
        client.print(line);          
      } else {
        Serial.println("set_light_Hue connection failed");
      } 
      delay(10);

      // Read all the lines of the reply from server and print them to Serial
      while (client.available()) {
         line = client.readStringUntil('\r');
//         Serial.print(line);
      }
    client.stop();
}

bool get_light_RPi(EthernetClient client){
    String line;
    // Соединяемся с сервером
      if (client.connect(url_RPi_server, 3704)){ 
        client.println("GET //Assist/hallLight.php?req=State");                             
        client.println();
        while (client.connected()){    
         if (client.available()) {
            line = client.readStringUntil('\n');
          }
        }
        client.stop();
        if (line.endsWith(":1")){
          return true;
        } else {
          return false;        
        }
      } else {
        Serial.println("get_light_RPi connection failed");
        return false;
      }
}  

void set_light_RPi(EthernetClient client, String action){
    String line;
    // Соединяемся с сервером
      if (client.connect(url_RPi_server, 3704)){ 
        if (action == "on"){
          client.println("GET //Assist/hallLight.php?req=SetStateOn");         
        } else if (action == "off"){
          client.println("GET //Assist/hallLight.php?req=SetStateOff");                   
        }
        client.println();
      client.stop();
      } else {
        Serial.println("set_light_RPi connection failed");
      }
}  


void send_IR_command(unsigned long codeValue, int codeLen, String codeType, int n_repeat){
    if(codeType == "SONY"){
     for (int i = 0; i < n_repeat; i++) {
      irsend.sendSony(codeValue, codeLen);
      delay(40);
     }
    } else if(codeType == "NEC"){
     for (int i = 0; i < n_repeat; i++) {
      irsend.sendNEC(codeValue, codeLen);  
      delay(40);
     }
    }
}

void sendPushNotification(EthernetClient client, String application, String event, String description) {  
/* 
 * Send message through Prowl
 *  - open a network connection to Prowl's api server
 *  - build and send HTTP POST data to Prowl's Add api
 * // Define Prowl API information
   PROWL_API_KEY "46318fb3526d9f98b40974c3c249af32eb871cec"
   PROWL_API_SRV "api.prowlapp.com"
   PROWL_API_URL "http://api.prowlapp.com/publicapi/add" 
 */
    Serial.print("Sending Message...");
    Serial.print(application);Serial.print("/");
     Serial.print(event);Serial.print("/");
      Serial.print(description);Serial.print("...");
  if (client.connect("api.prowlapp.com", 80)) {
    int contentLength = application.length() + event.length() + description.length();
    client.print("POST ");
    client.print("/publicapi/add"); 
    client.println(" HTTP/1.0");  
    client.print("Host: ");
    client.println("api.prowlapp.com"); // Important for HTTP/1.1 server   
    client.println("User-Agent: Arduino-WiFi/1.0");  
    client.println("Content-Type: application/x-www-form-urlencoded"); 
    client.print("Content-Length: ");
    client.println(contentLength + 80); // fixedContentLength = 80 
    client.println(); // Important blank line between HTTP headers and body 
    client.print("apikey=");
    client.print("46318fb3526d9f98b40974c3c249af32eb871cec");  
     client.print("&application=");
     client.print(application);  
      client.print("&event=");
      client.print(event);
       client.print("&description=");
       client.println(description);
    client.flush();
    client.stop();
    Serial.println("Sended");
  } else {
    Serial.print("connection failed");
  }
}
