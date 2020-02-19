class Cell {
 
  int i, j;    // index into the maze grid
  float w;     // number of cells, grid dimension (assumes grid is always square) 
  Cell north, south, east, west = null;    // links to neighboring cells
  boolean Ln, Ls, Le, Lw = false;          // connection flags to neighboring cells
  Block Bn, Bs, Be, Bw = null;             // direct links to blocks of neighbord cell minos (used in precise connection rendering)
  
  boolean selected = false;        // selection flag (not really used)
  boolean visited = false;         // visited flag (used during maze generation)
  int dist = 0;                    // distance to finish measured in cell steps
  
  Mino mino;                       // mino object
  
  Cell(int _i, int _j, float _w) {
    i = _i;
    j = _j;
    
    w = _w;
    
    //   Mino(float _x, float _y, float _w, int _num, int _seed, color _myc) {
    
  
    // set mino in with some padding
    //int num = ceil(random(1,11));
    //int gridSize = 4;
    //float pad = w/(gridSize*2);
    //mino = new Mino(pad,pad,(w-pad*2)/gridSize,gridSize,num,0,color(255));
    
    // set mino randomly offset 
    int num = -floor(5*log(random(1.0)));
    num = min(num,11);
    int gridSize = 6;
    float pad = w/(gridSize*4);
    //color ccc = ayc;
    //if (random(100)<30) ccc = byc;
    color ccc = pal.somecolor();
    mino = new Mino(random(2*pad),random(2*pad),(w-pad*2)/gridSize,gridSize,num,0,ccc);
    
    setConnectionBlocks();
  }
  
  
  // make pointers to block objects that graphically connect to nearby cells
  void setConnectionBlocks() {
    int ni = floor(random(mino.blocks.size()));
    Bn = mino.blocks.get(ni);
    
    int ei = floor(random(mino.blocks.size()));
    Be = mino.blocks.get(ei);

    int si = floor(random(mino.blocks.size()));
    Bs = mino.blocks.get(si);

    int wi = floor(random(mino.blocks.size()));
    Bw = mino.blocks.get(wi);
    
    // switch crossing connections
    if (Be.x<Bw.x) {
      Block temp = Be;
      Be = Bw;
      Bw = temp;
    }
    if (Bs.y<Bn.y) {
      Block temp = Bs;
      Bs = Bn;
      Bn = temp;
    }
  }
  
  void findConnectionBlocks() {
    if (Ln) Bn = getClosestBlock(north);
    if (Le) Be = getClosestBlock(east);
    if (Ls) Bs = getClosestBlock(south);
    if (Lw) Bw = getClosestBlock(west);
  }
  
  Block getClosestBlock(Cell c) {
    Block closest = null;
    float mind = width*width;
    Vector v = c.mino.getCentroid();
    v.x += c.i*c.w;
    v.y += c.j*c.w;
    for (Block b:mino.blocks) {
      float d = dist(i*w+mino.x+b.x,j*w+mino.y+b.y,v.x,v.y);
      if (d<mind) {
        mind = d;
        closest = b;
      }
    }
     
    return closest;
  }
  
  void renderEdge() {
    pushMatrix();
    float iw = i*w;
    float jw = j*w;
    translate(iw,jw);
    mino.renderEdge();
    popMatrix();
    
  }

  void renderVoid() {
    pushMatrix();
    float iw = i*w;
    float jw = j*w;
    translate(iw,jw);
    mino.renderVoid();
    popMatrix();
    
  }
  
  void renderNetwork() {
    pushMatrix();
    float iw = i*w;
    float jw = j*w;
    translate(iw,jw);
    mino.renderNetwork();
    popMatrix();
    
  }
  
  void renderMino() {
    pushMatrix();
    float iw = i*w;
    float jw = j*w;
    translate(iw,jw);
    mino.render();
    popMatrix();
  }
  
  void renderGlow(float val) {
    pushMatrix();
    float iw = i*w;
    float jw = j*w;
    translate(iw,jw);
    mino.renderGlow(val);
    popMatrix();
  }
  
  
  
  void renderForeground() {
    pushMatrix();
    float iw = i*w;
    float jw = j*w;
    translate(iw,jw);
    
    strokeCap(PROJECT);
    float sw = w*.44;
    if (sw<1) sw = 1.0;
    strokeWeight(sw);
    stroke(32);
    if (!Ln) line(0, 0, w, 0);
    if (!Le) line(w, 0, w, w);
    if (!Ls) line(0, w, w, w);
    if (!Lw) line(0, 0, 0, w);
    
    if (selected) {
      fill(255);
      noStroke();
      //rect(iw + w/3, jw + w/3, w/3, w/3);
      ellipse(w/2,w/2,w/3,w/3);
    }
    
    popMatrix();

  }

  void setNeighbors(Cell _north, Cell _east, Cell _south, Cell _west) {
    north = _north;
    east = _east;
    south = _south;
    west = _west;
    
  }
  
  void link(Cell c, boolean dolink) {
    if (c==null) return;
    if (c==north) {
      Ln = dolink;
      c.Ls = dolink;
    }
    if (c==east) {
      Le = dolink;
      c.Lw = dolink;
    }
    if (c==south) {
      Ls = dolink;
      c.Ln = dolink;
    }
    if (c==west) {
      Lw = dolink;
      c.Le = dolink;
    }
      
  }
  
  void linkRandom() {
    int d = floor(random(4));
    if (d==0) {
      link(north,true);
    } else if (d==1) {
      link(east,true);
    } else if (d==2) {
      link(south,true);
    } else if (d==3) {
      link(west,true);
    }
  }

  
  boolean isNeighbor(Cell c) {
    if (c==north) return true;
    if (c==east) return true;
    if (c==south) return true;
    if (c==west) return true;
    return false;
  }
  
    
  
  
}
