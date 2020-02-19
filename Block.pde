class Block {
  float x, y;         // position
  float w;            // width
  float t;            // rotation
  
  color myc;          // color
  
  int shape = 4;      // basically the number of points for the block (only square and triangle currently supported) 
  
  Block (float _x, float _y, float _w, float _t, color _myc) {
    x = _x;
    y = _y;
    w = _w;
    t = _t;
    myc = _myc;
  }
  
  void renderEdge() {
    pushMatrix();
    translate(x,y);
    float fzt = random(-.12,.12);
    rotate(t+fzt);
    
    stroke(scolorEdge);
    strokeWeight(swidthEdge);
    if (shape==4) {
      rect(-w/2,-w/2,w,w);
    } else {
      tri(w);
    }
    popMatrix();
  }
  
  void renderVoid() {
    pushMatrix();
    translate(x,y);
    float fzt = random(-.07,.07);
    rotate(t+fzt);
    
    stroke(scolorVoid);
    strokeWeight(swidthVoid);
    if (shape==4) {
      rect(-w/2,-w/2,w,w);
    } else {
      tri(w);
    }
    popMatrix();
  }
  
  void renderNetwork() {
    pushMatrix();
    translate(x,y);
    float fzt = random(-.1,.1);
    rotate(t+fzt);
    
    stroke(scolorNetwork);
    strokeWeight(swidthNetwork*2);
    if (shape==4) {
      rect(-w/2,-w/2,w,w);
    } else {
      tri(w);
    }
    popMatrix();
  }
  
  void render() {
    pushMatrix();
    translate(x,y);
    rotate(t);

    fill(0);
    stroke(0,128);
    strokeWeight(1.0);
    if (shape==4) {
      rect(-w/2,-w/2,w,w);
    } else {
      tri(w);
    }
    
    fill(myc);
    if (shape==4) {
      rect(-w/6,-w/6,w/3,w/3);
    } else {
      tri(w/3);
    }
    
    fill(myc,222);
    if (shape==4) {
      rect(-w/2,-w/2,w,w);
    } else {
      tri(w);
    }
    popMatrix();
  }
  
  void renderGlow(float val) {
    pushMatrix();
    translate(x,y);
    rotate(t);
    
    for (int k=0;k<3;k++) {
      // glow
      pushMatrix();
      blendMode(SCREEN);
      float scl = .1 - val*log(random(1.0));
      scale(scl);
      rotate(random(TWO_PI));
      noStroke();
      fill(myc,32);
      if (shape==4) {
        rect(-w/2,-w/2,w,w);
      } else {
        tri(w);
      }
      blendMode(BLEND);
      popMatrix();
    }
    
    popMatrix();
   
  }
  
  void stitch(float sx, float sy, float sw, float sh) {
    for (int n=0;n<100;n++) {
      float ax = random(sx,sx+sw);
      float ay = random(sy,sy+sh);
      float bx = random(sx,sx+sw);
      float by = random(sy,sy+sh);
      float k = random(100);
      if (k<50) {
        ay = sy;
        by = sy+sh;
      } else {
        ax = sx;
        bx = sx+sw;
      }
      line(ax,ay,bx,by);
    }
  }
  
  void tri(float h) {
    triangle(0,-h,h*.866,h*.5,h*-.866,h*.5);
  }

  
}
