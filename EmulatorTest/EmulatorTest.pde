void setup(){
  size(320,480);
  strokeWeight(20);
}

void draw(){
  if(mousePressed == true){
    line(mouseX,mouseY,pmouseX,pmouseY);
  }
}

void keyPressed(){
  background(204);
}
