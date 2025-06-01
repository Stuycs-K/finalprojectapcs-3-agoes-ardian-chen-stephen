GameManager manager;

void setup(){
  size(1000, 650);
  manager = new GameManager(2);
}

void draw() {
  background(255);
  
  manager.update();    
  manager.display();   
}

void mousePressed() {
  if (manager.gameState == manager.STATE_WAITING_TO_ROLL && manager.roll.isClicked() != -1) {
    manager.rollButtonClick();
  }
  if (manager.gameState == manager.STATE_WAITING_PURCHASE_DECISION && manager.purchase.isClicked() == 1) {
    manager.purchaseButtonClick(true);
  }
  if (manager.gameState == manager.STATE_WAITING_PURCHASE_DECISION && manager.purchase.isClicked() == 0){
    manager.purchaseButtonClick(false);
  }
  if (manager.notEnoughMoney.isvisible()) {
    manager.notEnoughMoney.isClicked();
  }

  if (manager.eventButton.isvisible() && manager.eventButton.isClicked() != -1){
    manager.eventButtonClick();
  }
  if (manager.gameState == manager.STATE_GAME_OVER && manager.bankruptcy.isClicked() == 1){
    manager = new GameManager(2);
    background(255);
  }
  if (manager.gameState == manager.STATE_GAME_OVER && manager.bankruptcy.isClicked() == 0){
    exit();

  }

}
