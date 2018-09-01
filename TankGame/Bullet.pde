public class Bullet {

  float x, y, speed, direction;
  int parentId, maxBounce, currentBounce, id;
  boolean isMissile;

  public Bullet (float x, float y, float speed, float direction, int parentId, int maxBounce, int id, String type) {
    this.x=x;
    this.y=y;
    this.speed=speed;
    this.direction=direction;
    this.parentId=parentId;
    this.maxBounce=maxBounce;
    this.id=id;
    if (type.equals("missile")){
       this.isMissile = true; 
    }
    currentBounce = 0;
  }

  public void move() {
    float[] bounceRules = collide(currentMap);
    if (bounceRules[0] == 1) {
      direction = PI - direction;
      currentBounce++;
      bounce.trigger();
    } else if (bounceRules[0] == 2) {
      direction = -direction;
      currentBounce++;
      bounce.trigger();
    } else if (bounceRules[0] == 3) {
      direction = direction + PI;
      currentBounce++;
      bounce.trigger();
    }
    x=bounceRules[1];
    y=bounceRules[2];
    this.x += cos(direction)*speed;
    this.y += sin(direction)*speed;
  }

  /*Return value in format [<bounce direction>,<x coordinate>, <y coordinate>]
   Bounce Directions
   0 - No Bounce
   1 - Left/Right
   2 - Top/Bottom
   3 - Both
   */
  public float[] collide(String[][] map) {
    float[] output = new float[3];
    int collideDirection = 0;
    float xcor = x;
    float ycor = y;
    int blockRow = (int)(y/40);
    int blockCol = (int)(x/40);
    if (blockRow == 18) {
       return new float[]{2,xcor,750}; 
    }
    if (blockCol == 23) {
       return new float[]{1,950,ycor}; 
    }
    if (map[blockRow][blockCol].equals("X") || map[blockRow][blockCol].equals("#")) {
      currentBounce = maxBounce;
    }
    if (map[blockRow+1][blockCol].equals("X") || map[blockRow+1][blockCol].equals("#")) {
      if (y > (blockRow+1)*40-speed) {
        collideDirection += 2;
        ycor = (blockRow+1)*40-speed;
      }
    }
    if (map[blockRow-1][blockCol].equals("X") || map[blockRow-1][blockCol].equals("#")) {
      if (y < ((blockRow)*40)+speed) {
        collideDirection += 2;
        ycor = (blockRow)*40+speed;
      }
    }
    if (map[blockRow][blockCol+1].equals("X") || map[blockRow][blockCol+1].equals("#")) {
      if (x > (blockCol+1)*40-speed) {
        collideDirection += 1;
        xcor = (blockCol+1)*40-speed;
      }
    }
    if (map[blockRow][blockCol-1].equals("X") || map[blockRow][blockCol-1].equals("#")) {
      if (x < (blockCol)*40+speed) {
        collideDirection += 1;
        xcor = (blockCol)*40+speed;
      }
    }
    output[0] = collideDirection;
    output[1] = xcor;
    output[2] = ycor;
    return output;
  }

  public void display() {
    if (isMissile){
      fill(239,152,26);
    }
    else {
      fill(250,237,204);
    }
    ellipse(x, y, 10, 10);
  }
}
