import controlP5.*;

ControlP5 Button;

void setup() {
  size(500, 500);
  background(255); //0~255※注1
  
 
  Button = new ControlP5(this);
  Button.addButton("white")
    .setLabel("White")//テキスト
    .setPosition(500-80, 40)
    .setSize(40, 40)
    .setColorActive(color(0, 40)) //押したときの色
    .setColorBackground(color(255)) //通常時の色
    .setColorForeground(color(255)) //マウスを乗せた時の色
    .setColorCaptionLabel(color(0)); //テキストの色

}

void draw() {
  if (mousePressed) {
    line(mouseX, mouseY, pmouseX, pmouseY);
    
  }  
}

void white() {
  background(255);
}