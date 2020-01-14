import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
String ServerAddress = "localhost"; //ServerAddress

void setup() {
  size(800,600);
  frameRate(60);
  oscP5 = new OscP5(this,12001);
  myRemoteLocation = new NetAddress(ServerAddress,12000);
}

void draw() {
  if(mousePressed){
    line(pmouseX,pmouseY,mouseX,mouseY);
  }

  OscMessage msg = new OscMessage("/mouse/position");
  msg.add(mouseX); 
  msg.add(mouseY); 
  msg.add(pmouseX);
  msg.add(pmouseY);
  oscP5.send(msg, myRemoteLocation);
}

void mousePressed(){
  OscMessage msg = new OscMessage("/mouse/cliked");
  msg.add(1);
  oscP5.send(msg, myRemoteLocation);
}

void mouseReleased(){
  OscMessage msg = new OscMessage("/mouse/cliked");
  msg.add(0); 
  oscP5.send(msg, myRemoteLocation);
}
