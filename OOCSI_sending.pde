
import nl.tue.id.oocsi.*;
import java.io.*;

  OOCSI oocsi;
  String server_ip = "oocsi.id.tue.nl";
  int server_port = 4444;
  String my_ip=getIP();
  void setup(){
    connectOOCSI();
    sendMessage();
  }
  
  void connectOOCSI(){
    // OOCSI channel connect
    oocsi = new OOCSI(this,server_ip, server_ip,server_port);
  }
  
 boolean sendMessage(OOCSI oocsi,String function_name , String msg){
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
  private BufferedReader commandLine(String s){
    try{
      Process p = Runtime.getRuntime().exec(s, null, new File("/Users/"));
      return new BufferedReader(new InputStreamReader(p.getInputStream()));
    } catch(Exception e){
      println("Error running command!");  
      println(e);
    }
    return null;
  }
  private String getIP(){
  String prefex = "    inet "; 
  String suffix = " brd";
  String except = "127.0.0.1";
  try{
    //BufferedReader stdInput = commandLine("sudo ip addr show");
    BufferedReader stdInput = commandLine("ifconfig");
    String returnedValues; 
    while ( (returnedValues = stdInput.readLine ()) != null) {
        if(returnedValues.contains(prefex) && !returnedValues.contains(except)){
          String mIP = returnedValues.substring(prefex.length(),returnedValues.indexOf(suffix));
          println("Host IP: "+ mIP);
          return mIP;
        }
      }
  } catch(Exception e) {
    println("Error running command!");  
    println(e);
  }
  return "false";
}
  public void handleOOCSIEvent(OOCSIEvent msg){
    try{
      print(msg.getString("sender_ip")+": ");
      print(msg.getString("function")+"(");
      println(msg.getString("io_msg")+")");
    } catch(Exception e){
      println("Next stage error");
    }
  }
  