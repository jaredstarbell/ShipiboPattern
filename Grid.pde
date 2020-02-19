class Grid {
  Cell[][] cells;
  
  int w, h;
  float cellSize;
  float x, y;
  
  float cellSizeRatio = .095;  // hack constant for aligning stroke widths of objects at connection points
  
  Grid(int _w, int _h, float _cellSize, float _x, float _y) {
    w = _w;
    h = _h;
    
    cellSize = _cellSize;
    
    x = _x;
    y = _y;
    
    //println("Grid wh:"+w+","+h+"  cellw:"+cellSize+"  xy:"+x+","+y);
    
    // bound check dimensions
    if (w<1) w = 1;
    if (h<1) h = 1;
    
    makeCells();
    
  }
  
  void render() {
    // render all four reflections about the center
    pushMatrix();
    translate(x,y);
    //stroke(0,255,0);
    //noFill();
    //rect(0,0,width,height);
    
    renderBase();
    scale(-1,1);
    renderBase();
    scale(1,-1);
    renderBase();
    scale(-1,1);
    renderBase();
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    renderEdge();
    scale(-1,1);
    renderEdge();
    scale(1,-1);
    renderEdge();
    scale(-1,1);
    renderEdge();
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    float glowPower = 2.0;
    renderMinoGlow(glowPower);
    scale(-1,1);
    renderMinoGlow(glowPower);
    scale(1,-1);
    renderMinoGlow(glowPower);
    scale(-1,1);
    renderMinoGlow(glowPower);
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    renderVoid();
    scale(-1,1);
    renderVoid();
    scale(1,-1);
    renderVoid();
    scale(-1,1);
    renderVoid();
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    renderNetwork();
    scale(-1,1);
    renderNetwork();
    scale(1,-1);
    renderNetwork();
    scale(-1,1);
    renderNetwork();
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    renderMinos();
    scale(-1,1);
    renderMinos();
    scale(1,-1);
    renderMinos();
    scale(-1,1);
    renderMinos();
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    glowPower = 2.0;
    renderMinoGlow(glowPower);
    scale(-1,1);
    renderMinoGlow(glowPower);
    scale(1,-1);
    renderMinoGlow(glowPower);
    scale(-1,1);
    renderMinoGlow(glowPower);
    popMatrix();
    
    
  }
    
  void renderBase() {
    // ornate IFS
    stroke(scolorBase);
    strokeWeight(swidthBase);
    noFill();
    //drawLines(100,height/4,width/2-100,height/4);
  }
      
  void drawRectGrid() {  
    float ww = cellSize*.35;
    for (float xx=ww/2*.9;xx<w*cellSize;xx+=ww*1.9) {
      for (float yy=ww/2*.9;yy<h*cellSize;yy+=ww*1.9) {
        pushMatrix();
        translate(xx,yy);
        rotate(HALF_PI/2);
        rectMode(CENTER);
        rect(0,0,ww,ww);
        rectMode(CORNER);
        popMatrix();
      }
    }
  }
  
  void renderEdge() {
    stroke(scolorEdge);
    strokeWeight(swidthEdge);
    renderConnections();
    
    // render cell mino edge
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        cells[i][j].renderEdge();
      }    
    }
  }
  
  void renderVoid() {
    stroke(scolorVoid);
    strokeWeight(swidthVoid);
    renderConnections();
    
    // render cell mino edge
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        cells[i][j].renderVoid();
      }    
    }
  }
  
  void renderNetwork() {
    stroke(scolorNetwork);
    strokeWeight(swidthNetwork);
    renderConnections();
    
    // render cell mino edge
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        cells[i][j].renderNetwork();
      }    
    }
  }
  
    
    
  void renderConnections() {
    // render block connections
    noFill();
    
    float corner = cellSize*cellSizeRatio;
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        Cell a = cells[i][j];
        // only draw North and East connections so connections are not drawn twice
        if (a.Ln) {
          // compute anchor points into center of blocks
          float ax = i*cellSize + a.mino.x + a.Bn.x;
          float ay = j*cellSize + a.mino.y + a.Bn.y;
          float dx = i*cellSize + a.north.mino.x + a.north.Bs.x;
          float dy = (j-1)*cellSize + a.north.mino.y + a.north.Bs.y;
          
          if (a.mino.blocks.get(0).shape==4) {
            // adjust for best corner
            ay-=corner;
            dy+=corner;
            if (ax<dx) {
              ax+=corner;
              dx-=corner;
            } else {
              ax-=corner;
              dx+=corner;
            }
          }
          
          // compute control points
          float mag = .5*(dy-ay);
          float bx = ax;
          float by = ay + mag;
          float cx = dx;
          float cy = dy - mag;
          bezier(ax,ay,bx,by,cx,cy,dx,dy);
        }
        if (a.Le) {
          // compute anchor points into center of blocks
          float ax = i*cellSize + a.mino.x + a.Be.x;
          float ay = j*cellSize + a.mino.y + a.Be.y;
          float dx = (i+1)*cellSize + a.east.mino.x + a.east.Bw.x;
          float dy = j*cellSize + a.east.mino.y + a.east.Bw.y;

          if (a.mino.blocks.get(0).shape==4) {
            // adjust for best corner
            ax+=corner;
            dx-=corner;
            if (ay<dy) {
              ay+=corner;
              dy-=corner;
            } else {
              ay-=corner;
              dy+=corner;
            }
          }
          
          // compute control points
          float mag = .5*(dx-ax);
          float bx = ax+mag;
          float by = ay;
          float cx = dx-mag;
          float cy = dy;
          bezier(ax,ay,bx,by,cx,cy,dx,dy);
        }
          
      }    
    }
  }  
  
  void renderMinos() {
    // render cell mino
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        cells[i][j].renderMino();
      }    
    }
  }
  
  void renderMinoGlow(float val) {
    // render cell mino glow effect
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        cells[i][j].renderGlow(val);
      }    
    }
  }  
  
  void makeCells() {
    // create two dimensional array to hold grid cell objects
    cells = new Cell[w][h];

    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        cells[i][j] = new Cell(i,j,cellSize);   
      }
    }
    
    // set cell reference neighbors
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        Cell cn = getCell(i,j-1);
        Cell ce = getCell(i+1,j);
        Cell cs = getCell(i,j+1);
        Cell cw = getCell(i-1,j);
        cells[i][j].setNeighbors(cn,ce,cs,cw);   
      }
    }
    
  }
  
  void updateCellConnectionBlocks() {
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        Cell c = getCell(i,j);
        c.findConnectionBlocks();   
      }
    }
  }
  
  
  void setCellWidth(float neww) {
     for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        cells[i][j].w = neww; 
      }
    }
  }
    
  
  Cell getCell(int i, int j) {
    if (i<0) return null;
    if (i>=w) return null;
    if (j<0) return null;
    if (j>=h) return null;
    return cells[i][j];
  }
  
  Cell getCellClosestTo(float px, float py) {
    float mind = width*height;
    Cell cc = null;
    
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        Cell c = getCell(i,j);
        float d = dist(px,py,x + c.i*c.w + c.w/2, y + c.j*c.w + c.w/2);
        if (d<mind) {
          mind = d;
          cc = c;
        }
      }
      
    }
    
    return cc;
    
  }
  
  
  // generators .................................................
  
  void recursiveBacktracker() {
    unvisitAll();
    
    // pick a random cell to begin
    int i = floor(random(w));
    int j = floor(random(h));
    
    recurseCell(i,j);
   
  }
  
  void recurseCell(int ri, int rj) {
    // mark cell as visited
    cells[ri][rj].visited = true;
    
    // check for neighboring unvisited cells
    int ad = floor(random(4));
    int attempts = 0;
    while (attempts<4) {
      int d = (ad+attempts)%4;
      if (ri<w-1 && d==1) {
        if (!cells[ri][rj].east.visited) {
          cells[ri][rj].link(cells[ri+1][rj],true);
          recurseCell(ri+1,rj);
        }
      }
      if (rj<h-1 && d==2) {
        if (!cells[ri][rj].south.visited) {
          cells[ri][rj].link(cells[ri][rj+1],true);
          recurseCell(ri,rj+1);
        }
      }
      if (ri>0 && d==3) {
        if (!cells[ri][rj].west.visited) {
          cells[ri][rj].link(cells[ri-1][rj],true);
          recurseCell(ri-1,rj);
        }
      }
      attempts++;
    }
    
  }
  
  void aldousBroder() {
    //print("beginning aldousBroder...");
    // mark all cells as unvisited
    unvisitAll();
    
    // pick a random cell to begin
    int i = floor(random(w));
    int j = floor(random(h));
    
    int steps = 0;
    // repeat until all cells have been visited
    while (!allVisited()) {
      cells[i][j].visited = true;
      
      int oi = i;
      int oj = j;
      
      // move to a random adjacent location
      while (oi==i && oj==j) {
        int d = floor(random(4));
        if (d==0 && j>0) {
          j--;
        } else if (d==1 && i<w-1) {
          i++;
        } else if (d==2 && j<h-1) {
          j++;
        } else if (i>0) {
          i--;
        }
      }
      
      if (!cells[i][j].visited) {
        cells[oi][oj].link(cells[i][j],true);
      }
      
      steps++;
    }
    
    
  }
    
  void sideWinder() {
    for (int sj=0;sj<h;sj++) {
      // one row at a time
      int runStart = 0;
      for (int si=0;si<w;si++) {
        Cell c = getCell(si,sj);
        float dice = random(100);
        if ((sj==h-1) || (dice<50 && si!=w-1)) { 
          // remove side wall
          c.link(c.east,true);
        } else {
          // remove bottom wall
          
          // pick a random bottom wall from the run
          int idx = floor(random(runStart,si));
          Cell cidx = getCell(idx,sj);
          cidx.link(cidx.south,true);
          
          // reset runStart
          runStart = si + 1;
        }  
      }
      
    }
    
    /*
    // make start and stop openings
    int mi = w/2;
    Cell cstart = getCell(mi,0);
    Cell cend = getCell(mi,h-1);
    cstart.north = cend;
    cend.south = cstart;
    cstart.link(cend,true);
    */
    
  }
  
  void binaryConnect() {
    for (int sj=0;sj<h;sj++) {
      for (int si=0;si<w;si++) {
        Cell c = getCell(si,sj);
        
        float dice = random(100);
        if ((dice<50 && si<w-1) || sj==h-1) { 
          // remove side wall
          c.link(c.east,true);      
        } else if (sj<h-1) {
          // remove bottom wall
          c.link(c.south,true);
        }
      }
    }
    
    /*
    // add start stop loop
    Cell cstart = getCell(0,0);
    Cell cend = getCell(w-1,h-1);
    cstart.west = cend;
    cend.east = cstart;
    cstart.link(cend,true);
    */
  }  
  
  void makeConnections(int num) {
    for (int n=1;n<num-1;n++) {
      int i = floor(random(w));
      int j = floor(random(h));
      int d = floor(random(4));
      Cell c = getCell(i,j);
      if (d==0) {
        c.link(c.north,true);
      } else if (d==1) {
        c.link(c.east,true);
      } else if (d==2) {
        c.link(c.south,true);
      } else if (d==3) {
        c.link(c.west,true);
      }
    }
    
  }
  
  // solvers ........................................
   
  void solveDijkstra(Cell org) {
    org.selected = true;
    
    if (org.dist>0) {
      if (org.Ln) {
        if (org.north.dist<org.dist) solveDijkstra(org.north);
      }
      if (org.Le) {
        if (org.east.dist<org.dist) solveDijkstra(org.east);
      }
      if (org.Ls) {
        if (org.south.dist<org.dist) solveDijkstra(org.south);
      }
      if (org.Lw) {
        if (org.west.dist<org.dist) solveDijkstra(org.west);
      }
    }
    
  }
      
  void solveSidewinder(Cell org) {
    // solve a sindwinder maze from org to w,h
    org.selected = true;
    
    // try to go down first
    if (org.Ls) {
      solveSidewinder(org.south);
    } else {
      // look to the left and right to find a way down
      boolean isWest = false;
      Cell temp = org;
      while (temp.Lw) {
        temp = temp.west;
        if (temp.Ls) isWest=true;
      }
      if (isWest) {
        // solution is west
        while (!org.Ls) {
          org = org.west;
          org.selected = true;
        }
        if (org.j<h-1) solveSidewinder(org.south);
        return;
      } else {
        // solution must be east (unless there is no solution)
        while (!org.Ls && org.Le) {
          org = org.east;
          org.selected = true;
        }
        if (org.j<h-1 && org.Ls) solveSidewinder(org.south);
        return;
      }
    }
    
    
  }
  
  void solveBinary(Cell org) {
    // solve the binary maze from org to w,h
    
    org.selected = true;
    if (org.Le && org.i<w-1) solveBinary(org.east);
    if (org.Ls && org.j<h-1) solveBinary(org.south);
  }
    
   
    
  // analysis & tools ................................
  
  void computeDistances(Cell org) {
    unvisitAll();
    
    // compute distances for all cells from cell
    computeDistance(org, 0);
   
  }
  
  void computeDistance(Cell org, int dist) {
    if (org.visited) return;
    
    org.dist = dist;
    org.visited = true;
    
    // look for openings
    if (org.Ln) computeDistance(org.north,dist+1);
    if (org.Le) computeDistance(org.east,dist+1);
    if (org.Ls) computeDistance(org.south,dist+1);
    if (org.Lw) computeDistance(org.west,dist+1);
  }

  int computeMaxDist() {
    // compute new max distance
    int maxDist = 0;
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        if (cells[i][j].dist>maxDist) maxDist = cells[i][j].dist;
      }
    }
    return maxDist;
  }

  void unvisitAll() {
    // mark all cells as unvisited
    for (int sj=0;sj<h;sj++) {
      for (int si=0;si<w;si++) {
        cells[si][sj].visited = false;
      }
    }
  }
  
  boolean allVisited() {
    for (int sj=0;sj<h;sj++) {
      for (int si=0;si<w;si++) {
        if (!cells[si][sj].visited) return false;
      }
    }
    return true;
    
  }
  
  void deselectAll() {
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        Cell c = getCell(i,j);
        c.selected = false;
      }
    }
  }
  
  Grid getCRotated() {
    // make a clone initially 
    Grid g = new Grid(w,h,cellSize,x,y);
    for (int i=0;i<w;i++) {
      for (int j=0;j<h;j++) {
        Cell a = cells[i][j];
        Cell b = g.cells[g.w-j-1][i];
        b.Ln = a.Lw;
        b.Le = a.Ln;
        b.Ls = a.Le;
        b.Lw = a.Ls;
        b.visited = a.visited;
        b.w = a.w;
        b.dist = a.dist;
        b.selected = a.selected;
      }
    }
    return g;
    
    
  }
  
}
