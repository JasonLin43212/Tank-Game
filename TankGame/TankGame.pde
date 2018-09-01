import java.util.*;
import java.io.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Maps allMaps;
Menu allMenus;
PFont micro;
String[][] currentMap = new String[19][24];
String[][] mapCopy = new String[19][24];
int[] kills = new int[8];
ArrayList<Tank> allCurrentTanks = new ArrayList<Tank>();
ArrayList<Bullet> allBullets = new ArrayList<Bullet>();
ArrayList<Bomb> allBombs = new ArrayList<Bomb>();
int maxBulletId = 0;
int maxTankId = 1;
int maxBombId = 0;
int level = 1;
int lives = 30;
int pageNum = 0;
String texture = "normal";
int introCounter = 0;
int intoCounter = 0;
int outCounter = 0;
int bonusCounter = 0;
int endCounter = 0;
boolean canFight = false;
//All sound files
Minim minim;
AudioPlayer bonus;
AudioPlayer end;
AudioPlayer menu;
AudioPlayer prequel;
AudioPlayer start;
AudioPlayer tank1;
AudioPlayer tank2;
AudioPlayer win;
AudioPlayer lose;
Sampler whistle;
Sampler mine;
Sampler beep;
Sampler death;
Sampler shoot;
Sampler bounce;
AudioOutput out;

PlayerTank player = new PlayerTank(0, 0);

void setup() {
  noCursor();
  size(960, 760);
  allMaps = new Maps();
  allMenus = new Menu();
  micro = createFont("microsquare-bold.ttf", 32);
  minim = new Minim(this);
  out = minim.getLineOut();
  bounce  = new Sampler( "click.mp3", 30, minim );
  shoot = new Sampler( "shoot.mp3", 30, minim );
  mine = new Sampler( "mine.mp3", 24, minim );
  beep = new Sampler( "beep.mp3", 24, minim );
  death = new Sampler( "death.mp3", 10, minim );
  whistle = new Sampler("whistle.mp3", 8, minim);
  bounce.patch(out);
  shoot.patch(out);
  mine.patch(out);
  beep.patch(out);
  death.patch(out);
  whistle.patch(out);
  bonus = minim.loadFile("bonus.mp3");
  end = minim.loadFile("end.wav");
  menu = minim.loadFile("menu.wav");
  prequel = minim.loadFile("prequel.mp3");
  start = minim.loadFile("start.mp3");
  tank1 = minim.loadFile("tank1.wav");
  tank2 = minim.loadFile("tank2.wav");
  win = minim.loadFile("win.mp3");
  lose = minim.loadFile("lose.mp3");
  menu.loop();
  setUpLevel();
}

