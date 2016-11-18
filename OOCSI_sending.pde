
import nl.tue.id.oocsi.*;
import java.io.*;
import processing.io.*;

  OOCSI oocsi;
  String server_ip = "oocsi.id.tue.nl";
  String my_ip="Server";
  
  int MODE = 0;
  int numFinish =0;
  int numTotal = 5;
  int i =0;
  int finishlist[]={0,0,0,0,0};
  
  void setup(){
    connectOOCSI();
    GPIO.pinMode(17, GPIO.INPUT); 
    GPIO.pinMode(27, GPIO.INPUT); 
    GPIO.pinMode(22, GPIO.INPUT); 
    GPIO.pinMode(23, GPIO.INPUT);
    //GPIO.pinMode(24, GPIO.INPUT); 
  }
  
  void draw(){
    if (GPIO.digitalRead(17) == GPIO.HIGH){ MODE=1; reset(); }
    else if (GPIO.digitalRead(27) == GPIO.HIGH) { reset();MODE=2; }
    else if (GPIO.digitalRead(22) == GPIO.HIGH) { reset();MODE=3;}
    else if (GPIO.digitalRead(23) == GPIO.HIGH) { reset();MODE=4;}
    //else if (GPIO.digitalRead(24) == GPIO.HIGH) {MODE=5;reset(); }
    //String lines[] = loadStrings("../command");
    /*for (int i = 0 ; i < lines.length; i++) {
      String cmd[] = lines[i].split(":");
      sendMessage(cmd[0],cmd[1]);
    }*/
    i++;
    if(i==100){
    println("MODE=",MODE);
    i =0;
    numFinish=0;
    for(int i=0;i<5;i++){
      numFinish+=finishlist[i];
    }
    if(MODE == 1){
      sendMessage("setMode",Integer.toString(MODE));
      MODE *= -1;
    } else if(MODE ==-1 && numFinish>=numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
      reset();
    } else if(MODE == 2 && numFinish<numTotal){
      sendMessage("setMode",Integer.toString(MODE)+"_"+(numFinish+1));
    } else if(MODE == 2 && numFinish>=numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
      reset();
    } else if(MODE == 3){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE *= -1;
    } else if(MODE == -3 && numFinish<numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
    } else if(MODE == -3 && numFinish>=numTotal){
      sendMessage("setMode","3_2");
      reset();
    } else if(MODE == 4){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE *= -1;
    } else if(MODE == -4 && numFinish<numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
    } else if(MODE == -4 && numFinish>=numTotal){
      sendMessage("setMode","4_2");
      reset();
    } else if(MODE == 5){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE *= -1;
    }  else if(MODE == -5 && numFinish>=numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
      reset();
    }
    }
  }
  void reset(){
    MODE = 0;
    for(int i=0;i<5;i++){
      finishlist[i]=0;
    }
  }
  void connectOOCSI(){
    // OOCSI channel connect
    oocsi = new OOCSI(this,my_ip, server_ip);
    oocsi.subscribe(server_ip);
  }
  
 boolean sendMessage(String function_name , String msg){
    try{
      oocsi.channel(server_ip)
        .data("sender_ip", my_ip)
        .data("function",function_name)
        .data("io_msg",msg).send();
      return true;
    }catch(Exception e){
      println("sendMessage Exception for '"+msg+"'");
      return false;
    }
  }
  
  void handleOOCSIEvent(OOCSIEvent msg) {
    // print out all values in message
    print(msg.getString("sender_ip")+": ");
    print(msg.getString("function")+"(");
    println(msg.getString("io_msg")+")");
    if(MODE==-1 || MODE==-3 || MODE==-4 || MODE==-5){
      if(msg.getString("function").equals("reportFinish")){
          finishlist[int(msg.getString("sender_ip"))-1]=1;
      }
    } else if(MODE==2 && int(msg.getString("sender_ip"))==numFinish+1){
      finishlist[int(msg.getString("sender_ip"))-1]=1;
    }
}
  