PImage doodler;

String doodlerUrl = "https://d14nx13ylsx7x8.cloudfront.net/lesson_images/images/000/001/428/original/temp1406587188.png";

float shiftY = 0, shiftYSpeed = 1;
float PLAT_WIDTH = 100, PLAT_HEIGHT = 5, PLAT_SPACING = 40;
 
float x, y, vx, vy, gravity = 0.2;
boolean left, right, up, down;
boolean dead = true;
float w = 5, h = 5;

Platform highest, onPlatform;

class Platform {
    float x, y;
    float w = PLAT_WIDTH, h = PLAT_HEIGHT;
    
    Platform(float x, float y){
        this.x=x;
        this.y=y;
    }
    
    Platform(float y){
        this.y = y;
        x = random(0,width);
    }
    
    void display(){
        if(this==onPlatform){
            fill(0,0,255);
        }else{
            fill(0);
        }
        
        rect(x,y,w,h);
    }
    
    boolean collide(float rx, float ry, float rw, float rh) {
        return abs(x-rx) < (rw + w) / 2 && abs(y-ry) < (rh + h) / 2;
    }
     Platform newAbove() {
        float left = max(x - 100, 0);
        float right = min(x + 100, width);
     
        Platform p = new Platform(random(left, right), y - PLAT_SPACING);
     
        return p;
     }
}



ArrayList<Platform> platforms = new ArrayList<Platform>();

void setup(){
    size(500,500);
    rectMode(CENTER);
    doodler = loadImage(doodlerUrl);
}


void draw(){
    background(255);
    
    if(dead){
        fill(0);
        textAlign(CENTER);
        textSize(50);
        text("Click to begin.",250,250);
    }else{
        shiftY+=shiftYSpeed;
        shiftYSpeed+=0.001;
        translate(0,shiftY);
        drawPlats();
        drawPlayer();
        resetMatrix();
        
        
        if(highest.y+shiftY>0){
            highest = highest.newAbove();
            platforms.add(highest);
        }
        
        onPlatform = platformCheck();
        
        movePlayer();
    }
    
}



void newPlatform() {
  Platform p = new Platform(highest.x + random(-100, 100), -shiftY);
  p.x = abs(p.x);
  if (p.x >= width) p.x = width - (p.x - width);
  highest = p;
  platforms.add(p);
}
 
void drawPlats() {
  for (int i = platforms.size()-1; i >= 0; i--) {
    Platform p = platforms.get(i);
    p.display();
    if (p.y > height - shiftY) platforms.remove(i);
  }
}
 
Platform platformCheck() {
  for (Platform p : platforms) {
    if (p.collide(x, y, w, h)   &&    y < p.y     &&    vy > 0) {
      float jumpSpeed = -6 - pow(shiftYSpeed, 1.5);
      vy = up ? jumpSpeed : 0;
      return p;
    }
  }
 
  return null;
}
 
void drawPlayer() {
  image(doodler, x, y-50, 50, 50);
}
 
void movePlayer() {
  x += vx;
  y += vy;
  vy += gravity;
  vx = (left ? -5 : 0) + (right ? 5 : 0);
  if (y > height - shiftY) dead = true;
}
 
void keyPressed() {
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
}
 
void keyReleased() {
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
}
 
void mousePressed() {
  if (dead) {
    dead = false;
    shiftY = y = vx = vy = 0;
    shiftYSpeed = 1;
    platforms.clear();
    for (int i = 0; i < 10; i++) {
      platforms.add(new Platform(i*5));
    }
 
    x = platforms.get(9).x;
    highest = platforms.get(0);
  }
}