void draw() {
  if (pageNum == 0) {
    allMenus.drawTitleScreen();
  } else if (pageNum == -1) {
    allMenus.drawInstructions();
  } else if (pageNum == 1) {
    if (introCounter == 200) {
      start.rewind();
      start.play();
      introCounter--;
    } else if (introCounter > 0) {
      introCounter--;
    } else if (introCounter == 0) {
      pageNum = 2;
      prequel.rewind();
      prequel.play();
      intoCounter = 240;
      canFight = false;
    }
    allMenus.drawIntro();
    if (introCounter < 60) {
      fill(255, 255, 255, 4*(60-introCounter));
      rect(0, 0, 960, 760);
    } else if (introCounter == 495) {
      fill(255, 255, 255, 255); 
      rect(0, 0, 960, 760);
    }
  } else if (pageNum == 2) {
    if (intoCounter > 0 ) {
      intoCounter--;
    }
    if (outCounter > 0) {
      outCounter--;
    }
    if (intoCounter == 1) {
      tank1.rewind();
      tank1.loop();
      canFight = true;
    }
    if (player.isDead) {
      if (lives == 0) {
        pageNum = 4;
        tank1.rewind();
        tank1.pause();
        end.rewind();
        end.loop();
        endCounter = 450;
      } else {
        if (outCounter == 0) {
          tank1.rewind();
          tank1.pause();
          lose.rewind();
          lose.play();
          outCounter = 130;
          canFight = false;
          mine.stop();
          beep.stop();
        } else if (outCounter == 1) {
          reset();
          pageNum = 1;
          lives--;
          introCounter = 200;
        }
      }
    } else if (allCurrentTanks.size() == 1) {
      tank1.rewind();
      tank1.pause();
      if (outCounter == 0) {
        outCounter = 130; 
        win.rewind();
        win.play();
        canFight = false;
        mine.stop();
        beep.stop();
      } else if (outCounter == 1) {
        level++;
        if (level == 33) {
          pageNum = 4;
          end.rewind();
          end.loop();
          endCounter = 450;
        } else {
          allCurrentTanks.clear();
          setUpLevel();
          if ((level-1)%5==0) {
            pageNum = 3;
            bonusCounter = 120;
            bonus.rewind();
            bonus.play();
          } else {
            pageNum = 1;
          }
          introCounter = 200;
        }
      }
    }
    drawMap();
    drawBombs();
    drawTanks();
    drawBullets();
    if (outCounter <= 130 && outCounter >= 1) {
      fill(255, 255, 255, 255-1.96*outCounter);
      rect(0, 0, 960, 760);
    }
    if (intoCounter <= 240 && intoCounter >= 1) {
      fill(255, 255, 255, 255-1.7*(240 - intoCounter));
      rect(0, 0, 960, 760);
    }
  } else if (pageNum == 3) {
    if (bonusCounter > 0) {
      bonusCounter--;
    } else if (bonusCounter == 0) {
      pageNum = 1;
    }
    if (bonusCounter == 60) {
      lives++;
    }
    allMenus.drawBonus();
  } else if (pageNum == 4) {
    if (endCounter > 0) {
      endCounter--;
    }
    background(213, 170, 125);
    textSize(50);
    fill(230, 223, 180);
    noStroke();
    rect(280, 0, 400, 760);
    fill(167, 171, 135);
    rect(280, 40, 400, 8);
    rect(280, 55, 400, 8);
    rect(280, 70, 400, 8);
    rect(280, 85, 400, 8);
    fill(142, 146, 116);
    for (int i=3; i<5; i++) {
      text("Results", 480+i, 60);
      text("Results", 480, 60+i);
      text("Results", 480+i, 60+i);
    }
    fill(78, 63, 0);
    for (int i=-1; i<3; i++) {
      text("Results", 480+i, 60);
      text("Results", 480, 60+i);
      text("Results", 480+i, 60+i);
    }
    fill(197, 188, 59);
    text("Results", 480, 60);
    textSize(40);
    if (endCounter == 400) {
      whistle.trigger();
    }
    if (endCounter == 350) {
      whistle.trigger();
    }
    if (endCounter == 300) {
      whistle.trigger();
    }
    if (endCounter == 250) {
      whistle.trigger();
    }
    if (endCounter == 200) {
      whistle.trigger();
    }
    if (endCounter == 150) {
      whistle.trigger();
    }
    if (endCounter == 100) {
      whistle.trigger();
    }
    if (endCounter == 50) {
      whistle.trigger();
    }
    if (endCounter <5 && endCounter > 0) {
      whistle.trigger();
    }
    if (endCounter < 400) {
      fill(111, 83, 41);
      rect(410, 140, 60, 25, 30);
      rect(440, 125, 35, 8, 30);
      rect(415, 120, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[0], 540, 140);
    }
    if (endCounter < 350) {
      fill(99, 90, 81);
      rect(410, 200, 60, 25, 30);
      rect(440, 185, 35, 8, 30);
      rect(415, 180, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[1], 540, 200);
    }
    if (endCounter < 300) {
      fill(60, 119, 102);
      rect(410, 260, 60, 25, 30);
      rect(440, 245, 35, 8, 30);
      rect(415, 240, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[2], 540, 260);
    }
    if (endCounter < 250) {
      fill(188, 178, 55);
      rect(410, 320, 60, 25, 30);
      rect(440, 305, 35, 8, 30);
      rect(415, 300, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[3], 540, 320);
    }
    if (endCounter < 200) {
      fill(204, 94, 107);
      rect(410, 380, 60, 25, 30);
      rect(440, 365, 35, 8, 30);
      rect(415, 360, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[4], 540, 380);
    }
    if (endCounter < 150) {
      fill(80, 138, 69);
      rect(410, 440, 60, 25, 30);
      rect(440, 425, 35, 8, 30);
      rect(415, 420, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[5], 540, 440);
    }
    if (endCounter < 100) {
      fill(132, 92, 129);
      rect(410, 500, 60, 25, 30);
      rect(440, 485, 35, 8, 30);
      rect(415, 480, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[6], 540, 500);
    }
    if (endCounter < 50) {
      fill(22, 13, 14);
      rect(410, 560, 60, 25, 30);
      rect(440, 545, 35, 8, 30);
      rect(415, 540, 40, 35, 30);
      fill(63, 35, 0);
      text(kills[7], 540, 560);
    }
    if (endCounter < 1) {
      int totalKills = 0;
      for (int i=0; i<kills.length; i++) { 
        totalKills += kills[i];
      }
      text("Total: " + totalKills, 480, 620);
      boolean onMenu = mouseX >=365 && mouseX <=615 && mouseY>=675 && mouseY<=725; 
      noStroke();
      fill(184, 184, 133);
      for (int i=6; i<8; i++) {
        rect(365+i, 675, 250, 50);
        rect(365, 675+i, 250, 50);
        rect(365+i, 675+i, 250, 50);
      }
      if (onMenu) {
        stroke(183, 64, 52);
        fill(153, 60, 40);
      } else {
        stroke(153, 60, 40);
        fill(183, 64, 52);
      }
      strokeWeight(5);
      rect(365, 675, 250, 50);
      //Menu Text
      if (onMenu) {
        textSize(38);
      } else {
        textSize(35);
      }
      fill(131, 54, 42);
      for (int i=3; i<5; i++) {
        text("Main Menu", 490+i, 695);
        text("Main Menu", 490, 695+i);
        text("Main Menu", 490+i, 695+i);
      }
      fill(106, 64, 32);
      for (int i=-1; i<3; i++) {
        text("Main Menu", 490+i, 695);
        text("Main Menu", 490, 695+i);
        text("Main Menu", 490+i, 695+i);
      }
      fill(244, 223, 144);
      text("Main Menu", 490, 695);
    }
  }
  drawCursor();
}

