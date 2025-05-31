GameManager manager;
Button button;

void setup(){
  size(1000, 1000);
  manager = new GameManager(2);
  button = new Button("go", 200, 200);
  button.setVisibility(true);
  button.displayButton();
}

void draw() {
  //background(255);
  
  //manager.update();    
  //manager.display();   
}

void mousePressed() {
  //if (manager.gameState == manager.STATE_WAITING_TO_ROLL && manager.roll.isClicked() != -1) {
  //  manager.rollButtonClick();
  //}
  //if (manager.gameState == manager.STATE_WAITING_PURCHASE_DECISION && manager.purchase.isClicked() == 1) {
  //  manager.purchaseButtonClick(true);
  //}
  //else if (manager.gameState == manager.STATE_WAITING_PURCHASE_DECISION && manager.purchase.isClicked() == 0){
  //  manager.purchaseButtonClick(false);
  //}
  
  //if (manager.notEnoughMoney.isvisible()) {
  //  manager.notEnoughMoney.isClicked();
  //}

}
