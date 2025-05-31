GameManager manager;

void setup(){
  size(1000, 1000);
  manager = new GameManager(2);
}

void draw() {
  background(255);
  
  manager.update();    
  manager.display();   
}

void mousePressed() {
  if (manager.gameState == 0 && manager.roll.isClicked() != -1) {
    manager.rollButtonClick();
  }

}
