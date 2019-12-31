void setup(){ 
  size(320,480);
  //size(1440,3040); //GalaxyNote10+
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
