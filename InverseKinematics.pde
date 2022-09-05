import processing.serial.*;

float x1, y1, x2, y2;
float angle1 = 0.0;
float angle2 = 0.0;
float angle0 = -HALF_PI;
float angleEndEffector = 0.0;
float segLength = 150;
float midX = 320;
float midY = 320;
Serial myPort;

void setup() {
  size(640, 640);
  strokeWeight(20);
  stroke(255, 160);
  
  x1 = width * 0.5;
  y1 = height * 0.5;
  
  x2 = width * 0.5;
  y2 = height * 0.9;
  
  myPort = new Serial(this, "/dev/cu.usb...", 115200);
}

void draw() {
  background(0);
  float x = mouseX-midX-(50/2.00)+100;
  float y = mouseY-midY+10;
  
  if (x<0) {
    y = y*(-1); 
  }
  
  float nextAngle2 = acos((sq(x)+sq(y)-2*sq(segLength))/(2*segLength*segLength));
  float nextAngle1 =atan(y/x)-atan((segLength*sin(nextAngle2))/(segLength+segLength*cos(nextAngle2)));
  
  float nextAngleEndEffector = (-1)*nextAngle1-nextAngle2;
  
  if (x<0) {
    nextAngle2 = 2*PI-nextAngle2;
    nextAngle1 = PI-nextAngle1;
    nextAngleEndEffector = (-1)*nextAngle1-nextAngle2;
  }
  
  //println("x: ", x, ", y: ", y);
  //println("angle1: ", angle1*180/PI, ", angle2: ", angle2*180/PI);
  
  pushMatrix();
  segment(midX-segLength-100, midY-10, 0, segLength); 
  if (!Float.isNaN(nextAngle1) && !Float.isNaN(nextAngle2) && (x>=0 && y<=0) || (x<=0 && y>=0)) {
    angle1 = nextAngle1;
    angle2 = nextAngle2;
    angleEndEffector = nextAngleEndEffector;
    myPort.write("joint 1 angle " + angle1*180.00/PI);
    myPort.write("joint 2 angle " + angle2*180.00/PI);
    myPort.write("joint 3 angle " + nextAngleEndEffector*180.00/PI);
  } else if (!((x>=0 && y<=0) || (x<=0 && y>=0))) { 
    text("Cannot move robotic lower, since it would hit the plane.", 0, -200);
  } else {
    text("No solution, please move to another position.", 0, -200);
  }
  segment(segLength, 0, angle1, segLength);
  segment(segLength, 0, angle2, segLength);
  segment(segLength, 0, angleEndEffector, 50);
  popMatrix();
  pushMatrix();
  segment(x2,y2,angle0, segLength);
  popMatrix();
  pushMatrix();
  segment(0, midY+10, 0, 640); 
  popMatrix();
}

void segment(float x, float y, float a, float segmentLength) {
  translate(x, y);
  rotate(a);
  line(0, 0, segmentLength, 0);
}

void keyPressed()
{
  if (keyCode == 39)
  {
    angle0 += 0.05;
  }
  else if (keyCode == 37)
  {
    angle0 -= 0.05;
  }
  myPort.write("joint 0 angle " + angle0*180.00/PI+90);
}
