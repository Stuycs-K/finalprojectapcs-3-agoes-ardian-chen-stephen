private GameManager manager;
boolean override;
String overrideS;
boolean getProperty; 
boolean changeMoney;

Button button;

void setup(){
  size(1600, 900);
  manager = new GameManager(2);
  override = false;
  overrideS = "";
  getProperty = false;
  changeMoney = false;
}

void draw() {
  background(255);
  String modeText;
  if (override){
    if (getProperty) {
      modeText = "Give Property: ";
    } else if (changeMoney) {
      modeText = "Money Change: ";
    }
    else {
      modeText = "Dice Override: ";
    }
    
    text(modeText + overrideS, 1000, 100);
  }
  manager.update();    
  manager.display();   
}

void keyPressed(){
  if (key == 'g' && (manager.roll.isvisible() || manager.endButton.isvisible())) {
      override = true;
      getProperty = true; 
      changeMoney = false;
      overrideS = "";
      return; 
  }
  
  if (key == 'c' && (manager.roll.isvisible() || manager.endButton.isvisible())) {
      override = true;
      getProperty = false; 
      changeMoney = true; 
      overrideS = "";
      return; 
  }
  
  if (override){
    if (key == ENTER && !overrideS.isEmpty()){
      int val = Integer.parseInt(overrideS);
      if (getProperty) {
        manager.overrideGiveProperty(val);
      } else if (changeMoney){
        manager.overrideSetMoney(val);
      }
      else { 
        if (val > 0 && val <= 12){
          manager.overrideDice(val);
        }
      }
      override = false;
      overrideS = "";
      getProperty = false;
      changeMoney = false;
    }
    else{
      if (Character.isDigit(key)){
        overrideS += key;
      }
    }
  }
  if(key == 'o' && manager.roll.isvisible()){
    override = true;
    changeMoney = false;
    getProperty = false; 
  }
  
  if(key == 'j' && manager.roll.isvisible()){
    manager.overrideGoToJail();
  }
  
  if (key == 'm') {
    if (manager.manageAssets != null && manager.manageAssets.isvisible()) {
      manager.endAssetManagement();
    } 
    else if (manager.roll.isvisible() || manager.endButton.isvisible()) {
      manager.startAssetManagement();
    }
  }
}

void mousePressed() {
  if (manager.manageAssets != null && manager.manageAssets.isvisible()) {
    int choice = manager.manageAssets.isClicked();
    if (choice == 1) {
      manager.maintainHistory(manager.currentPlayer.getName() + " mortgaged a property.");
    } else if (choice == 0) { 
      manager.maintainHistory(manager.currentPlayer.getName() + " sold a property.");
    }
    return; 
  }
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
  if (manager.gameState == manager.STATE_SHOWING_DICE && manager.showDice.isvisible()) {
    int choice = manager.showDice.isClicked(); 
    if (choice == 1) { 
      manager.diceRollClick(); 
      return;
    }
    if (choice != -1) return; 
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
  if (manager.gameState == manager.STATE_WAITING_PURCHASE_DECISION && manager.purchase.isvisible()) {
    int choice = manager.purchase.isClicked();
    if (choice == 1) { 
      manager.purchaseButtonClick(true);
    } else if (choice == 0) { 
      manager.purchaseButtonClick(false);
    }
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
  if (manager.liquidate.isvisible() && manager.liquidate.isClicked() != -1){
    manager.liquidateButtonClick();
  }
  if (manager.showList.isvisible()){
    int choice = manager.showList.isClicked();
    if (choice == 1){
      manager.maintainHistory(manager.currentPlayer.getName() + " mortgaged a property");
      manager.showListClick();
    }
    else if (choice == 0){
      manager.maintainHistory(manager.currentPlayer.getName() + " sold a property");
      manager.showListClick();
    }
  }
  if (manager.unmortgage.isvisible()){
    int choice = manager.unmortgage.isClicked();
    if (choice == 1) {
      manager.unmortgageClick(true);
    } else if (choice == 0) { 
      manager.unmortgageClick(false);
    }
  }
  if (manager.unmortgage.isvisible() && manager.unmortgage.isClicked() == 1){
    manager.unmortgageClick(true);
  }
  if (manager.unmortgage.isvisible() && manager.unmortgage.isClicked() == 0){
    manager.unmortgageClick(false);
  }
  if (manager.unmortgageList.isvisible()){
    int choice = manager.unmortgageList.isClicked();
    if (choice == 1){
      manager.maintainHistory(manager.currentPlayer.getName() + " bought back a property");
    }
    else if (choice == 0){
      manager.unmortgageListClick();
    }
  }
}
