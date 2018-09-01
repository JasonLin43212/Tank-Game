public class PlayerTank extends Tank {

  public PlayerTank(float x, float y) {
    super(x, y, 0, 0, color(61, 106, 149), 5, 6, 2, 2, x, y);
  }

  public void move() {
    super.move();
    direction = atan2(mouseY-y-15, mouseX-x-15);
  }

  public void shoot() {
    if (currentBullet < maxBullet && shootCoolDown == 0) {
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