void drawMap() {
  noStroke();
  for (int i=0; i<19; i++) {
    for (int j=0; j<24; j++) {
      String currentBlock = currentMap[i][j];
      if (currentBlock.equals("X")) {
        fill(213, 170, 125);
        rect(j*40, i*40, 40, 40);
      } else if (currentBlock.equals("O")) {
        fill(255, 237, 184);
        rect(j*40, i*40, 40, 40);
        fill(147, 120, 74);
        ellipse(j*40+20, i*40+20, 36, 32);
        fill(150, 134, 97);
        ellipse(j*40+20, i*40+22, 32, 23);
        fill(111, 95, 58);
        ellipse(j*40+20, i*40+25, 32, 23);
      } else if (currentBlock.equals("#")) {
        fill(196, 131, 190);
        rect(j*40, i*40, 40, 40);
      } else {
        fill(255, 237, 184);
        rect(j*40, i*40, 40, 40);
      }
    }
  }
}

void drawBullets() {
  for (int i=0; i<allBullets.size(); i++) {
    Bullet currentBullet = allBullets.get(i);
    int blockRow = (int)(currentBullet.y/40);
    int blockCol = (int)(currentBullet.x/40);
    if (currentBullet.maxBounce <= currentBullet.currentBounce || blockRow == 19 || blockCol == 24) {
      allBullets.remove(currentBullet);
      i--;
    } else {
      for (int j=i; j<allBullets.size(); j++) {
        Bullet secondBullet = allBullets.get(j);
        if (secondBullet.id != currentBullet.id &&
          dist(currentBullet.x, currentBullet.y, secondBullet.x, secondBullet.y)<5) {
          allBullets.remove(currentBullet);
          allBullets.remove(secondBullet);
          i -=1;
          j=allBullets.size();
        }
      }
      currentBullet.display();
      if (canFight) {
        currentBullet.move();
      }
    }
  }
}

