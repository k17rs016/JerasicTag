import oscP5.*;
import netP5.*;

OscP5 oscP5;
PVector mouseLoc1;
PVector mouseLoc2;
int clicked;

void setup() {
  size(800,600);
  frameRate(60);

  oscP5 = new OscP5(this,12000);
  mouseLoc1 = new PVector(width/2, height/2);
  mouseLoc2 = new PVector(width/2, height/2);
  clicked = 0;
}

void draw() {
  if(clicked==1){
    line(mouseLoc1.x,mouseLoc1.y,mouseLoc2.x,mouseLoc2.y);
  }
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/mouse/position")==true) {
    mouseLoc1.x = msg.get(0).intValue();
    mouseLoc1.y = msg.get(1).intValue();
    mouseLoc2.x = msg.get(2).intValue();
    mouseLoc2.y = msg.get(3).intValue();
  }
  if(msg.checkAddrPattern("/mouse/cliked")==true) {
    clicked = msg.get(0).intValue(); 
    println("msg = " + clicked);
    print("*");
  }
}
