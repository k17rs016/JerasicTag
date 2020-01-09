PGraphics g;

ArrayList<Line> lines;
Line nowDraw;

ColorCircle colorCircle;

Button back;
Button clear;

GroupButton penWidth[] = new GroupButton[6];
int penW = 2;
ArrayList<Button> buttons = new ArrayList<Button>();

void setup() {
  size(500, 400);
  colorMode(HSB, TWO_PI);

  lines = new ArrayList<Line>();
  nowDraw = null;

  g = createGraphics(400, 400);
  g.beginDraw();
  g.endDraw();

  colorCircle = new ColorCircle(400, 40);

  back = new Button(getBackIcon(), 415, 5, 25, 25);
  clear = new Button(getClearIcon(), 460, 5, 25, 25);
  buttons.add(back);
  buttons.add(clear);

  for (int i = 0; i < penWidth.length; i++) {
    PGraphics g = createGraphics(30, 30);
    g.beginDraw();
    int s = (i + 1) * 3;
    g.noStroke();
    g.fill(#dddddd);
    g.rect(2, 2, 30-3, 30-3);
    g.fill(#777777);
    g.ellipse(15, 15, s, s);
    g.filter(BLUR, 1.4);
    g.endDraw();
    penWidth[i] = new GroupButton(g, 405 + 30 * (i % 3), 160 + 30 * (i / 3), 30, 30, penWidth);
    buttons.add(penWidth[i]);
  }
  penWidth[penW].setSelected(true);
}

void draw() {
  background(TWO_PI);
  colorCircle.paint();

  for (Button b : buttons)
    b.paint();

  g.beginDraw();
  g.background(255,255,240);
  for (Line l : lines)
    l.paint(g);
  g.endDraw();

  image(g, 0, 0);

  if (mouseX < 400) {
    noCursor();

    noFill();
    strokeWeight(1);
    stroke(#ffffff);
    ellipse(mouseX, mouseY, penW * 4 + 1 , penW * 4 + 1);
  } else
    cursor();
    
      fill(0);
    noStroke();
    ellipse(450,310,95,95);
}

void mousePressed() {
  if (!colorCircle.isBeginSelect() && mouseX < 400) {
    nowDraw = new Line(mouseX, mouseY, colorCircle.getColor(), penW * 4);
    lines.add(nowDraw);
  }

  for (Button b : buttons)
    b.isStartPress();
}

void mouseReleased() {
  colorCircle.endSelect();
  nowDraw = null;

  if (back.isPressed() && lines.size() > 0)
    lines.remove(lines.size()-1);
  if (clear.isPressed())
    lines.clear();
  for (int i=0; i < penWidth.length; i++)
    if (penWidth[i].isPressed())
      penW = i;
}

void mouseDragged() {
  switch(colorCircle.getColorSelectMode()) {
  case -1:
    if (nowDraw != null)
      nowDraw.add(mouseX, mouseY);
    break;
  case 0:
    colorCircle.hueSelect();
    break;
  case 1:
    colorCircle.satbriSelect();
    break;
  }
}

PImage getBackIcon() {
  PGraphics g = createGraphics(32, 32);

  g.beginDraw();
  g.noStroke();
  g.fill(#ddddff);
  g.rect(1, 1, 31, 31);
  g.noFill();
  g.strokeWeight(3);
  g.stroke(#555555);
  g.ellipse(16, 16, 20, 20);
  g.noStroke();
  g.fill(#ddddff);
  g.ellipse(8, 14, 8, 8);
  g.stroke(#555555);
  g.line(8, 8, 12, 2);
  g.line(8, 8, 12, 12);
  g.endDraw();

  return g;
}

PImage getClearIcon() {
  PGraphics g = createGraphics(32, 32);

  g.beginDraw();
  g.noStroke();
  g.fill(#ddddff);
  g.rect(1, 1, 31, 31);
  g.strokeWeight(2);
  g.stroke(#555555);
  g.fill(#ffffff);
  g.rectMode(CENTER);
  g.translate(16, 16);
  g.rotate(PI/6);
  g.rect(0, 0, 13, 22, 3);
  g.fill(#bbbbff);
  g.rect(0, -5, 15, 16);
  g.endDraw();

  return g;
}

class GroupButton extends Button {
  private GroupButton[] group;
  private boolean isSelected = false;

  public GroupButton(PImage g, int x, int y, int w, int h, GroupButton[] group) {
    super(g, x, y, w, h);
    this.group = group;
  }

  public boolean isPressed() {
    boolean res = super.isPressed();
    if (res) {
      for (GroupButton b : group)
        b.setSelected(false);
      setSelected(true);
    }
    return res;
  }

  public boolean isSelected() {
    return isSelected;
  }

  public void setSelected(boolean b) {
    isSelected = b;
  }

  public void paint() {
    if (contains())
      tint(#d0d0ff);
    if (isSelected())
      tint(#cccccc);
    image(g, r.x, r.y, r.width, r.height);
    noTint();
  }
}

class Button {
  protected Rectangle r;
  protected PImage g;
  private boolean pmouseOver;
  private boolean mousePress;

  public Button(PImage g, int x, int y, int w, int h) {
    this.g = g;
    r = new Rectangle(x, y, w, h);
  }

  public boolean contains() {
    return r.contains(mouseX, mouseY);
  }

  public boolean isPressed() {
    boolean res = contains() && mousePress;
    mousePress = false;
    return res;
  }

  public void isStartPress() {
    if (contains())
      mousePress = mousePressed;
  }

  public void paint() {
    if (contains()) {
      if (mousePress)
        tint(#bbbbbb);
      else
        tint(#dddddd);
    }
    image(g, r.x, r.y, r.width, r.height);
    noTint();
  }
}

public class Rectangle {
  int x, y, width, height;
  public Rectangle(int x, int y, int w, int h) {
    this.x=x;
    this.y=y;
    this.width=w;
    this.height=h;
  }
  public boolean contains(int xx,int yy){
    return x < xx && y < yy && xx < x + width && yy < y + height;
  }
}

class ColorCircle {
  private PVector p;
  private PImage g;
  private float penColor;
  private float penSatur;
  private float penBrigh;
  private int colorSelecting = -1;

  private PGraphics satbri;

  public ColorCircle(float x, float y) {
    p = new PVector(x, y);
    g = createColorCircle();

    int s = int(g.width * 0.8 / 1.41);
    satbri = createGraphics(s, s);
    satbri.beginDraw();
    satbri.colorMode(HSB, s);
    satbri.endDraw();
    updateSatbri();

    penColor = 0;
    penSatur = satbri.width/2;
    penBrigh = -satbri.height/2;
  }

  public color getColor() {
    return color(penColor, map(penSatur, -satbri.width/2, satbri.width/2, 0, TWO_PI), map(penBrigh, -satbri.width/2, satbri.width/2, TWO_PI, 0));
  }

  public int getColorSelectMode() {
    return colorSelecting;
  }

  public boolean isBeginSelect() {
    if (mouseX < p.x || mouseX > p.x + g.width || mouseY < p.y || mouseY > p.y + g.height)
      return false;

    PVector d = PVector.sub(new PVector(mouseX - g.width / 2, mouseY - g.height / 2), p);
    float l = d.mag();
    if (l < g.width/2*0.8) {
      satbriSelect();

      colorSelecting = 1;
      return true;
    } else if (l < g.width/2) {
      hueSelect();

      colorSelecting = 0;
      return true;
    }

    return false;
  }

  public void endSelect() {
    colorSelecting = -1;
    while (penColor < 0) penColor += TWO_PI;
    while (penColor > TWO_PI) penColor -= TWO_PI;
  }

  public void hueSelect() {
    PVector d = PVector.sub(new PVector(mouseX - g.width / 2, mouseY - g.height / 2), p);
    penColor = d.heading() + QUARTER_PI * 3;
    updateSatbri();
  }

  public void satbriSelect() {
    PVector d = PVector.sub(new PVector(mouseX - g.width / 2, mouseY - g.height / 2), p);
    penSatur = constrain(d.x, -satbri.width/2, satbri.width/2);
    penBrigh = constrain(d.y, -satbri.height/2, satbri.height/2);
  }

  public void paint() {
    image(g, p.x, p.y);
    image(satbri, p.x+g.width/2-satbri.width/2, p.y+g.height/2-satbri.height/2);

    noFill();
    stroke(#888888);
    fill(#ffffff, 50);
    float angle = penColor - QUARTER_PI * 3;
    strokeWeight(2);
    ellipse(p.x + g.width/2 + cos(angle) * g.width/2 * 0.88, p.y + g.height/2 + sin(angle) * g.height/2 * 0.88, 10, 10);
    strokeWeight(1.5);
    ellipse(p.x + g.width/2 + penSatur, p.y + g.height/2 + penBrigh, 8, 8);
  }

  private void updateSatbri() {
    satbri.loadPixels();
    for (int iy = 0; iy < satbri.height; iy ++)
      for (int ix = 0; ix < satbri.width; ix ++) {
        satbri.pixels[iy*satbri.width+ix] = color(penColor, map(ix, 0, satbri.width, 0, TWO_PI), map(iy, 0, satbri.width, TWO_PI, 0));
      }
    satbri.updatePixels();
  }

  private PImage createColorCircle() {
    PGraphics g = createGraphics(100, 100);
    final float d = TWO_PI/500;

    g.beginDraw();
    g.colorMode(HSB, TWO_PI);
    g.background(TWO_PI);
    g.noStroke();
    for (float i=0; i<TWO_PI; i+=d) {
      g.fill(i, TWO_PI, TWO_PI);
      g.arc(g.width/2, g.height/2, g.width, g.height, -QUARTER_PI*3+i, -QUARTER_PI*3+i+d);
    }
    g.fill(TWO_PI);
    g.ellipse(g.width/2, g.height/2, g.width*0.8, g.height*0.8);
    g.endDraw();

    return g;
  }
}

class Line extends ArrayList<PVector> {
  color c;
  int w;

  public Line(float x, float y, color c, int w) {
    add(x, y);
    this.c = c;
    this.w = w;
  }

  public void add(float x, float y) {
    add(new PVector(x, y));
  }

  public void paint(PGraphics g) {
    g.beginShape();
    g.strokeJoin(ROUND);
    g.noFill();
    g.strokeWeight(w);
    g.stroke(c);
    for (PVector p : this)
      g.vertex(p.x, p.y);
    g.endShape();
  }
}