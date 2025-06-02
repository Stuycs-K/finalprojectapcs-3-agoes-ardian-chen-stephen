class GameManager{
  Player[] players;
  Player currentPlayer;
  int playerIndex;
  BoardSpace[] board;
  ArrayList<PropertySpace> availableProp;
  Button purchase;
  Button roll;
  Button notEnoughMoney;
  Button eventButton;
  Button bankruptcy;
  Dice dice;
  ArrayList<String> historyLog;
  
  int diceRoll1;
  int diceRoll2;
  int gameState;
  boolean rolledDouble;
  boolean waitingForEvent;

  boolean gameOver;
  
  int moveStepsRemaining;
  int moveDelayCounter;
  final int MOVE_DELAY_FRAMES = 10;
  
  final int STATE_WAITING_TO_ROLL = 0;
  final int STATE_ROLLING = 1;
  final int STATE_MOVING = 2;
  final int STATE_PROCESS_LANDED_SPACE = 3;
  final int STATE_WAITING_PURCHASE_DECISION = 4;
  final int STATE_END_TURN = 5;
  final int STATE_GAME_OVER = 99;
  
  //board layout constant stuff
  
  int numPropEachSide = 3;
  int totalBoardSpaces = (3 * numPropEachSide) + 4;
  float cornerSize = 200.0f;
  float propertyLongSide = 200.0f;
  float propertyShortSide = 80.0f;  
  float boardSideLength = (2 * cornerSize) + (numPropEachSide * propertyLongSide);
  float boardMarginX = (1920.0f - boardSideLength) / 2.0f;
  float boardMarginY = (1080.0f - boardSideLength) / 2.0f;

  
  public GameManager(int numPlayers){
    players = new Player[numPlayers];
    board = makeTestBoard();
    availableProp = makeAvailProperty();
    
    for (int i = 0; i < numPlayers; i++) {
      players[i] = new Player("Player" + (i+1), 400, color(255, 0, 0), board);
    }
    playerIndex = 0;
    
    float uiX = boardMarginX + (2 * cornerSize) + (numPropEachSide * propertyLongSide) + 50;
    float uiY = boardMarginY + 50;
    roll = new Button("roll", uiPanelX, uiPanelY); // Example position for roll button
    purchase = new Button("purchase", width/2.0f - 105, height/2.0f - 75); // Centered pop-up
    notEnoughMoney = new Button("not_enough_money", width/2.0f - 165, height/2.0f - 50);
    eventButton = new Button("go", width/2.0f - 165, height/2.0f - 70); // Default type
    bankruptcy = new Button("bankruptcy", width/2.0f - 115, height/2.0f - 75);
    dice = new Dice();
    
    historyLog = new ArrayList<String>();
    rolledDouble = false;
    waitingForEvent = false;
  }
  
  void update(){
    if (gameOver || waitingForEvent){
      return; 
    }
    
    currentPlayer = players[playerIndex];
    
    if (gameState == STATE_WAITING_TO_ROLL) {
      roll.setVisibility(true);
      purchase.setVisibility(false);
    } 
    else if (gameState == STATE_ROLLING) {
      maintainHistory(currentPlayer.getName() + " rolled a " + diceRoll1 + " and a " + diceRoll2);
      moveStepsRemaining = diceRoll1 + diceRoll2;
      moveDelayCounter = 0;
      gameState = STATE_MOVING;
    } 
    else if (gameState == STATE_MOVING){
      if (moveDelayCounter <= 0){
        boolean passedGo = currentPlayer.moveOneStep();
        if (passedGo){
          maintainHistory(currentPlayer.getName() + " passed go and collected $200");
        }
        moveStepsRemaining--;
        
        moveDelayCounter = MOVE_DELAY_FRAMES;
      }
      else{
        moveDelayCounter--;
      }
      if (moveStepsRemaining == 0){
        gameState = STATE_PROCESS_LANDED_SPACE;
      }
    }
    else if (gameState == STATE_PROCESS_LANDED_SPACE) {
      BoardSpace space = board[currentPlayer.getIndex()];
      maintainHistory(currentPlayer.getName() + " landed on " + space.getName());
      boolean canPurchase = handleLanding(space);
      if (canPurchase) {
        gameState = STATE_WAITING_PURCHASE_DECISION;
        purchase.setVisibility(true);
      }
      else {
        gameState = STATE_END_TURN;
      }
    }
    else if (gameState == STATE_END_TURN) {
      if (rolledDouble){
        rolledDouble = false;
        gameState = STATE_WAITING_TO_ROLL;
      }
      else{
        playerIndex = (playerIndex + 1) % players.length;
        maintainHistory(currentPlayer.getName() + " ended their turn");
        gameState = STATE_WAITING_TO_ROLL;
      }
    }

  }
  
  BoardSpace[] makeTestBoard() {
    //filler code
    return new BoardSpace[] {
      new PropertySpace("Prop1",0, "blue", 0, 10, 50, 50, 100, 100),
      new EventSpace("Event1", 1, "go", 50, 10,  50, 50),
      new PropertySpace("Prop2",2, "blue",100, 10,  50, 50, 100, 100),
      new EventSpace("Event2", 3, "lawyer", 150, 10,  50, 50),
      new PropertySpace("Prop3",4, "blue", 200, 10,  50, 50, 100, 100),
      new PropertySpace("Prop4",5, "blue", 250, 10,  50, 50, 100, 100),
      new EventSpace("Event3", 6, "inherit",300, 10,  50, 50),
      new PropertySpace("Prop5",7, "blue", 350, 10,  50, 50, 100, 100),
      new EventSpace("Event4", 8, "tax", 400, 10,  50, 50),
      new PropertySpace("Prop6",9, "blue", 450, 10,  50, 50, 100, 100),
      new PropertySpace("Prop7",10, "blue", 500, 10,  50, 50, 100, 100),
      new EventSpace("Event5", 11, "irs", 550, 10,  50, 50),
      new PropertySpace("Prop8",12, "blue", 600, 10,  50, 50, 100, 100),
      new EventSpace("Event6", 13, "go", 650, 10,  50, 50),
      new PropertySpace("Prop9",14, "blue", 700, 10,  50, 50, 100, 100),
      new PropertySpace("Prop10",15, "blue", 750, 10,  50, 50, 100, 100),
      new EventSpace("Event7", 16, "irs", 800, 10,  50, 50),
      new PropertySpace("Prop11",17, "blue", 850, 10, 50, 50, 100, 100),
      new EventSpace("Event8", 18, "lawyer", 900, 10, 50, 50),
      new PropertySpace("Prop12",19, "blue", 950, 10,  50, 50, 100, 100),
    };
  }
  
  ArrayList<PropertySpace> makeAvailProperty() {
    ArrayList<PropertySpace> properties = new ArrayList<PropertySpace>();
    for(BoardSpace space : board){
      if (space instanceof PropertySpace){
        properties.add((PropertySpace) space);
      }
    }
    return properties;
  }
  
  void rollButtonClick() {
      dice.roll();
      diceRoll1 = dice.getDice1();
      diceRoll2 = dice.getDice2();
      rolledDouble = dice.isDouble();
      roll.setVisibility(false);
      gameState = STATE_ROLLING; 
  }
  
  void purchaseButtonClick(boolean purchase) {
    if (gameState == STATE_WAITING_PURCHASE_DECISION) {
      if (purchase) {
        buyProperty((PropertySpace) board[currentPlayer.getIndex()]);
      } else {
        maintainHistory(currentPlayer.getName() + " did not buy " + board[currentPlayer.getIndex()].getName());
      }
      gameState = STATE_END_TURN;
    }
  }

  void display() {
    if (roll.isvisible()) {
      roll.displayButton();  
    }
    if (purchase.isvisible()){
      purchase.displayButton();
    }
    if (notEnoughMoney.isvisible()) {
      notEnoughMoney.displayButton();
    }
    if (eventButton.isvisible()) {
      eventButton.displayButton();
    }
    if (bankruptcy.isvisible()){
      bankruptcy.displayButton();
    }
    
    drawHistoryLog();
    drawBoard();
  }
  
  void drawBoard(){
    for (BoardSpace space : board){
      int x = space.getX();
      int y = space.getY();
      
      fill(255);
      rect(x, y, 50, 50);
      
    }
    
    for (int i = 0; i < players.length; i++) {
    Player p = players[i];
    int px = board[p.getIndex()].getX() + 15 + i * 15;
    int py = board[p.getIndex()].getY() + 15;
    fill(p.getColor());
    ellipse(px, py, 12, 12);
  }
  }
  
  boolean handleLanding(BoardSpace space){
    if (space instanceof PropertySpace) {
      PropertySpace prop = (PropertySpace) space;
      if (prop.getOwned()){
         Player propOwner = prop.getOwner();
         int rent = prop.getRent();
         propOwner.changeMoney(rent);
         currentPlayer.changeMoney(-rent);
         maintainHistory(currentPlayer.getName() + " paid $" + rent + " rent to " + propOwner.getName());

         eventButton = new Button("rent " + currentPlayer.getName() + " " + rent + " " + propOwner.getName(), 200, 200);
         eventButton.setVisibility(true);
         waitingForEvent = true;
         
         return false;
      }
      return true;
    }
    else{
      EventSpace event = (EventSpace) space;
      
      int choice = (int) (Math.random() * 2);
      String type = event.getType();
      String eventMessage = ""; 
      if (type.equals("chance")){
        if (choice == 0){
          eventMessage = "go";
          currentPlayer.setPos(0);
          maintainHistory(currentPlayer.getName() + " passed Go and got $200");
        }
        else {
          eventMessage = "irs";
          currentPlayer.changeMoney(50);
          maintainHistory(currentPlayer.getName() + " gained $50");
        }
      }
      else if (type.equals("event")){
        if (choice == 0){
          eventMessage = "lawyer";
          currentPlayer.changeMoney(-50);
          maintainHistory(currentPlayer.getName() + " lost $50");
        }
        else {
          eventMessage = "inherit";
          currentPlayer.changeMoney(100);
          maintainHistory(currentPlayer.getName() + " gained $10");
        }
      }
      else {
        eventMessage = "tax";
        currentPlayer.changeMoney(-100);
        maintainHistory(currentPlayer.getName() + " lost $100");
      }
     
      eventButton = new Button(eventMessage, 200, 200);
      eventButton.setVisibility(true);
      waitingForEvent = true;

      return false;
    }
  }
  
  void eventButtonClick() {
    eventButton.setVisibility(false);
    if (currentPlayer.getMoney() < 0) {
      maintainHistory(currentPlayer.getName() + " has gone bankrupt");
      checkBankruptcy(); 
    } 
    else {
      gameState = STATE_END_TURN;

    }
    waitingForEvent = false;
  }
  
  void buyProperty(PropertySpace space){
    int price = space.getPrice();
    if (currentPlayer.canAfford(price)){
      maintainHistory(currentPlayer.getName() + " purchased " + space.getName());
      currentPlayer.addProperty(space);
      currentPlayer.changeMoney(-price);
      space.setOwner(currentPlayer);
      availableProp.remove(space);
    }
    else{
      notEnoughMoney.setVisibility(true);
    }
  }
  
  void checkBankruptcy(){
    if (!eventButton.isvisible()){
      bankruptcy.setVisibility(true);
    }
    gameOver = true;
    gameState = STATE_GAME_OVER;
  }
  
  void maintainHistory(String entry){
    historyLog.add(entry);
    if (historyLog.size() > 10){
      historyLog.remove(0);
    }
  }
  
  void drawHistoryLog(){
    int x = 700;
    int y = 360;
    int w = 380;
    int h = 290;
    int lineHeight = 23;
    fill(255);
    rect(x, y, w, h);
    
    fill(0);
    textSize(16);
    textAlign(LEFT, TOP);
    text("History Log", x + 10, y + 10);
    
    textSize(14);
    for (int i = 0; i < historyLog.size(); i++) {
      int lineY = y + 10 + 35 + i * lineHeight;  
      if (lineY  < y + h - 10) {     
      text(historyLog.get(i), x + 10, lineY);
    }
  }

  }
  
  
}
