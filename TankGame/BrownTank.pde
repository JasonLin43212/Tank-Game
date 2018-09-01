public class BrownTank extends Tank {

  public BrownTank (float x, float y, int id) {
    super(x, y, 0, id, color(111, 83, 41), 1, 250, 1, 0, x, y);
  }

  //collide thing
  public void move() {
    super.move();
    up=0;
    down=0;
    right=0;
    left=0;
    direction = atan2(player.y-y, player.x-x);
  }

  public void shoot() {
    if (currentBullet < maxBullet && shootCoolDown == 0 && (predictShooting(player).equals("player")||(int)(random(400))==0)) {
      shoot.trigger();
      allBullets.add(new Bullet(x+15+cos(direction)*35, y+15+sin(direction)*35, 4, direction, id, 2, maxBulletId+1,"normal"));
      maxBulletId++;
      if (maxBulletId >99) {
        maxBulletId = 0; 
      }
      shootCoolDown=shootCoolDownReset;
    }
  }
}
