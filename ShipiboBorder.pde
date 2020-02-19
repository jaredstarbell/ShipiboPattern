class ShipiboBorder {
 
  float x, y;
  float step;
  
  float h;
  
  boolean up = false;
  
  int cnt = 0;
  
  float lastx, lasty = -1;
  float finx, finy = -1;
  boolean genesis = false;
  
  ShipiboBorder(float _x, float _y, float _step) {
    x = _x;
    y = _y;
    step = _step;
    
    h = sqrt(3*step*step)/2;
  }
  
  void render() {
    x+=step/2;
    if (x>width-step) {
      // init
      x = 10;
      y+=step*2;
      lasty = -1;
      finy = -1;
    }
    if (up) {
      y-=h;
    } else {
      y+=h;
    }
    if (lasty>=0) {
      line(lastx,lasty,x,y);
      if (finy>=0) {
        if (cnt%3!=0) line(finx,finy,x,y);
        //if (cnt%5==0) line(finx,finy,x,y);
      }
    }
    
    genesis = true;
    up = !up;
    
    finx = lastx;
    finy = lasty;
    
    lastx = x;
    lasty = y;
    
    cnt++;
  }
  
}

  
  
