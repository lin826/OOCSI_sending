
import nl.tue.id.oocsi.*;
import java.io.*;

  OOCSI oocsi;
  String server_ip = "oocsi.id.tue.nl";
  String my_ip="Server";
  
  int MODE = 3;
  int numFinish =0;
  int numTotal = 5;
  
  void setup(){
    connectOOCSI();
  }
  
  void draw(){
    //String lines[] = loadStrings("../command");
    /*for (int i = 0 ; i < lines.length; i++) {
      String cmd[] = lines[i].split(":");
      sendMessage(cmd[0],cmd[1]);
    }*/
    if(MODE == 1){
      sendMessage("setMode",Integer.toString(MODE));
      MODE *= -1;
    } else if(MODE ==-1 && numFinish>=numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE = 0;
    } else if(MODE == 2 && numFinish<numTotal){
      sendMessage("setMode",Integer.toString(MODE)+"_"+(numFinish+1));
    } else if(MODE == 2 && numFinish>=numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE = 0;
    } else if(MODE == 3){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE *= -1;
    } else if(MODE == -3 && numFinish<numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
    } else if(MODE == -3 && numFinish>=numTotal){
      sendMessage("setMode","3_2");
      MODE=0;
    } else if(MODE == 4){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE *= -1;
    } else if(MODE == -4 && numFinish<numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
    } else if(MODE == -4 && numFinish>=numTotal){
      sendMessage("setMode","4_2");
      MODE=0;
    } else if(MODE == 5){
      sendMessage("setMode",Integer.toString(MODE)); 
      MODE *= -1;
    }  else if(MODE == -5 && numFinish>=numTotal){
      sendMessage("setMode",Integer.toString(MODE)); 
      //MODE = 0;
    } 
    delay(5000);
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
          numFinish++;
      }
    } else if(MODE==2 && msg.getString("sender_ip").equals(Integer.toString(numFinish))){
      numFinish++;
    }
}
  