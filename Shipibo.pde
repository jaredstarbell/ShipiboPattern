// Shipibo Pattern Generator 
//   Jared S Tarbell
//   January 13, 2020
//   Albuquerque, New Mexico, USA

ShipiboBorder border;

// maze collection of cells 
Grid grid;

// dynamic colors from image
GoodPalette pal;

// flourescent colors
color[] fColor = {#ff9966, #ccff00, #ff9933, #ff00cc, #ee34d3, #4fb4e5, #abf1cf, #ff6037, #ff355e, #66ff66, #ffcc33, #ff6eff, #ffff66, #fd5b78};
color somecolor() { return fColor[floor(random(fColor.length))]; }

// globally defined stroke widths and colors

// base 
float swidthBase = 1;
color scolorBase = color(255,88);
// nodes
float swidthConnection = 1.0;
color scolorConnection = color(255,111);
color scolorNode = color(255);
// edge
float swidthEdge = 50;               // stroke width for base
color scolorEdge = color(255,92);    // stroke color for base
// void is area between edge and connection
float swidthVoid = 46;
color scolorVoid = color(16);
// network connections
float swidthNetwork = 6;
color scolorNetwork = color(255,222);

// global color selectors (for duotone rendering)
color ayc;
color byc;

// list of nodes attachd to the hilbert curve
ArrayList<HilbertNode> nodes = new ArrayList<HilbertNode>();

void setup() {
  //size(2400,1200,FX2D);
  fullScreen(FX2D);
  background(32);
  smooth(8);

  // load up some good colors
  pal = new GoodPalette(512);
  pal.readBitmap("pollockCSM.gif");
  //pal.show();
  
  // create a border object
  //border = new ShipiboBorder(15,15,30);
 
  // generate new tapestry from skratch
  reset();
  
  // render it all
  mainRender();
  
}

void draw() {
  // render one and done
  // nothing to do here
}

void reset() {
  // randomize color selections
  ayc = somecolor();
  byc = somecolor();

  // clear hilbert nodes
  nodes.clear();

  // a grid is a giant maze conatiner with minos at each cell location
  grid = new Grid(24,12,150,width/2,height/2);
  grid.aldousBroder();
  grid.makeConnections(250);
  grid.updateCellConnectionBlocks();
}

void mainRender() {
  // start with a not quite black background
  background(8);

  // draw a full screen hilbert curve
  stroke(scolorBase);
  fill(scolorBase);
  renderHilbert();

  // draw everything in the grid maze
  grid.render();

  // cull most of the connections and render again
  for (HilbertNode nd:nodes) nd.renderConnections(.222);
  
  // render highlight color 
  for (HilbertNode nd:nodes) nd.renderNode();
  
  // render glowing base 
  for (HilbertNode nd:nodes) nd.renderGlow(1.0);

}

void renderHilbert() {
  pushMatrix();
  translate(width/2,height/2);
  rotate(HALF_PI/2);
  float fat = 1.0;
  Vector c[] = hilbert(  new Vector(0, 0, 0) , .8*width, 8, 0, 1, 2, 3); // hilbert(center, side-length, recursion depth, start-indices)
  for(int i = 0; i < c.length-1; i++) {
    float f = 1;
    float fax = random(-f,f);
    float fay = random(-f,f);
    float fbx = random(-f,f);
    float fby = random(-f,f);
    strokeWeight(fat*swidthBase);
    line(c[i].x+fax, c[i].y+fay, c[i+1].x+fbx, c[i+1].y+fby);
    
    // randomly grow and shrink line thickness
    fat+=random(-.2,.2);
    if (fat<.1) fat = .1;
    if (fat>4) fat = 4;
    
    if (random(1.0)<.05) {
      // make a hilbert node at this location
      float ed = random(2.0,5*fat*swidthBase);
      ed = max(3.0,ed);
      HilbertNode neo = new HilbertNode(c[i].x+fax, c[i].y+fay, ed, fat);
      nodes.add(neo);
    }
      
  }
  
  // render base color 
  for (HilbertNode nd:nodes) nd.renderBase();
  
  // connect nearby nodes
  if (nodes.size()>0) {
    float max = 500;
    float connectionDensity = 1.0;    // average number of connections per node 
    noFill();
    strokeWeight(swidthConnection);
    stroke(scolorConnection);
    for (int n=0;n<nodes.size()*connectionDensity;n++) {
      int ai = floor(random(nodes.size()));
      HilbertNode a = nodes.get(ai);
      
      // connect to nearest
      float min = width*width;
      HilbertNode closest = null;
      for (int bi=0;bi<nodes.size();bi++) {
        if (bi!=ai) {
          HilbertNode b = nodes.get(bi);
          if (!a.isConnectedTo(b)) {
            float d = dist(a.x,a.y,b.x,b.y);
            if (d<min && d<max) {
              min = d;
              closest = b;
            }
          }
        }
      }
      if (closest!=null) {
        a.cons.add(closest);
        closest.cons.add(a);
        line(a.x,a.y,closest.x,closest.y);
      }

    }
  }
    
  // render highlight color 
  for (HilbertNode nd:nodes) nd.renderNode();
  
  // render glowing base 
  for (HilbertNode nd:nodes) nd.renderGlow(3.0);
  
  popMatrix();
  
}

Vector[] hilbert (Vector c_, float side, int iterations, int index_a, int index_b, int index_c, int index_d) {
  // Hilbert curve forever
  Vector c[] = new Vector[4];
  c[index_a] = new Vector(  c_.x - side/2,   c_.y - side/2, 0  );
  c[index_b] = new Vector(  c_.x + side/2,   c_.y - side/2, 0  );
  c[index_c] = new Vector(  c_.x + side/2,   c_.y + side/2, 0  );
  c[index_d] = new Vector(  c_.x - side/2,   c_.y + side/2, 0  );

  if( --iterations >= 0) {
    Vector tmp[] = new Vector[0];
    tmp = (Vector[]) concat(tmp, hilbert ( c[0],  side/2,   iterations,    index_a, index_d, index_c, index_b  ));
    tmp = (Vector[]) concat(tmp, hilbert ( c[1],  side/2,   iterations,    index_a, index_b, index_c, index_d  ));
    tmp = (Vector[]) concat(tmp, hilbert ( c[2],  side/2,   iterations,    index_a, index_b, index_c, index_d  ));
    tmp = (Vector[]) concat(tmp, hilbert ( c[3],  side/2,   iterations,    index_c, index_b, index_a, index_d  ));
    return tmp;
  }
  return c;
}
    



void keyPressed() {
  if (key==' ') {
    // press spacebar to make regenerate all new tapestry
    reset();
    mainRender();
  }
  if (key=='c' || key=='C') {
    // update and render connection blocks (mostly used for testing)
    grid.updateCellConnectionBlocks();
    mainRender();
  }
}

void mousePressed() {
  background(0);
  mainRender();
  
}