void drawTanks() {
  for (int i=0; i<allCurrentTanks.size(); i++) {
    Tank currentTank = allCurrentTanks.get(i);
    currentTank.move();
    currentTank.display();
    currentTank.updateAmmunitionCount();
    if (currentTank.id != 0 && canFight) {
      currentTank.shoot();
    }
    for (int j=0; j<allBullets.size(); j++) {
      Bullet currentBullet = allBullets.get(j);
      if (dist(currentTank.x+10, currentTank.y+10, currentBullet.x, currentBullet.y)<24) {
        currentTank.isDead = true;
        death.trigger();
        incrementKillCounter(currentTank);
        allCurrentTanks.remove(currentTank);
        allBullets.remove(currentBullet);
        i--;
        j = allBullets.size();
      }
    }
  }
}

void incrementKillCounter(Tank deadTank) {
  if (deadTank.tankColor == color(111, 83, 41)) {
    kills[0]++;
  } else if (deadTank.tankColor == color(99, 90, 81)) {
    kills[1]++;
  } else if (deadTank.tankColor == color(60, 119, 102)) {
    kills[2]++;
  } else if (deadTank.tankColor == color(188, 178, 55)) {
    kills[3]++;
  } else if (deadTank.tankColor == color(204, 94, 107)) {
    kills[4]++;
  } else if (deadTank.tankColor == color(80, 138, 69)) {
    kills[5]++;
  } else if (deadTank.tankColor == color(132, 92, 129)) {
    kills[6]++;
  } else if (deadTank.tankColor == color(22, 13, 14)) {
    kills[7]++;
  }
}

void drawBombs() {
  for (int i=0; i<allBombs.size(); i++) {
    Bomb currentBomb = allBombs.get(i);
    currentBomb.display();
    if (currentBomb.countdown > 620) {
      allBombs.remove(currentBomb);
      int blockRow = (int)(currentBomb.y/40);
      int blockCol = (int)(currentBomb.x/40);
      for (int j=0; j<19; j++) {
        for (int k=0; k<24; k++) {
          String currentBlock = currentMap[j][k];
          if (currentBlock.equals("#") && abs(blockRow-j) < 2 && abs(blockCol-k)< 2) {
            currentMap[j][k] = " ";
          }
        }
      }
      for (int j=0; j<allCurrentTanks.size(); j++) {
        Tank currentTank = allCurrentTanks.get(j);
        if (dist(currentBomb.x, currentBomb.y, currentTank.x+10, currentTank.y+10)<75) {
          currentTank.isDead = true;
          death.trigger();
          allCurrentTanks.remove(currentTank);
          j--;
        }
      }
      i--;
    } else {
      for (int j=0; j<allBullets.size(); j++) {
        Bullet currentBullet = allBullets.get(j);
        if (dist(currentBomb.x, currentBomb.y, currentBullet.x, currentBullet.y)<10) {
          currentBomb.explode();
          allBullets.remove(currentBullet);
          j--;
        }
      }
    }
  }
}

void drawCursor() {
  stroke(149, 229, 255);
  strokeWeight(1);
  fill(0, 64, 216);
  ellipse(mouseX, mouseY, 13, 13);
  noStroke();
  fill(211, 255, 255);
  ellipse(mouseX, mouseY, 7, 7);
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(PI/4);
  fill(0, 64, 216);
  strokeWeight(1);
  stroke(149, 229, 255);
  rect(10, -2, 13, 5, 100);
  rotate(PI/2);
  rect(10, -2, 13, 5, 100);
  rotate(PI/2);
  rect(10, -2, 13, 5, 100);
  rotate(PI/2);
  rect(10, -2, 13, 5, 100);
  popMatrix();
}

