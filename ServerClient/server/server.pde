import oscP5.*;
import netP5.*;

OscP5 oscP5;
PVector mouseLoc;
int clicked;

void setup() {
  size(800,600);
  frameRate(60);

  oscP5 = new OscP5(this,12000);
  mouseLoc = new PVector(width/2, height/2);
  clicked = 0;
}

void draw() {
  if(clicked == 1){
    background(255, 0, 0);
  } else {
    background(0);
  }
  noFill();
  stroke(255);
  ellipse(mouseLoc.x, mouseLoc.y, 10, 10);
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/mouse/position")==true) {
    mouseLoc.x = msg.get(0).intValue();
    mouseLoc.y = msg.get(1).intValue();
  }
  if(msg.checkAddrPattern("/mouse/cliked")==true) {
    clicked = msg.get(0).intValue(); 
    println("msg = " + clicked);
    print("*");
  }
}
