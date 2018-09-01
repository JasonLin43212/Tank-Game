public abstract class Tank {

  float x, y, direction, speed, originX, originY;
  int id, up, right, down, left, maxBullet, currentBullet, shootCoolDown, shootCoolDownReset, currentBomb, maxBomb, movementCounter;
  color tankColor;
  boolean isDead;
  int[] newLocation = {200, 200, 0};

  public Tank (float x, float y, float direction, int id, color tankColor, 
    int maxBullet, int shootCoolDownReset, float speed, int maxBomb, 
    float originX, float originY) {
    this.x=x;
    this.y=y;
    this.direction=direction;
    this.id=id;
    this.tankColor=tankColor;
    this.maxBullet=maxBullet;
    this.shootCoolDownReset=shootCoolDownReset;
    this.speed=speed;
    this.maxBomb=maxBomb;
    this.originX=originX;
    this.originY=originY;
    this.movementCounter = 1;
    shootCoolDown=shootCoolDownReset;
  }

  public void move() {
    if (movementCounter > 0) {
      movementCounter--;
    }
    if (canFight) {
      float[] newLocation = collide(currentMap);
      x = newLocation[0];
      y = newLocation[1];
      x += speed*(right-left);
      y += speed*(down-up);
    }
  }

  public void controlMovement(int num, int mode) {
    if (num == 87) {
      up=mode;
    }
    if (num == 65) {
      left=mode;
    }
    if (num == 83) {
      down=mode;
    }
    if (num == 68) {
      right=mode;
    }
    if (num == 32 && canFight) {
      plantBomb();
    }
  }

  public void plantBomb() {
    if (currentBomb < maxBomb) {
      allBombs.add(new Bomb(x+15, y+15, id, maxBombId));
      maxBombId++;
      if (maxBombId > 39) {
        maxBombId = 0;
      }
    }
  }
  //public abstract void die();

  public float[] collide(String[][] map) {
    float[] output = new float[2];
    float xcor = x;
    float ycor = y;
    int blockRow = (int)(y/40);
    int blockCol = (int)(x/40);
    if (!map[blockRow+1][blockCol].equals(" ")) {
      if (y > (blockRow+1)*40-30-speed) {
        ycor = (blockRow+1)*40-30-speed;
      }
    }
    if (!map[blockRow-1][blockCol].equals(" ")) {
      if (y < blockRow*40+speed) {
        ycor = blockRow*40+speed;
      }
    }
    if (!map[blockRow][blockCol+1].equals(" ")) {
      if (x > (blockCol+1)*40-30-speed) {
        xcor = (blockCol+1)*40-30-speed;
      }
    }
    if (!map[blockRow][blockCol-1].equals(" ")) {
      if (x < blockCol*40+speed) {
        xcor = blockCol*40+speed;
      }
    }
    if (!map[blockRow+1][blockCol-1].equals(" ")) {
      if (x < blockCol*40+speed && y > (blockRow+1)*40-30-speed) {
        xcor = blockCol*40+speed;
        /*
        if (blockRow*50-y<x+20-(blockCol-1)*50) {
         xcor = blockCol*50+1;
         ycor = y;
         } else if (blockRow*50-y>x+20-(blockCol-1)*50) {
         xcor = x;
         ycor = (blockRow+1)*50-21;
         }
         */
      }
    }
    if (!map[blockRow-1][blockCol+1].equals(" ")) {
      if (x > (blockCol+1)*40-30-speed && y < blockRow*40+speed) {
        ycor = blockRow*40+speed;
      }
    }
    if (!map[blockRow+1][blockCol+1].equals(" ")) {
      if (x > (blockCol+1)*40-30-speed && y > (blockRow+1)*40-30-speed) {
        if (blockRow*40-y<blockCol*40-x) {
          xcor = (blockCol+1)*40-30-speed;
          ycor = y;
        } else if (blockRow*40-y>blockCol*40-x) {
          xcor = x;
          ycor = (blockRow+1)*40-30-speed;
        }
      }
    }
    output[0] = xcor;
    output[1] = ycor;
    return output;
  }

  public void display() {
    fill(tankColor);
    stroke(1);
    rect(x, y, 30, 30);
    pushMatrix();
    translate(x+15, y+15);
    rotate(direction);
    rect(2, -3, 24, 6);
    popMatrix();
    if (shootCoolDown > 0 && canFight) {
      shootCoolDown--;
    }
  }

  public void updateAmmunitionCount() {
    int numBullets = 0;
    int numBombs = 0;
    for (int i=0; i<allBullets.size(); i++) {
      if (allBullets.get(i).parentId == id) {
        numBullets++;
      }
    }
    for (int i=0; i<allBombs.size(); i++) {
      if (allBombs.get(i).parentId == id) {
        numBombs++;
      }
    }
    currentBullet = numBullets;
    currentBomb = numBombs;
  }

  //0 : Defensive
  //1 : Offensive
  public void pathfind(int mode, int[] target) {
    String[][] copyOfCopy = new String[19][24];
    for (int i=0; i<19; i++) {
      for (int j=0; j<24; j++) {
        copyOfCopy[i][j] = currentMap[i][j];
      }
    }
    FrontierPriorityQueue frontier;
    frontier = new FrontierPriorityQueue(false);
    int blockRow = (int) (y/40);
    int blockCol = (int) (x/40);
    if (blockRow+1!=18 && !isWall(blockRow+1, blockCol, copyOfCopy)) {
      frontier.add(new int[]{blockRow+1, blockCol, abs(blockRow+1-target[0])+abs(blockCol-target[1])});
      copyOfCopy[blockRow+1][blockCol] = "X";
    }
    if (blockRow-1!=0 && !isWall(blockRow-1, blockCol, copyOfCopy)) {
      frontier.add(new int[]{blockRow-1, blockCol, abs(blockRow-1-target[0])+abs(blockCol-target[1])});
      copyOfCopy[blockRow-1][blockCol] = "X";
    }
    if (blockCol+1!=24 && !isWall(blockRow, blockCol+1, copyOfCopy)) {
      frontier.add(new int[]{blockRow, blockCol+1, abs(blockRow-target[0])+abs(blockCol+1-target[1])});
      copyOfCopy[blockRow][blockCol+1] = "X";
    }
    if (blockCol-1!=0 && !isWall(blockRow, blockCol-1, copyOfCopy)) {
      frontier.add(new int[]{blockRow, blockCol-1, abs(blockRow-target[0])+abs(blockCol-1-target[1])});
      copyOfCopy[blockRow][blockCol-1] = "X";
    }
    while (frontier.hasNext()) {
      int[] currentLocation = frontier.next();
      int curManDist = abs(blockRow-currentLocation[0]) + abs(blockCol-currentLocation[1]);
      if (curManDist < 10) {
        if ((mode==0 && newLocation[2] < currentLocation[2])||(mode==1 && newLocation[2] > currentLocation[2])) { 
          newLocation = currentLocation;
        }
        int curRow = currentLocation[0];
        int curCol = currentLocation[1];
        if (curRow+1!=18 && !isWall(curRow+1, curCol, copyOfCopy)) {
          frontier.add(new int[]{curRow+1, curCol, abs(curRow+1-target[0])+abs(curCol-target[1])});
          copyOfCopy[curRow+1][curCol] = "X";
        }
        if (curRow-1!=0 && !isWall(curRow-1, curCol, copyOfCopy)) {
          frontier.add(new int[]{curRow-1, curCol, abs(curRow-1-target[0])+abs(curCol-target[1])});
          copyOfCopy[curRow-1][curCol] = "X";
        }
        if (curCol+1!=24 && !isWall(curRow, curCol+1, copyOfCopy)) {
          frontier.add(new int[]{curRow, curCol+1, abs(curRow-target[0])+abs(curCol+1-target[1])});
          copyOfCopy[curRow][curCol+1] = "X";
        }
        if (curCol-1!=0 && !isWall(curRow, curCol-1, copyOfCopy)) {
          frontier.add(new int[]{curRow, curCol-1, abs(curRow-target[0])+abs(curCol-1-target[1])});
          copyOfCopy[curRow][curCol-1] = "X";
        }
      }
    }
  }

  public String predictShooting (Tank target) {
    float delX = target.x-x;
    float delY = target.y-y;
    if (delX == 0) {
      delX=0.05;
    }
    float angle = atan2(delY, delX);
    float rayX = x;
    float rayY = y;
    int rayBlockRow = (int)(rayY/40);
    int rayBlockCol = (int)(rayX/40);
    int targetRow = (int)(target.y/40);
    int targetCol = (int)(target.x/40);
    while (rayBlockRow != targetRow || rayBlockCol != targetCol) {
      rayX += 10*cos(angle);
      rayY += 10*sin(angle);
      rayBlockRow = (int)(rayY/40);
      rayBlockCol = (int)(rayX/40);
      String currentBlock = currentMap[rayBlockRow][rayBlockCol];
      if (currentBlock.equals("X") || currentBlock.equals("#")) {
        return "wall";
      }
    }
    return "player";
  }

  public abstract void shoot();

  private boolean isWall(int row, int col, String[][] map) {
    return map[row][col].equals("#") || map[row][col].equals("X") || map[row][col].equals("O");
  }
  /*
  public float moveToLocation() {
   
   return 0;
   }
   */
}
