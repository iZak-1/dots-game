class Ball {
  float speed, moveSpd, myX, myY, mySize;
  color myColor;
  int myLife, maxLife;
  Ball() {
    speed=(width/1000)*(3+5*(float)Math.random());
    moveSpd=speed;
    mySize=(0.75+0.5*(float)Math.random())*width/40;
    myX=width*(float)Math.random();
    myY=mySize/2+(height-mySize)*(float)Math.random();
    maxLife=(int)(1000+(float)Math.random()*5000);
    myLife=(int)(50+(float)Math.random()*3000);
    myColor = color((int)(255*Math.random()), (int)(255*Math.random()), (int)(255*Math.random()));
  }
  
  void move() {
    myX+=moveSpd*Math.pow(((float)myLife/maxLife),0.5);
    if(myLife>0&&myX>mySize&&myX<width-mySize) {myLife-=1;}
    if(myX>width+mySize) {
      myX=0-mySize;
    }
  }
  void show() {
    if(myLife>0) {
      noStroke();
      fill(myColor, 50+(float)(Math.pow(((float)myLife/maxLife),0.5)*205));
    } else{
      stroke(255,0,0);
      strokeWeight(2);
      line(myX+mySize/2*cos(PI/4),myY+mySize/2*sin(PI/4),myX-mySize/2*cos(PI/4),myY-mySize/2*sin(PI/4));
      line(myX+mySize/2*cos(PI/4),myY-mySize/2*sin(PI/4),myX-mySize/2*cos(PI/4),myY+mySize/2*sin(PI/4));

      moveSpd=0;
      stroke(255,255,255);
      noFill();
      strokeWeight(1);
    }
    ellipse(myX, myY, mySize, mySize);
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
boolean didClick;
boolean prep;
int score;
int startTime;
void setup() {
  prep=true;
  didClick=false;
  startTime=millis();;
  
  //CHANGE FOR GITHUB!
  size((int)(0.95*window.innerWidth), (int)(0.95*window.innerHeight));
  ballArray = new Ball[20];
  for (int i=0; i<ballArray.length; i++) {  
    ballArray[i]=new Ball();
    if(i==0) {
      ballArray[i]=new OddBall();
    }
  }
  frameRate(100);
  textAlign(CENTER,TOP);
}

void draw() {
  background(0,0,0);
  if(prep) {
    fill(255);
    textSize(width/50);
    text("Directions:\n\nDots will move across the screen at different speeds. As a dot approaches its death, it will get slower and more transparent. Once a dot dies, it'll turn into a circle with an X in it. To revive a dead dot, click on it. You can't revive a dot when the white circle is over it. You gain one point for every dot you revive, and lose one for every misclick. As time goes by, the white circle will get faster and you'll get more dots. If 20% of the dots are dead, you lose.\n\nPlease don't use a touchscreen. The game works best when your mouse can't teleport.", width/20,height/10, 18*width/20,9*height/10);
    textSize(width/75);
    text("Press the spacebar to begin", width/2,2*height/3);
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
      if(numDead>ballArray.length/5.0) {
        noLoop();
        DeadScreen();
      }
    }
  }
}  

void keyPressed() {
  if(prep&&keyCode==32) {
    startTime=millis();
    score=0;
    prep = false;
  } else if(numDead>ballArray.length/5.0&&keyCode==32) {
    loop();
    prep=false;
    setup();
  }
}
void mouseClicked(){
  didClick=false;
  for (int i=0; i<ballArray.length; i++) {  
    if(dist(mouseX,mouseY,ballArray[i].myX,ballArray[i].myY)<=ballArray[i].mySize/2&&ballArray[i].myLife<=0&&(dist(ballArray[0].myX,ballArray[0].myY,ballArray[i].myX,ballArray[i].myY)>=ballArray[0].mySize/2)){
      ballArray[i].myLife=ballArray[i].maxLife;
      ballArray[i].moveSpd=ballArray[i].speed;
      counter++;
      if(ballArray[0].speed<width/500) {
        ballArray[0].speed+=(width/50000);
      } else if(ballArray[0].mySize<=width/25) {
        ballArray[0].mySize*=1.05;
      }
      if(counter%5==0) {
        ballArray=(Ball[])append(ballArray, new Ball());
      }
      ballArray[i].speed=(width/1000)*(3+5*(float)Math.random());
      ballArray[i].maxLife=(int)(1000+(float)Math.random()*5000-10*score);
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
  text("You lasted "+round((millis()-startTime)/100)/10.0+" seconds, and got a score of "+score+"\npress the space key to restart",width/2,3*height/4);
}
