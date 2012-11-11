class Dot {
  float x;
  float y;
  float speed;
  
  Dot(float _x, float _y){
    x = _x;
    y = _y;
    speed = 3;
  }
  
  void display(){
    ellipse(x, y, 10, 10);
  }
  
  void move(){
    if(x < reddestX){
      x+=speed;
    }
    if(x > reddestX) {
      x -= speed;
    }
    if(y < reddestY){
      y += speed;
    }
    if(y > reddestY){
     y -= speed;
    } 
  }
}
    
