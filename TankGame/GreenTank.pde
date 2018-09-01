public class GreenTank extends Tank {

  public GreenTank(float x, float y, int id) {
    super(x, y, 0, id, color(80, 138, 69), 2, 40, 1, 0, x, y);
  }

  public void move() {
    super.move();
    up=0;
    down=0;
    right=0;
    left=0;
    direction = atan2(player.y-y, player.x-x);
  }

  public void shoot() {
    if (currentBullet < maxBullet && shootCoolDown == 0 && (predictShooting(player).equals("player")||(int)(random(60000))==0)) {
      allBullets.add(new Bullet(x+15+cos(direction)*35, y+15+sin(direction)*35, 8, direction, id, 3, maxBulletId+1, "missile"));
      maxBulletId++;
      shootCoolDown=shootCoolDownReset;
    }
  }
}
