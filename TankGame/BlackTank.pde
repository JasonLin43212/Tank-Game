public class BlackTank extends Tank {

  public BlackTank(float x, float y, int id) {
    super(x, y, 0, id, color(22, 13, 14), 2, 40, 2, 2, x, y);
  }

  public void move() {
    super.move();
    if ((int)(random(100)) == 1) {
      plantBomb();
    }
    up=0;
    down=0;
    right=0;
    left=0;
    float shortestBulletLength = 1600;
    boolean shouldMove = false;
    Bullet closestBullet = null;
    if (allBullets.size()>0) {
      for (int i=0; i<allBullets.size(); i++) {
        Bullet currentBullet = allBullets.get(i);
        if (dist(x, y, currentBullet.x, currentBullet.y)<shortestBulletLength) {
          shortestBulletLength = dist(x, y, currentBullet.x, currentBullet.y);
          closestBullet = currentBullet;
        }
      }
    }
    float shortestBombLength = 1600;
    Bomb closestBomb = null;
    if (allBombs.size()>0) {
      for (int i=0; i<allBombs.size(); i++) {
        Bomb currentBomb = allBombs.get(i);
        if (dist(x, y, currentBomb.x, currentBomb.y)<shortestBombLength) {
          shortestBombLength = dist(x, y, currentBomb.x, currentBomb.y);
          closestBomb = currentBomb;
        }
      }
    }
    float angleOfMovement = 0;
    if (shortestBulletLength < shortestBombLength && shortestBulletLength < 150) {
      movementCounter = 0;
      float newBulletDirection = closestBullet.direction;
      float tankBulletAngle = atan2(y+15-closestBullet.y, x+15-closestBullet.x);
      if (newBulletDirection>PI) {
        newBulletDirection -= 2*PI;
      }
      float angleDifference = tankBulletAngle - newBulletDirection;
      if (angleDifference > PI) {
        angleDifference -=2*PI;
      } else if (angleDifference < -PI) {
        angleDifference += 2*PI;
      }
      angleOfMovement = newBulletDirection;
      if (angleDifference <0) {
        angleOfMovement -= PI/2;
      } else {
        angleOfMovement += PI/2;
      }
      shouldMove = true;
    } else if (shortestBombLength < 100) {
      if (movementCounter == 0) {
        pathfind(0, new int[]{(int)(closestBomb.y/40), (int)(closestBomb.x/40)});
        movementCounter = 120;
      } else if (movementCounter > 0) {
        angleOfMovement = atan2((newLocation[0]*40+20)-this.y, (newLocation[1]*40+20)-this.x);
      }
      shouldMove = true;
    } else {
      if (movementCounter == 0) {
        if (random(7)>4.5) {
          pathfind(0, new int[]{(int)(player.y/40), (int)(player.x/40)});
        } else {
          pathfind(1, new int[]{(int)(player.y/40), (int)(player.x/40)});
        }
        movementCounter = 200;
      } else if (movementCounter > 0) {
        angleOfMovement = atan2((newLocation[0]*40+20)-this.y, (newLocation[1]*40+20)-this.x);
      }
      shouldMove = true;
    }
    if (shouldMove) {
      if (angleOfMovement>PI) {
        angleOfMovement -= 2*PI;
      } else if (angleOfMovement <-PI) {
        angleOfMovement += 2*PI;
      }
      if (angleOfMovement>=-3*PI/8 && angleOfMovement<=3*PI/8) {
        right=1;
      }
      if (angleOfMovement>=PI/8 && angleOfMovement<=7*PI/8) {
        down=1;
      }
      if (angleOfMovement>=-7*PI/8 && angleOfMovement<=-PI/8) {
        up=1;
      }
      if (angleOfMovement>=5*PI/8 && angleOfMovement<=PI || angleOfMovement<=-5*PI/8 && angleOfMovement>=-PI) {
        left=1;
      }
    }
    direction = atan2(player.y-y, player.x-x);
  }

  public void shoot() {
    if (currentBullet < maxBullet && shootCoolDown == 0 && (predictShooting(player).equals("player")||(int)(random(60000))==0)) {
      allBullets.add(new Bullet(x+15+cos(direction)*35, y+15+sin(direction)*35, 8, direction, id, 1, maxBulletId+1, "missile"));
      maxBulletId++;
      shootCoolDown=shootCoolDownReset;
    }
  }
}