void setUpLevel() {
  String[][] nextMap = allMaps.getMap(level);
  for (int i=0; i<19; i++) {
    for (int j=0; j<24; j++) {
      currentMap[i][j] = nextMap[i][j];
    }
  }
  allBullets.clear();
  allBombs.clear();
  maxBulletId = 0;
  maxBombId = 0;
  maxTankId = 1;
  allCurrentTanks.clear();
  for (int i=0; i<19; i++) {
    for (int j=0; j<24; j++) {
      String current = currentMap[i][j];
      if (current.equals("P")) {
        player = new PlayerTank(j*40+20, i*40+20);
        allCurrentTanks.add(player);
        currentMap[i][j] = " ";
      } else if (current.equals("B")) {
        allCurrentTanks.add(new BrownTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      } else if (current.equals("G")) {
        allCurrentTanks.add(new GreyTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      } else if (current.equals("T")) {
        allCurrentTanks.add(new TurquoiseTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      } else if (current.equals("Y")) {
        allCurrentTanks.add(new YellowTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      } else if (current.equals("R")) {
        allCurrentTanks.add(new RedTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      } else if (current.equals("E")) {
        allCurrentTanks.add(new GreenTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      } else if (current.equals("U")) {
        allCurrentTanks.add(new PurpleTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      } else if (current.equals("L")) {
        allCurrentTanks.add(new BlackTank(j*40+20, i*40+20, maxTankId));
        maxTankId++;
        currentMap[i][j] = " ";
      }
      mapCopy[i][j] = currentMap[i][j];
    }
  }
}

void reset() {
  for (int i=0; i<19; i++) {
    for (int j=0; j<24; j++) {
      currentMap[i][j] = mapCopy[i][j];
    }
  }
  player.isDead = false;
  player.up=0;
  player.down=0;
  player.left=0;
  player.right=0;
  allBullets.clear();
  allBombs.clear();
  maxBulletId = 0;
  maxBombId = 0;
  allCurrentTanks.add(player);
  for (int i=0; i<allCurrentTanks.size(); i++) {
    Tank currentTank = allCurrentTanks.get(i);
    currentTank.x = currentTank.originX;
    currentTank.y = currentTank.originY;
  }
}

void keyPressed() {
  if (canFight) {
    if (keyCode == 32) {
      return;
    }
    player.controlMovement(keyCode, 1);
  }
}

void keyReleased() {
  if (canFight) {
    player.controlMovement(keyCode, 0);
  }
}

void mouseClicked() {
  if (pageNum == 0) {
    boolean onPlay = mouseX >=345 && mouseX <=615 && mouseY>=250 && mouseY<=330; 
    if (onPlay) {
      pageNum = 1;
      menu.rewind();
      menu.pause();
      introCounter = 200;
    }
    boolean onInstr = mouseX >=345 && mouseX <=615 && mouseY>=380 && mouseY<=460; 
    if (onInstr) {
      pageNum = -1;
    }
    boolean onNormal = mouseX >=355 && mouseX <=605 && mouseY>=525 && mouseY<=575;
    if (onNormal) {
      texture = "normal";
    }
    boolean onBird = mouseX >=655 && mouseX <=905 && mouseY>=525 && mouseY<=575; 
    if (onBird) {
      texture = "bird";
    }
  } else if (pageNum == -1) {
    boolean onMenu = mouseX >=365 && mouseX <=615 && mouseY>=525 && mouseY<=575;
    if (onMenu) {
      pageNum = 0;
    }
  } else if (pageNum == 2 && canFight) {
    player.shoot();
  } else if (pageNum == 4) {
    boolean onMenu = mouseX >=365 && mouseX <=615 && mouseY>=675 && mouseY<=725;
    if (onMenu) {
      pageNum = 0;
      lives = 30;
      end.pause();
      menu.loop();
      level = 1;
      setUpLevel();
    }
  }
}
