import java.util.Collections;
import java.lang.StringBuilder;

//Globals
PerlinParticles perlinParticles;
int WIDTH = 1000;
int HEIGHT = 800;

//User controllable flags and values
float SEED = 0.01;
int TAIL_LENGTH = 2;
int X_BOUND = WIDTH;
int Y_BOUND = HEIGHT;
int Z_BOUND = HEIGHT;
float SPEED = 4;
float ATTENUATION = 0.0001;
boolean DEBUG = false;
boolean BOUNDED = false;
boolean MONOCHROME = false;
boolean redraw = true;
float camX = WIDTH/2;
float camY = HEIGHT/2;
float camZ = 1370;


void setup() {
  size(WIDTH, HEIGHT, P3D);
  noFill();
  smooth();
  //Start the scene with 100 particles.
  perlinParticles = new PerlinParticles(100);
  frameRate(200);
}

void draw() {
  background(0);
  //camX and camY are controlled by clicking and dragging. 
  //camZ is controlled by the up and down arrows. 
  camera(camX, camY, camZ, width/2, height/2, 0, 0, 1, 0);
  
  //Update and draw the particles.
  perlinParticles.update();
  perlinParticles.draw();
  //the 'd' key toggles debugging which prints out useful information.
  if(DEBUG){
    StringBuilder sb = new StringBuilder();
    sb.append("Particle Count:\t");
    sb.append(perlinParticles.particles.size());
    sb.append("\n");
    sb.append("Seed:\t");
    sb.append(SEED);
    sb.append("\n");
    sb.append("Attenuation:\t");
    sb.append(ATTENUATION);
    sb.append("\n");
    sb.append("Speed:\t");
    sb.append(SPEED);
    sb.append("\n");
    sb.append("Tail length:\t");
    sb.append(TAIL_LENGTH);
    sb.append("\n");
    sb.append("X_BOUND:\t");
    sb.append(X_BOUND);
    sb.append("\n");
    sb.append("Y_BOUND:\t");
    sb.append(Y_BOUND);
    sb.append("\n");
    sb.append("Z_BOUND:\t");
    sb.append(Z_BOUND);
    sb.append("\n");
    sb.append("Colored?:\t");
    sb.append(!MONOCHROME);
    sb.append("\n");
    sb.append("Bounded?:\t");
    sb.append(BOUNDED);
    sb.append("\n");
    camera();
    stroke(255,255,255);
    text(sb.toString(),10,10,200,200);
  }
}

void mouseDragged() {
  //Controls camera movement.
  camX -= mouseX - pmouseX;
  camY -= mouseY - pmouseY;
}



void keyPressed() {
  //Remove one fifth of the particles in the scene.
  if (key == '<' || key == ',') {
    ArrayList particlesToRemove = new ArrayList(perlinParticles.particles);
    //Shuffle the particles, then remove 1/5 and set the resulting ArrayList as the scene's particle ArrayList
    Collections.shuffle(particlesToRemove);
    for (int i = 0; i < floor(particlesToRemove.size()/5); i++) {
      particlesToRemove.remove(i);
    }
    perlinParticles.particles = new ArrayList(particlesToRemove);
  }
//###################################################
  //Add a wall of particles along the YZ plane, spaced out at intervals of 15. 
//###################################################
  if (key == '>' || key == '.') {
    float x = random(0,X_BOUND);
    for (int y = 0; y < Y_BOUND; y+=15) {
      for (int z = 0; z < Z_BOUND; z+=15) {
        perlinParticles.particles.add(new Particle(x, y, z));
      }
    }
  }
//###################################################
  //Increase the number of line segments draw on the screen for each particle.
  if (key == '+' || key == '=') {
    TAIL_LENGTH++;
  }
  //Decrease the number of line segments draw on the screen for each particle.
  if (key == '-') {
    if (TAIL_LENGTH > 1) {
      TAIL_LENGTH--;
    }
  }
//###################################################
  //Decrease the SEED value
  if (key == '[') {
    SEED -= 0.1;
  }
  //Increase the SEED value
  if (key == ']') {
    SEED += 0.1;
  }
//###################################################
//The _BOUND variables control the dimensions of the bounding box
//###################################################
  //Decrease the X_BOUND
  if (key == 'x') {
    X_BOUND -= 50;
  }
  //Increase the X_BOUND
  if (key == 'X') {
    X_BOUND += 50;
  }
  //Decrease the Y_BOUND
  if (key == 'y') {
    Y_BOUND -= 50;
  }
  //Increase the Y_BOUND
  if (key == 'Y') {
    Y_BOUND += 50;
  }
  //Decrease the Z_BOUND
  if (key == 'z') {
    Z_BOUND -= 50;
  }
  //Increase the Z_BOUND
  if (key == 'Z') {
    Z_BOUND += 50;
  }
//###################################################
  //Toggles pseudo redraw. Instead of just not redrawing the background,
  // this allows the particle TAIL_LENGTH to stretch to 200.
  if (key == 'r') {
    redraw = !redraw;
  }
//###################################################
  //Toggles whether the particles are bounded by the _BOUND variables
  // or are allowed to move out into the world.
  if (key == 'b') {
    BOUNDED = !BOUNDED;
  }
//###################################################
//The ATTENUATION variable, along with SEED, affects form of the 3D perlin noise.
//###################################################
  if (key == '(' || key == '9') {
    ATTENUATION -= 0.001;
  }
  if (key == ')' || key == '0') {
    ATTENUATION += 0.001;
  }
//###################################################
  //Toggle console debugging.
  if (key == 'd'){
    DEBUG = !DEBUG;
  }
//###################################################
  //Toggle colored particles. 
  if (key == 'c'){
    MONOCHROME = !MONOCHROME;
  }
//###################################################
  if (key == CODED) {
    if (keyCode == UP) {
      camZ -= 50;
    }
    if (keyCode == DOWN) {
      camZ += 50;
    }
    
    //Speeding up the particles means the velocity vector that
    // defines the length of the lines drawn are longer, giving 
    // the 3D perlin form more definition with minimal computational load.
    // It also makes the 3D perlin form less defined.
    if (keyCode == LEFT) {
      SPEED -= 0.5;
    }
    if (keyCode == RIGHT) {
      SPEED += 0.5;
    }
  }
}

