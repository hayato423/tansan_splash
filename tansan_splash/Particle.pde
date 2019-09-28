//粒子のクラス
class Particle {
  PVector pos;  //位置
  PVector vel;  //速度
  PVector acc;  //加速度
  float r;    //粒子の大きさ
  color c;    //粒子の色
  Particle(float speed, int i) { //各変数の初期化
    pos = new PVector(width/2+random(-5, 5), height+speed);
    vel = new PVector(random(-3, 3),random(speed,speed+30));
    acc = new PVector(0, 0.2);
    r = random(5, 25);
    //リストの番号が偶数か奇数かで、色を変更
    if ( i % 2 == 0) {
      c  = color(100, 100, 255);
    } else {
      c = color(100, 255, 255);
    }
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
  }

  void dhisplay() {
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, r, r);
  }
}
