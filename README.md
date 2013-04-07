3D Perlin Form README

I chose to create something beautiful. The program creates particles that move along vectors corresponding with Perlin Noise.

The particles are emitted from a bounding-box. They can also be contained within the bounding box to better observe a cross-section of the perlin noise.

Late Days:
  None

Additional features implemented:
  Emitter can turn on and off.
  Particles can be rendered all at once.
  Particles affected by Perlin Noise


CONTROLS:
  key == '<' || key == ','
    Remove one fifth of the particles in the scene.
  key == '>' || key == '.'
    Emit another plane of particles along the ZY plane of the bounding-box.

  key == '+' || key == '='
    Increase the number of line segments draw on the screen for each particle.
  key == '-'
    Decrease the number of line segments draw on the screen for each particle.

The SEED variable, along with ATTENUATION, affects form of the 3D perlin noise.
  key == '['
    Decrease the SEED value
  key == ']'
    Increase the SEED value

The _BOUND variables control the dimensions of the bounding box

  key == 'x'
    Decrease the X_BOUND
  key == 'X'
    Increase the X_BOUND

  key == 'y'
    Decrease the Y_BOUND
  key == 'Y'
    Increase the Y_BOUND

  key == 'z'
    Decrease the Z_BOUND
  key == 'Z'
    Increase the Z_BOUND

  key == 'r'
    Toggles pseudo redraw. 
    Instead of just not redrawing the background, this allows the particle TAIL_LENGTH to stretch to 200.
  
  key == 'b'
    Toggles whether the particles are bounded by the _BOUND variables, or are allowed to move out into the world.

The ATTENUATION variable, along with SEED, affects form of the 3D perlin noise.
  key == '(' || key == '9'
    Decrease the ATTENUATION variable
  key == ')' || key == '0'
    Increase the ATTENUATION variable

  key == 'd'
    Toggle console debugging.

  key == 'c'
    Toggle colored particles.
  
  keyCode == UP
    Zoom in.
  keyCode == DOWN
    Zoom out.
    

Speeding up the particles means the velocity vector that defines the length of the lines drawn are longer, giving the 3D perlin form more definition with minimal computational load. It also makes the 3D perlin form less defined.

  keyCode == LEFT
    Increase particle speed.
  keyCode == RIGHT
    Decrease particle speed.



