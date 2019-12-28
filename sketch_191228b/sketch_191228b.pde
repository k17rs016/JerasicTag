void setup() {
  size(500, 500);
  background(255); //0~255※注1
}

void draw() {
  if (mousePressed) {
    line(mouseX, mouseY, pmouseX, pmouseY);
  }  
}