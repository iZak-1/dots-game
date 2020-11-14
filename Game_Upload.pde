/**
Instructions: click to revive dead balls. You can't revive a ball if the white ball is over it. Every once in a while, a new ball springs up, and the white gets faster!
**/

Ball[] ballArray;
int counter;
void setup() {
  size((int)(0.95*window.innerWidth), (int)(0.95*window.innerHeight));
  ballArray = new Ball[20];
  for (int i=0; i<ballArray.length; i++) {  
    ballArray[i]=new Ball();
    if(i==0) {
      ballArray[i]=new OddBall();
    }
  }
  textAlign(CENTER,CENTER);
  textSize(width/40);
  frameRate(100);
}

void draw() {
  background(0,0,0);
  for (int i=0; i<ballArray.length; i++) {
    ballArray[i].move();
    ballArray[i].show();
  }
}  

void keyPressed() {
  setup();
}
void mouseClicked(){
  for (int i=0; i<ballArray.length; i++) {  
    if(dist(mouseX,mouseY,ballArray[i].myX,ballArray[i].myY)<=ballArray[i].mySize&&ballArray[i].myLife<=0&&(dist(ballArray[0].myX,ballArray[0].myY,ballArray[i].myX,ballArray[i].myY)>=ballArray[0].mySize)){
      ballArray[i].myLife=ballArray[i].maxLife;
      ballArray[i].moveSpd=ballArray[i].speed;
      counter++;
      ballArray[0].speed*=1+(width/50000);
      if(counter%5==0) {
        ballArray=(Ball[])append(ballArray, new Ball());
      }
    }
  }
}


//----------------------------------------------------------------------------------------------------


class Ball {
  float speed, moveSpd, myX, myY, mySize;
  color myColor;
  int myLife, maxLife;
  Ball() {
    myX=width*(float)Math.random();
    myY=height*(float)Math.random();
    speed=(width/1000)*(3+5*(float)Math.random());
    moveSpd=speed;
    mySize=width/40;
    maxLife=(int)(250+(float)Math.random()*5000);
    myLife=(int)(100+(float)Math.random()*2000);
    myColor = color((int)(255*Math.random()), (int)(255*Math.random()), (int)(255*Math.random()));
  }
  
  void move() {
    myX+=moveSpd*Math.pow(((float)myLife/maxLife),0.5);
    if(myLife>0) {myLife-=1;}
    if(myX>width+mySize) {
      myX=0-mySize;
    }
  }
  void show() {
    if(myLife>0) {
      fill(myColor, 50+(float)(Math.pow(((float)myLife/maxLife),0.5)*205));
      ellipse(myX, myY, mySize, mySize);
    } else{
      fill(255,100,100);
      text("X",myX,myY);
      moveSpd=0;
    }
  }
}



//----------------------------------------------------------------------------------------------------



class OddBall extends Ball {
  OddBall() {
    speed = (width/1000);
    myX=width/2;
    myY=height/2;
    mySize=50;
    myColor = color(255,255,255);
    myLife=1;
    maxLife=1;
  }
  void move() {
    myX+=speed*Math.cos(Math.atan2((float)(mouseY-myY),(float)(mouseX-myX)));
    myY+=speed*Math.sin(Math.atan2((float)(mouseY-myY),(float)(mouseX-myX)));
  }
}
