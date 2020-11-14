/**
Instructions: click to revive dead balls. You can't revive a ball if the white ball is over it. Every once in a while, a new ball springs up, and the white gets faster!
**/
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
      textSize(width/40);
      fill(255,100,100);
      text("X",myX,myY);
      moveSpd=0;
    }
  }
}



//----------------------------------------------------------------------------------------------------



class OddBall extends Ball {
  OddBall() {
    speed = width/1000;
    myX=width/2;
    myY=height/2;
    mySize=width/20;
    myColor = color(255,255,255);
    myLife=1;
    maxLife=1;
  }
  void move() {
    myX+=speed*Math.cos(Math.atan2((float)(mouseY-myY),(float)(mouseX-myX)));
    myY+=speed*Math.sin(Math.atan2((float)(mouseY-myY),(float)(mouseX-myX)));
    
  }
}





//----------------------------------------------------------------------------------------------------









Ball[] ballArray;
int counter;
int numDead;
boolean didClick=false;
boolean prep=true;
int score;
int startTime;
void setup() {
  size((int)(0.95*window.innerWidth), (int)(0.95*window.innerHeight));
  ballArray = new Ball[20];
  for (int i=0; i<ballArray.length; i++) {  
    ballArray[i]=new Ball();
    if(i==0) {
      ballArray[i]=new OddBall();
    }
  }
  textAlign(CENTER,TOP);
  frameRate(100);
}

void draw() {
  background(0,0,0);
  if(prep) {
    textSize(width/50);
    text("Directions:\nDots will move across the screen at different speeds. As a dot approaches its death, it will get slower and more transparent. Once a dot dies, it'll turn into an 'x'. To revive a dead dot, click on it. You can't revive a dot when the white circle is over it. You gain one point for every dot you revive, and lose one for every misclick. As time goes by, the white circle will get faster and you'll get more dots. If there are 10 dead dots at a time, you lose.", width/20,height/10, 18*width/20,9*height/10);
    textSize(width/75);
    text("Click any key to begin", width/2,2*height/3);
  } else{
    
    numDead=0;
    textSize(width/50);
    fill(255);
    text("Score: "+floor(score), width/3, 9*height/10);
    text("Time: "+round((millis()-startTime)/100)/10.0, 2*width/3, 9*height/10);
    for (int i=0; i<ballArray.length; i++) {
      ballArray[i].move();
      ballArray[i].show();
      if(ballArray[i].myLife<=0==true) {
        numDead++;
      }
      if(numDead>10) {
        noLoop();
        DeadScreen();
      }
    }
  }
}  

void keyPressed() {
  if(prep) {
    prep = false;
  }
  score=0;
}
void mouseClicked(){
  didClick=false;
  for (int i=0; i<ballArray.length; i++) {  
    if(dist(mouseX,mouseY,ballArray[i].myX,ballArray[i].myY)<=ballArray[i].mySize&&ballArray[i].myLife<=0&&(dist(ballArray[0].myX,ballArray[0].myY,ballArray[i].myX,ballArray[i].myY)>=ballArray[0].mySize)){
      ballArray[i].myLife=ballArray[i].maxLife;
      ballArray[i].moveSpd=ballArray[i].speed;
      counter++;
      if(ballArray[0].speed<width/250) {
        ballArray[0].speed*=1+(width/50000);
      } else if(ballArray[0].mySize<=width/5) {
        ballArray[0].mySize*=1.05;
      }
      if(counter%2==0) {
        ballArray=(Ball[])append(ballArray, new Ball());
      }
      didClick=true;
      score+=1; 
      break;
    }
  }
  
  if (!didClick) {
      score-=1;
  }
}

void DeadScreen() {
  background(0);
  textSize(width/10);
  fill(255,0,0);
  text("You lost!",width/2,height/2);
  textSize(width/50);
  text("You lasted "+round((millis()-startTime)/100)/10.0+" seconds, and got a score of "+score,width/2,3*height/4);
}
