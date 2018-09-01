public class Menu {

  public Menu () {
  }

  public void drawTitleScreen() {
    background(228, 225, 169);
    textFont(micro);
    textSize(110);
    textAlign(CENTER, CENTER);
    //Tank! Title
    fill(184, 184, 133);
    for (int i=6; i<8; i++) {
      text("Tanks!", 480+i, 100);
      text("Tanks!", 480, 100+i);
      text("Tanks!", 480+i, 100+i);
    }
    fill(86, 126, 129);
    for (int i=-1; i<5; i++) {
      text("Tanks!", 480+i, 100);
      text("Tanks!", 480, 100+i);
      text("Tanks!", 480+i, 100+i);
    }
    fill(204, 249, 254);
    text("Tanks!", 480, 100);
    //do if statement for mouse
    boolean onPlay = mouseX >=345 && mouseX <=615 && mouseY>=250 && mouseY<=330; 
    //Play Button
    noStroke();
    fill(184, 184, 133);
    for (int i=6; i<8; i++) {
      rect(345+i, 250, 270, 80);
      rect(345, 250+i, 270, 80);
      rect(345+i, 250+i, 270, 80);
    }
    if (onPlay) {
      stroke(183, 64, 52);
    } else {
      stroke(153, 60, 40);
    }
    strokeWeight(5);
    if (onPlay) {
      fill(153, 60, 40);
    } else {
      fill(183, 64, 52);
    }
    rect(345, 250, 270, 80);
    //Play Words
    if (onPlay) {
      textSize(55);
    } else {
      textSize(50);
    }
    fill(131, 54, 42);
    for (int i=3; i<5; i++) {
      text("P L A Y", 480+i, 283);
      text("P L A Y", 480, 283+i);
      text("P L A Y", 480+i, 283+i);
    }
    fill(106, 64, 32);
    for (int i=-1; i<3; i++) {
      text("P L A Y", 480+i, 283);
      text("P L A Y", 480, 283+i);
      text("P L A Y", 480+i, 283+i);
    }
    fill(244, 223, 144);
    text("P L A Y", 480, 283);
    //Instruction Button
    boolean onInstr = mouseX >=345 && mouseX <=615 && mouseY>=380 && mouseY<=460; 
    noStroke();
    fill(184, 184, 133);
    for (int i=6; i<8; i++) {
      rect(345+i, 380, 270, 80);
      rect(345, 380+i, 270, 80);
      rect(345+i, 380+i, 270, 80);
    }
    if (onInstr) {
      stroke(183, 64, 52);
    } else {
      stroke(153, 60, 40);
    }
    strokeWeight(5);
    if (onInstr) {
      fill(153, 60, 40);
    } else {
      fill(183, 64, 52);
    }
    rect(345, 380, 270, 80);
    //Instruction Words
    if (onInstr) {
      textSize(38);
    } else {
      textSize(35);
    }
    fill(131, 54, 42);
    for (int i=3; i<5; i++) {
      text("INSTRUCTIONS", 480+i, 413);
      text("INSTRUCTIONS", 480, 413+i);
      text("INSTRUCTIONS", 480+i, 413+i);
    }
    fill(106, 64, 32);
    for (int i=-1; i<3; i++) {
      text("INSTRUCTIONS", 480+i, 413);
      text("INSTRUCTIONS", 480, 413+i);
      text("INSTRUCTIONS", 480+i, 413+i);
    }
    fill(244, 223, 144);
    text("INSTRUCTIONS", 480, 413);
    fill(0,0,0);
    textSize(20);
    text("Music & Sounds From Wii Play",820,745);
  }

  public void drawInstructions() {
    background(228, 225, 169);
    strokeWeight(4);
    textSize(28);
    //WASD buttons
    int[] xButtons = {150, 90, 150, 210};
    int[] yButtons = {100, 160, 160, 160};
    for (int j=0; j<xButtons.length; j++) {
      for (int i=2; i<4; i++) {
        noFill();
        stroke(184, 184, 133);
        rect(xButtons[j]+i, yButtons[j], 50, 50, 5);
        rect(xButtons[j], yButtons[j]+i, 50, 50, 5);
        rect(xButtons[j]+i, yButtons[j]+i, 50, 50, 5);
      }
      fill(255, 255, 255);
      stroke(0, 0, 0);
      rect(xButtons[j], yButtons[j], 50, 50, 5);
    }
    //Space bar
    for (int i=2; i<4; i++) {
      noFill();
      stroke(184, 184, 133);
      rect(670+i, 160, 200, 50, 5);
      rect(670, 160+i, 200, 50, 5);
      rect(670+i, 160+i, 200, 50, 5);
    }
    fill(255, 255, 255);
    stroke(0, 0, 0);
    rect(670, 160, 200, 50, 5);
    for (int i=1; i<3; i++) {
      fill(220, 220, 220); 
      text("Space", 770+i, 181);
      text("Space", 770, 181+i);
      text("Space", 770+i, 181+i);
    }
    fill(0, 0, 0);
    text("Space", 770, 181);
    //Mouse
    for (int i=2; i<4; i++) {
      noFill();
      stroke(184, 184, 133);
      ellipse(480+i, 180, 150, 200);
      ellipse(480, 180+i, 150, 200);
      ellipse(480+i, 180+i, 150, 200);
    }
    fill(255, 255, 255);
    stroke(0, 0, 0);
    ellipse(480, 180, 150, 200);
    arc(480, 180, 150, 200, -PI/2, 0, PIE);
    fill(253, 15, 17);
    arc(480, 180, 150, 200, PI, 3*PI/2, PIE);
    fill(255, 255, 255);
    rect(470, 110, 20, 35, 5);
    //All Other text
    String[] words = {"Move", "Aim & Shoot", "Plant Mine", "Defeat all enemies without getting killed!", "Use mines to destroy pink walls.", "W", "A", "S", "D"};
    int[] wordX = {175, 480, 775, 480, 480, 176, 116, 176, 236};
    int[] wordY = {250, 310, 250, 400, 450, 123, 183, 183, 183};
    for (int j=0; j<words.length; j++) {
      for (int i=1; i<3; i++) {
        if (j<5) {
          fill(184, 184, 133);
        } else {
          fill(220, 220, 220);
        }
        text(words[j], wordX[j]+i, wordY[j]);
        text(words[j], wordX[j], wordY[j]+i);
        text(words[j], wordX[j]+i, wordY[j]+i);
      }
      fill(0, 0, 0);
      text(words[j], wordX[j], wordY[j]);
    }
    //Main Menu Button
    boolean onMenu = mouseX >=365 && mouseX <=615 && mouseY>=525 && mouseY<=575; 
    noStroke();
    fill(184, 184, 133);
    for (int i=6; i<8; i++) {
      rect(365+i, 525, 250, 50);
      rect(365, 525+i, 250, 50);
      rect(365+i, 525+i, 250, 50);
    }
    if (onMenu) {
      stroke(183, 64, 52);
      fill(153, 60, 40);
    } else {
      stroke(153, 60, 40);
      fill(183, 64, 52);
    }
    strokeWeight(5);
    rect(365, 525, 250, 50);
    //Menu Text
    if (onMenu) {
      textSize(38);
    } else {
      textSize(35);
    }
    fill(131, 54, 42);
    for (int i=3; i<5; i++) {
      text("Main Menu", 490+i, 545);
      text("Main Menu", 490, 545+i);
      text("Main Menu", 490+i, 545+i);
    }
    fill(106, 64, 32);
    for (int i=-1; i<3; i++) {
      text("Main Menu", 490+i, 545);
      text("Main Menu", 490, 545+i);
      text("Main Menu", 490+i, 545+i);
    }
    fill(244, 223, 144);
    text("Main Menu", 490, 545);
  }

  public void drawIntro() {
    background(228, 225, 169);
    noStroke();
    fill(183, 64, 52);
    rect(0, 165, 960, 320);
    fill(190, 159, 40);
    rect(0, 175, 960, 10);
    rect(0, 465, 960, 10);
    String mission = "";
    if (level < 32) {
      mission = "Mission " + level;
    } else if (level == 32) {
      mission = "Final Mission"; 
    }
    textSize(80);
    fill(131, 54, 42);
    for (int i=3; i<6; i++) {
      text(mission, 480+i, 250);
      text(mission, 480, 250+i);
      text(mission, 480+i, 250+i);
    }
    fill(106, 64, 32);
    for (int i=-1; i<3; i++) {
      text(mission, 480+i, 250);
      text(mission, 480, 250+i);
      text(mission, 480+i, 250+i);
    }
    fill(244, 223, 144);
    text(mission, 480, 250);
    String enemy = "Enemy Tanks: " + (allCurrentTanks.size()-1);
    textSize(60);
    fill(131, 54, 42);
    for (int i=3; i<6; i++) {
      text(enemy, 480+i, 360);
      text(enemy, 480, 360+i);
      text(enemy, 480+i, 360+i);
    }
    fill(106, 64, 32);
    for (int i=-1; i<3; i++) {
      text(enemy, 480+i, 360);
      text(enemy, 480, 360+i);
      text(enemy, 480+i, 360+i);
    }
    fill(244, 223, 144);
    text(enemy, 480, 360);
    String life = "Lives: " + lives;
    textSize(50);
    fill(184, 184, 133);
    for (int i=4; i<8; i++) {
      text(life, 480+i, 610);
      text(life, 480, 610+i);
      text(life, 480+i, 610+i);
    }
    fill(86, 126, 129);
    for (int i=-1; i<4; i++) {
      text(life, 480+i, 610);
      text(life, 480, 610+i);
      text(life, 480+i, 610+i);
    }
    fill(204, 249, 254);
    text(life, 480, 610);
  }

  public void drawBonus() {
    textFont(micro);
    textAlign(CENTER, CENTER);
    background(228, 225, 169);
    noStroke();
    fill(184, 184, 133);
    for (int i=1; i<8; i++) {
      rect(160+i, 266, 640, 114);
      rect(160, 266+i, 640, 114);
      rect(160+i, 266+i, 640, 114);
    }
    fill(102, 137, 104);
    stroke(34, 57, 26);
    strokeWeight(4);
    rect(160,266,640,114);
    noStroke();
    rect(159,268,643,111);
    stroke(34, 57, 26);
    strokeWeight(2);
    rect(159,270,642,106);
    noStroke();
    rect(158,271,645,105);
    String life = "Lives: " + lives;
    textSize(50);
    fill(184, 184, 133);
    for (int i=4; i<8; i++) {
      text(life, 480+i, 610);
      text(life, 480, 610+i);
      text(life, 480+i, 610+i);
    }
    fill(86, 126, 129);
    for (int i=-1; i<4; i++) {
      text(life, 480+i, 610);
      text(life, 480, 610+i);
      text(life, 480+i, 610+i);
    }
    fill(204, 249, 254);
    text(life, 480, 610);
    String bonusTank = "Bonus Tank!";
    textSize(50);
    fill(77, 99, 77);
    for (int i=4; i<6; i++) {
      text(bonusTank, 480+i, 315);
      text(bonusTank, 480, 315+i);
      text(bonusTank, 480+i, 315+i);
    }
    fill(56, 55, 0);
    for (int i=-1; i<4; i++) {
      text(bonusTank, 480+i, 315);
      text(bonusTank, 480, 315+i);
      text(bonusTank, 480+i, 315+i);
    }
    fill(205, 187, 16);
    text(bonusTank, 480, 315);
  }
}
