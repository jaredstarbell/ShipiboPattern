class Mino {
  int[][] grid;
  
  ArrayList<Block> blocks = new ArrayList<Block>();
  
  float x,y;
  
  float w;
  int maxgrid;    // working area for generating minos
  
  int num;        // total number of blocks in the mino
  int seed;

  color myc;
  
  Mino(Mino clone) {
    // clone 
    x = clone.x;
    y = clone.y;
    w = clone.w;
    num = clone.num;
    seed = clone.seed;
    myc = clone.myc;

    grid = new int[clone.maxgrid][clone.maxgrid];
    for (int u=0;u<clone.maxgrid;u++) {
      for (int v=0;v<clone.maxgrid;v++) {
        grid[u][v]=clone.grid[u][v];
      }
    }

    for (Block b:clone.blocks) {
      Block neob = new Block(b.x,b.y,b.w,b.t,b.myc);
      blocks.add(neob);
    }
    
  }
  
  Mino(float _x, float _y, float _w, int _maxgrid, int _num, int _seed, color _myc) {
    x = _x;
    y = _y;
    w = _w;
    maxgrid = _maxgrid;
    num = _num;
    seed = _seed;
    myc = _myc;

    // bound check
    if (num<1) num=1;
    if (maxgrid<1) maxgrid=1;
  
    grid = new int[maxgrid][maxgrid];
    
    generate(num);
    //translateToZero();
    
    if (num==1 && random(100)<50) {
      for (Block b:blocks) {
        b.shape=3;
        b.t=random(TWO_PI);
      }
    }
  }
  
  void renderEdge() {
    pushMatrix();
    translate(x,y);
    for (Block b:blocks) b.renderEdge();
    popMatrix();
  }

  void renderVoid() {
    pushMatrix();
    translate(x,y);
    for (Block b:blocks) b.renderVoid();
    popMatrix();
  }
  
  void renderNetwork() {
    pushMatrix();
    translate(x,y);
    for (Block b:blocks) b.renderNetwork();
    popMatrix();
  }
  
  void render() {
    pushMatrix();
    translate(x,y);
    for (Block b:blocks) b.render();
    popMatrix();
  }
  
  void renderGlow(float val) {
    pushMatrix();
    translate(x,y);
    for (Block b:blocks) b.renderGlow(val);
    popMatrix();
  }
  
  void generate(int _newnum) {
    num = _newnum;
    
    blocks.clear();
    
    // pick central starting location
    //int u = floor(maxgrid/2);
    //int v = floor(maxgrid/2);
    
    // pick random starting location
    int u = floor(random(maxgrid));
    int v = floor(random(maxgrid));
    
    // store original starting location
    int ou = u;
    int ov = v;
    
    for (int i=0;i<num;i++) {
      // set this space as filled      
      grid[u][v] = 1;
      
      // move placement with a cardinal random walk
      int d = -2;    // assume no good direction has been found
      int fails = 0;    // keep track of failed attempts to move
      while (d<0) {
        // first time variable direction
        if (d==-2) d = floor(random(4));
        
        if (random(100)<30) {
          // return to original starting location
          u = ou;
          v = ov;
        }
               
        if (random(100)<20) {
          // change direction
          d = (d + floor(random(3)))%4;
        }
        
        // now move in that cardinal direction
        if (d==0 && v>0) {
          // up
          v--;
        } else if (d==1 && u<maxgrid-1) {
          // right
          u++;
        } else if (d==2 && v<maxgrid-1) {
          // down
          v++;
        } else if (d==3 && u>0) {
          // right
          u--;
        } else {
          // no direction was found, try again
          d = -1;
        }
        
        if (grid[u][v]>0) {
          // grid spot already occupied
          d = -1;
        }
        
        fails++;
        if (fails>100) break;
        
      }
      
    }
    
    // instantiate the graphical blocks for this mino grid
    makeBlocks();
  }
  
  void translateToZero() {
    // first find the top left corner of the mino
    int du = maxgrid;
    int dv = maxgrid;
    for (int u=0;u<maxgrid;u++) {
      for (int v=0;v<maxgrid;v++) {
        if (grid[u][v]>0) {
          du=min(u,du);
          dv=min(v,dv);
        }
      }
    }
    if (du==0 && dv==0) return;  // no translation needed
    
    // shift the mino into 0,0
    for (int u=du;u<maxgrid;u++) {
      for (int v=dv;v<maxgrid;v++) {
        // move value to new location
        grid[u-du][v-dv] = grid[u][v];
        // clear old location
        grid[u][v] = 0;
      }
    }
  }
  
  // adjust the xy position of the whole mino to center relative to total width/height
  void centerAbout(float cx, float cy) {
    
    // first find the top left corner of the mino
    int du = maxgrid;
    int dv = maxgrid;
    for (int u=0;u<maxgrid;u++) {
      for (int v=0;v<maxgrid;v++) {
        if (grid[u][v]>0) {
          du=min(u,du);
          dv=min(v,dv);
        }
      }
    }
    
    // next find the bottom right corner of the mino
    int bu = 0;
    int bv = 0;
    for (int u=maxgrid-1;u>=0;u--) {
      for (int v=maxgrid-1;v>=0;v--) {
        if (grid[u][v]>0) {
          bu=max(u,bu);
          bv=max(v,bv);
        }
      }
    }
    
    float adjx = w * (maxgrid/2 - (bu-du));
    float adjy = w * (maxgrid/2 - (bv-dv));
    
    x = cx + adjx;
    y = cy + adjy;
    
  }
  
  void makeBlocks() {
    blocks.clear();
    // make block objects for the grid values
    int cnt = 0;
    for (int u=0;u<maxgrid;u++) {
      for (int v=0;v<maxgrid;v++) {
        if (grid[u][v]>0) {
          color nyc = color(red(myc),green(myc),blue(myc));
          Block neo = new Block(u*w,v*w,w,0,nyc);
          blocks.add(neo);
          cnt++;
        }
      }
    }
  }
  
  ArrayList<Mino> addBlock() {
    // build collection of new minos with one extra block added
    ArrayList<Mino> temp = new ArrayList<Mino>();
   
    for (int u=0;u<maxgrid;u++) {
      for (int v=0;v<maxgrid;v++) {
        if (grid[u][v]>0) {
          // attempt to add block NORTH
          if (v==0) {
            println("WARN addBlock no more room in grid North");
            break;
          }
          if (grid[u][v-1]==0) {
            Mino neo = new Mino(this);
            neo.grid[u][v-1] = 1;
            neo.makeBlocks();
            temp.add(neo);
          }
            
          // attempt to add block EAST
          if (u==maxgrid-1) {
            println("WARN addBlock no more room in grid East");
            break;
          }
          if (grid[u+1][v]==0) {
            Mino neo = new Mino(this);
            neo.grid[u+1][v] = 1;
            neo.makeBlocks();
            temp.add(neo);
          }
          
          // attempt to add block SOUTH
          if (v==maxgrid-1) {
            println("WARN addBlock no more room in grid South");
            break;
          }
          if (grid[u][v+1]==0) {
            Mino neo = new Mino(this);
            neo.grid[u][v+1] = 1;
            neo.makeBlocks();
            temp.add(neo);
          }
          
          // attempt to add block WEST
          if (u==0) {
            println("WARN addBlock no more room in grid East");
            break;
          }
          if (grid[u-1][v]==0) {
            Mino neo = new Mino(this);
            neo.grid[u-1][v] = 1;
            neo.makeBlocks();
            temp.add(neo);
          }
        }        
          
      }
    }
    
    // eliminate duplicates
    // TODO
   
   
   
    return temp;
    
  }
  
  Vector getCentroid() {
    Vector v = new Vector(x,y,0);
    if (blocks.size()<1) return v;
    
    float bx = 0;
    float by = 0;
    for (Block b:blocks) {
      bx+=b.x;
      by+=b.y;
    }
    
    bx/=blocks.size();
    by/=blocks.size();
    v.x+=bx;
    v.y+=by;
    
    return v;
    
  }
          
 
  
    
}
