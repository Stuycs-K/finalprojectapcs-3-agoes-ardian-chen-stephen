private GameManager manager;

void setup(){
  size(1600, 900);
  manager = new GameManager(2);
}

void draw() {
  background(255);
  manager.update();    
  manager.display();   
}

void mousePressed() {
  if (manager.waitingForEvent) {
    if (manager.notEnoughMoney.isvisible()) {
      int choice = manager.notEnoughMoney.isClicked();
      if (choice == 1) { 
        manager.waitingForEvent = false;       
        manager.gameState = manager.STATE_END_TURN; 
        return;                                 
      }
      if (choice != -1) return; 
      return; 
    } else if (manager.eventButton.isvisible()) {
      int choice = manager.eventButton.isClicked();
      if (choice == 1) { 
        manager.eventButtonClick(); 
        return;
      }
      if (choice != -1) return;
    }
    return;
  }
  if (manager.gameState == manager.STATE_GAME_OVER && manager.bankruptcy.isClicked() == 1){
    manager = new GameManager(2);
    background(255);
  }
  if (manager.gameState == manager.STATE_GAME_OVER && manager.bankruptcy.isClicked() == 0){
    exit();
  }
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
}
