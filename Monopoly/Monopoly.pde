private GameManager manager;
boolean override;
String overrideS;

void setup(){
  size(1280, 720);
  manager = new GameManager(2);
  override = false;
  overrideS = "";
}

void draw() {
  background(255);
  if (override){
    text("Override: " + override, 750, 100);
  }
  
  manager.update();    
  manager.display();   
}

void keyPressed(){
  if (override){
    if (key == ENTER){
      int val = Integer.parseInt(overrideS);
      if (val > 0){
        manager.overrideDice(val);
      }
      override = false;
      overrideS = "";
    }
    else{
      if (Character.isDigit(key)){
        overrideS += key;
      }
    }
  }
  if(key == 'o' && manager.roll.isvisible()){
    override = true;
  }
}

void mousePressed() {
  if (manager.waitingForEvent) {
  if (manager.notEnoughMoney.isvisible()) {
    int choice = manager.notEnoughMoney.isClicked();
    if (choice == 1) { 
      manager.waitingForEvent = false;
      if (manager.rolledDouble) { 
        manager.rolledDouble = false; 
        manager.maintainHistory(manager.currentPlayer.getName() + " rolled a double! Gets another turn.");
        manager.gameState = manager.STATE_WAITING_TO_ROLL;
      } else {
        manager.gameState = manager.CAN_END_TURN;
      }
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
  if (manager.gameState == manager.CAN_END_TURN && manager.endButton.isvisible()) {
    int choice = manager.endButton.isClicked();
    if (choice == 1) { 
      manager.finalizeTurn(); 
      return; 
    }
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
  if (manager.showDice.isvisible() && manager.showDice.isClicked() != -1){
    manager.diceRollClick();
  }
}
