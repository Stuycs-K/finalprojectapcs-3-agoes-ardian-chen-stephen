GameManager manager;

void setup(){
  size(1000, 1000);
  manager = new GameManager(2);
}

void draw(){
  manager.update();
  
}
