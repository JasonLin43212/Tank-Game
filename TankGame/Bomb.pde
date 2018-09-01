public class Bomb {

  float x, y;
  int parentId, id, countdown;

  public Bomb (float x, float y, int parentId, int id) {
    this.x=x;
    this.y=y;
    this.parentId=parentId;
    this.id=id;
  }

  //have an explostion class
  public void explode () {
    if (countdown <=600) {
      countdown = 601;
      mine.trigger();
    }
    for (int i=0; i<allBombs.size(); i++) {
      Bomb otherBomb = allBombs.get(i);
      int thisBlockRow = (int)(y/40);
      int thisBlockCol = (int)(x/40);
      int otherBlockRow = (int)(otherBomb.y/40);
      int otherBlockCol = (int)(otherBomb.x/40);
      if (otherBomb.id != id && abs(thisBlockRow-otherBlockRow) < 2 && abs(thisBlockCol-otherBlockCol)< 2 && otherBomb.countdown<=594) {
        otherBomb.countdown=595;
      }
    }
  }

  public void display() {
    if (canFight) {
      countdown++;
    }
    fill(190, 177, 70);
    ellipse(x, y, 20, 20);
    if (countdown > 600) {
      fill(252, 196, 97);
      ellipse(x, y, (countdown-600)*8, (countdown-600)*8);
    } else if (countdown == 600) {
      explode();
    } else if (countdown > 480) {
      if (countdown % 9 < 3) {
        fill(213, 148, 104);
      } else if (countdown % 9 < 6) {
        fill(206, 119, 89);
      } else {
        fill(222, 219, 80);
      }
      ellipse(x, y, 18, 18);
    } else if (countdown == 480) {
      beep.trigger();
    } else {
      fill(222, 219, 80);
      ellipse(x, y, 18, 18);
    }
  }
}