//###################################################
//Main class. Controls particle lifespan behavior
//###################################################
class PerlinParticles {
  ArrayList particles;

  PerlinParticles(int initialNumber) {
    
    //###################################################
    //Add a wall of particles along the YZ plane, spaced out at intervals of 15. 
    //###################################################
    particles = new ArrayList(); 
    for (int y = 0; y < Y_BOUND; y+=15) {
      for (int z = 0; z < Z_BOUND; z+=15) {
        particles.add(new Particle(X_BOUND, y, z));
      }
    }
  }

  //###################################################
  //Update each particle.
  //If its lifespan is up, remove it and add a new particle
  // at a random position within the bouding box.
  //###################################################
  void update() {
    for (int i = 0; i < particles.size(); i++) {
      Particle particle = (Particle)particles.get(i);
      if (particle.lifespan > 0) {
        particle.update();
      }
      else {
        particles.remove(i);    
        PVector seed = new PVector(random(0, X_BOUND), random(0, Y_BOUND), random(0, Z_BOUND));
        particles.add(new Particle(seed.x, seed.y, seed.z));
      }
    }
  }

  //###################################################
  //Draw each particle
  //###################################################
  void draw() {
    for (int i = 0; i < particles.size() - 1; i++) {
      Particle particle = (Particle)particles.get(i);
      particle.draw();
    }
  }
}

//###################################################
//Particle class
//###################################################
class Particle {
  //Position and velocity PVectors.
  PVector position, velocity;
  int lifespan = floor(random(500));
  ArrayList curveVerts = new ArrayList();
  
  //###################################################
  //Lines to be drawn for the particle
  //###################################################
  ArrayList lines = new ArrayList();


  Particle(float x, float y, float z)
  {
    position = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
  }

  void update() {
    //###################################################
    // THE MAGIC - SEED, ATTENUATION, and SPEED control the 3D Perlin Form.
    //###################################################  
    PVector noise = new PVector(ATTENUATION*position.x, ATTENUATION*position.y, ATTENUATION*position.z);
    velocity.x = SPEED*cos(TWO_PI*noise(noise.x,noise.y,noise.z)*SEED);
    velocity.y = SPEED*sin(TWO_PI*noise(noise.x,noise.y,noise.z)*SEED);
    velocity.z = SPEED*atan(TWO_PI*noise(noise.x,noise.y,noise.z)*SEED);
    lines.add(new Line(position.x, position.y, position.z, position.x+velocity.x, position.y+velocity.y, position.z+velocity.z));
//    lifespan--;
    PVector particle = new PVector (X_BOUND/2,Y_BOUND/2,Z_BOUND/2);
    if (sqrt(pow((position.x - WIDTH/2),2) + 
    pow((position.y - HEIGHT/2),2) + 
    pow((position.z - HEIGHT/2),2)) < 280){
      
        PVector direction = new PVector(velocity.x,velocity.y,velocity.z);
        direction.sub(position);
        PVector normal = new PVector(position.x,position.y,position.z);
        normal.sub(particle);
        normal.normalize();
        normal.mult(2 * direction.dot(normal));
        direction.sub(normal);
        direction.normalize();
        velocity.mult(direction);
    }
    
    position.add(velocity);
    
    //###################################################
    //If the particles are BOUNDED, send the to the opposite site of
    // the bounding box when they cross a boundary of the bounding box.
    //###################################################
    if(BOUNDED){
      if (position.x<0) {
        position.x+=X_BOUND;
      }
  
      if (position.x>X_BOUND) {
        position.x-=X_BOUND;
      }
  
      if (position.y<0) {
        position.y+=Y_BOUND;
      }
  
      if (position.y>Y_BOUND) {
        position.y-=Y_BOUND;
      }
  
      if (position.z<0) {
        position.z+=Z_BOUND;
      }
  
      if (position.z>Z_BOUND) {
        position.z-=Z_BOUND;
      }
    }
  }

  
  //###################################################
  // Particle draw function.
  //###################################################
  void draw() {
    if(!redraw){
      //If we're not redrawing the scene, make the tail length of the particles 200.
      while ( lines.size () > 200 ) {
        lines.remove(0);
      }
    } else { 
      while ( lines.size () > TAIL_LENGTH ) {
        lines.remove(0);
      }
    }
    for (int i = 0; i < lines.size(); i++) {
      Line pv = (Line)lines.get(i);
      float r = 355;
      float g = 355;
      float b = 355;
      //If its not monochorme add colors.
      if(!MONOCHROME){
        r *= ((pv.x)/X_BOUND);
        g *= ((pv.y)/Y_BOUND);
        b *= ((pv.z)/Z_BOUND);
      }
      stroke(r, g, b, 100 + sqrt(5 * i));
      pv.draw();
    }
  }
}

//###################################################
//Class for drawing lines
//###################################################
class Line {

  float x;
  float y;
  float z;
  float dx;
  float dy;
  float dz;

  Line(float sx, float sy, float sz, float ex, float ey, float ez) {
    this.x = sx;
    this.y = sy;
    this.z = sz;
    this.dx = ex;
    this.dy = ey;
    this.dz = ez;
  }

  void draw() {
    line(x, y, z, dx, dy, dz);
  }
}
