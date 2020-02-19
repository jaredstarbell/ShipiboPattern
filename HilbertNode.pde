class HilbertNode {
  float x,y;
  float d;
  float fat;
  ArrayList<HilbertNode> cons = new ArrayList<HilbertNode>();
  
  HilbertNode(float _x, float _y, float _d, float _fat) {
    x = _x;
    y = _y;
    d = _d;
    fat = _fat;
  }
  
  void renderGlow(float val) {
    fill(255,22);
    noStroke();
    for (int k=0;k<3;k++) {
      pushMatrix();
      translate(x,y);
      rotate(random(TWO_PI));
      scale(1 - val*log(random(1.0)));
      rect(-d/2,-d/2,d,d);
      popMatrix();
    }
  }
  
  void renderBase() {
    fill(scolorVoid);
    strokeWeight(fat);
    stroke(scolorEdge);
    ellipse(x,y,d+4,d+4);
  }
  
  void renderNode() {
    fill(scolorNode);
    noStroke();
    ellipse(x,y,2+d/3,2+d/3);
    
  }
  
  void renderConnections(float val) {
    noFill();
    stroke(255,128);
    for (HilbertNode nd:cons) if (random(1.0)<val) line(x,y,nd.x,nd.y);
  }
  
  boolean isConnectedTo(HilbertNode b) {
    if (cons.contains(b)) return true;
    return false;
  }
}
