import processing.serial.*;
import processing.sound.*;

SoundFile soundfile;
Serial serial;
int count = 0;  //振った回数
int count_num = 0;
int particle_num = 10;   //粒子の個数
float speed = 0;
ArrayList<Particle> particles = new ArrayList<Particle>(); //粒子のリストを生成
void setup() {
  //size(800, 800);
  fullScreen();
  background(255);
  serial = new Serial(this, "COM7", 9600);
  serial.clear();
  serial.bufferUntil(10);
  soundfile = new SoundFile(this, "tansan_001.wav");
}

void draw() {
  fade(true);  //残像をつけるかどうか
  fill(#FFFFFF);
  textSize(20);
  text(count, 50, 50);
  if (count_num > 0) {
    if (!soundfile.isPlaying()) {
      soundfile.play();
    }
    for (int i = 0; i < particle_num; i++) {
      particles.add(new Particle(speed, i));  //粒子を生成
    }
    count_num -= 2;
  }
  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).update();  //粒子の位置を更新
    particles.get(i).dhisplay();//粒子を描画
    if (particles.get(i).pos.y > height) {
      particles.remove(i);
      if(i == particles.size()-1){
        soundfile.stop();
        soundfile.jump(0);
      }
    }
  }
}



void serialEvent(Serial serial) {
  String data = serial.readStringUntil('\n');
  data = trim(data);
  count = int(data);
  count_num = count;
  speed  = constrain(count, 0, 30) * (-0.8);
  println(count);
}

void fade(boolean fadeFrag) { //残像表現
  if (fadeFrag) {
    fill(0, 80);
    rect(0, 0, width, height);
  } else {
    background(0);
  }
}
