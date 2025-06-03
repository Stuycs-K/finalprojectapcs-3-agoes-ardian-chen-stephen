class GameManager {
  private Player[] players;
  private Player currentPlayer;
  private int playerIndex;
  private BoardSpace[] board;
  private ArrayList<PropertySpace> availableProp;
  private Button purchase;
  private Button roll;
  private Button notEnoughMoney;
  private Button eventButton;
  private Button bankruptcy;
  private Dice dice;
  private ArrayList<String> historyLog;

  private int diceRoll1;
  private int diceRoll2;
  private int gameState;
  private boolean rolledDouble;
  private boolean waitingForEvent;
  private boolean gameOver;

  public final int STATE_WAITING_TO_ROLL = 0;
  public final int STATE_ROLLING = 1;
  public final int STATE_MOVING = 2;
  public final int STATE_PROCESS_LANDED_SPACE = 3;
  public final int STATE_WAITING_PURCHASE_DECISION = 4;
  public final int STATE_END_TURN = 5;
  public final int STATE_GAME_OVER = 99;

  private int numPropEachSide = 7;
  private int totalBoardSpaces = (4 * numPropEachSide) + 4;
  private float cornerSize = 95.0f;
  private float propertySide = 95.0f;
  private float boardSideLength = (2 * cornerSize) + (numPropEachSide * propertySide);
  private float boardStartX = 10.0f;
  private float boardStartY = 10.0f;
  
  private int moveDelayCounter;
  private int moveStepsRemaining;
  public final int MOVE_DELAY_FRAMES = 10;
  
  BoardSpace jail;

  public GameManager(int numPlayers) {
    players = new Player[numPlayers];
    board = makeTestBoard();
    availableProp = makeAvailProperty();

    for (int i = 0; i < numPlayers; i++) {
      color[] colors = {color(255, 0, 0), color(0, 255, 0)};
      players[i] = new Player("Player " + (i+1), 500, colors[i], board);
    }
    playerIndex = 0;

    purchase = new Button("purchase", propertySide * 3.5, propertySide * 2.5);
    roll = new Button("roll", propertySide * 4 + boardStartX, (boardSideLength + boardStartY) / 2);
    notEnoughMoney = new Button("not_enough_money", propertySide * 2.5 + boardStartX, propertySide * 2.5);
    eventButton = new Button("go",  propertySide * 3.5, propertySide * 2.5);
    bankruptcy = new Button("bankruptcy",  propertySide * 3.5, propertySide * 2.5);
    dice = new Dice();

    historyLog = new ArrayList<String>();
    rolledDouble = false;
    waitingForEvent = false;
    
  }

  private void update() {
    if (gameOver || waitingForEvent) {
      return;
    }
    currentPlayer = players[playerIndex];
    if (currentPlayer.inJail()){
      if (!purchase.isvisible() &&
        !notEnoughMoney.isvisible() &&
        !eventButton.isvisible() &&
        !bankruptcy.isvisible()) {
        roll.setVisibility(true);
      }
      else if (gameState == STATE_ROLLING){
        maintainHistory(currentPlayer.getName() + "is attempting to leave jail");
        
        if(diceRoll1 == diceRoll2){
          maintainHistory(currentPlayer.getName() + " rolled a double and is released from jail!");
          currentPlayer.releaseJail();
          gameState = STATE_MOVING;
          moveStepsRemaining = diceRoll1 + diceRoll2;
        }
        else {
          currentPlayer.changeJailTurns();
          if (currentPlayer.getJailTurns() <= 0) {
            maintainHistory(currentPlayer.getName() + " paid $50 to leave jail after 3 failed attempts");
            currentPlayer.changeMoney(-50);
            currentPlayer.releaseJail();
            gameState = STATE_MOVING;
            moveStepsRemaining = diceRoll1 + diceRoll2;
          } else {
            maintainHistory(currentPlayer.getName() + " failed to roll a double. Turn skipped.");
            gameState = STATE_END_TURN;
          }
      }
    }
    }
    if (gameState == STATE_WAITING_TO_ROLL) {
      if (!purchase.isvisible() &&
        !notEnoughMoney.isvisible() &&
        !eventButton.isvisible() &&
        !bankruptcy.isvisible()) {
      roll.setVisibility(true);
      } else {
      roll.setVisibility(false);
      purchase.setVisibility(false);
    }} else if (gameState == STATE_ROLLING) {
      maintainHistory(currentPlayer.getName() + " rolled a " + diceRoll1 + " and a " + diceRoll2);
      moveStepsRemaining = diceRoll1 + diceRoll2;
      gameState = STATE_MOVING;
    } 
     else if (gameState == STATE_MOVING){
      if (moveDelayCounter <= 0){
        boolean passedGo = currentPlayer.moveOneStep();
        if (passedGo){
          maintainHistory(currentPlayer.getName() + " passed go and collected $100");
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
      } else {
        gameState = STATE_END_TURN;
      }
    } else if (gameState == STATE_END_TURN) {
      if (!gameOver){
        checkBankruptcy();
      }
      else {
        return;
      }
      if (rolledDouble) {
        rolledDouble = false;
        gameState = STATE_WAITING_TO_ROLL;
      } else {
        playerIndex = (playerIndex + 1) % players.length;
        maintainHistory(currentPlayer.getName() + " ended their turn");
        gameState = STATE_WAITING_TO_ROLL;
      }
    }
  }

  private BoardSpace[] makeTestBoard() {
    BoardSpace[] newBoard = new BoardSpace[totalBoardSpaces];
    int space = 0;
    float currentX, currentY;
    currentX = 10.0f;
    currentY = 10.0f;
    newBoard[space] = new EventSpace("GO", space, "GO", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentY = boardStartY;
    for (int i = 0; i < numPropEachSide; i++) {
      String[] propertySet1 = {"HTML Heaven", "CSS Corner", "JavaScript Junction"}; 
      currentX = boardStartX + cornerSize + i * propertySide;
      if (i <= 2){
        newBoard[space] = new PropertySpace(propertySet1[i], space, "green", (int)currentX, (int)currentY, propertySide, propertySide, 30 + i * 10, 2 + i * 2, color(119, 235, 115));
        space++;
      }
      else if (i >= 4){
         String[] propertySet2 = {"Array Avenue", "List Lanes", "Tree Terrace"}; 
         newBoard[space] = new PropertySpace(propertySet2[i-4], space, "cyan", (int)currentX, (int)currentY, propertySide, propertySide, 100 + (i-4) * 10, 10 + (i-4) * 2, color(110, 245, 227));
         space++;
      }
      else {
        newBoard[space] = new EventSpace("CHANCE", space, "chance", (int)currentX, (int)currentY, cornerSize, cornerSize);
        space++;
      }
    }
    currentX = boardStartX + cornerSize + (numPropEachSide * propertySide);
    currentY = boardStartY;
    newBoard[space] = new EventSpace("CHANCE", space, "chance", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentX = boardStartX + cornerSize + (numPropEachSide * propertySide) + (cornerSize - propertySide);
    for (int i = 0; i < numPropEachSide; i++) {
      currentY = boardStartY + cornerSize + i * propertySide;
      if (i <= 2){
        String[] propertySet1 = {"Bubble Boulevard", "Selection Street", "Insertion Place"};
        newBoard[space] = new PropertySpace(propertySet1[i], space, "pink", (int)currentX, (int)currentY, propertySide, propertySide, 140 + i * 10, 18 + i * 1, color(227, 104, 170));
        space++;
      }
      else if (i >= 4){
         String[] propertySet2 = {"Python Plaza", "C+ City", "Java Rails"}; 
         newBoard[space] = new PropertySpace(propertySet2[i-4], space, "red", (int)currentX, (int)currentY, propertySide, propertySide, 180 + (i-4) * 10, 22 + (i-4) * 1, color(240, 72, 72));
         space++;
      }
      else {
        newBoard[space] = new EventSpace("CHEST", space, "event", (int)currentX, (int)currentY, cornerSize, cornerSize);
        space++;
      }
    }
    currentX = boardStartX + cornerSize + (numPropEachSide * propertySide);
    currentY = boardStartY + cornerSize + (numPropEachSide * propertySide);
    newBoard[space] = new EventSpace("CHEST", space, "event", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentY = boardStartY + cornerSize + (numPropEachSide * propertySide) + (cornerSize - propertySide);
    for (int i = 0; i < numPropEachSide; i++) {
      currentX = boardStartX + cornerSize + (numPropEachSide - 1 - i) * propertySide;
      if (i <= 2){
        String[] propertySet1 = {"Merge Markets", "Heap Heights", "Quick Quarters"};
        newBoard[space] = new PropertySpace(propertySet1[i], space, "orange", (int)currentX, (int)currentY, propertySide, propertySide, 220 + i * 10, 26 + i, color(227, 132, 64));
        space++;
      }
      else if (i >= 4){
         String[] propertySet2 = {"Integer Parks", "Bool Bakery", "Float Ferrys"}; 
         newBoard[space] = new PropertySpace(propertySet2[i-4], space, "yellow", (int)currentX, (int)currentY, propertySide, propertySide, 250 + (i-4) * 10, 30 + (i-4), color(227, 237, 78));
         space++;
      }
      else {
        newBoard[space] = new EventSpace("CHANCE", space, "chance", (int)currentX, (int)currentY, cornerSize, cornerSize);
        space++;
      }
    }
    currentX = boardStartX;
    currentY = boardStartY + cornerSize + (numPropEachSide * propertySide);
    newBoard[space] = new EventSpace("TAXED", space, "tax", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentX = boardStartX;
    for (int i = 0; i < numPropEachSide; i++) {
      currentY = boardStartY + cornerSize + (numPropEachSide - 1 - i) * propertySide;
      if (i <= 2){
        String[] propertySet1 = {"Instance Isles", "Classy Commons", "Object Overlooks"};
        newBoard[space] = new PropertySpace(propertySet1[i], space, "vomit", (int)currentX, (int)currentY, propertySide, propertySide, 300 + i * 10, 34 + i, color(206, 214, 131));
        space++;
      }
      else if (i >= 4){
         String[] propertySet2 = {"While Ways", "For Fairway", "Iterate Walks"}; 
         newBoard[space] = new PropertySpace(propertySet2[i-4], space, "gray", (int)currentX, (int)currentY, propertySide, propertySide, 350 + (i-4) * 10, 37 + (i-4), color(156, 153, 152));
         space++;
      }
      else {
        newBoard[space] = new EventSpace("CHEST", space, "event", (int)currentX, (int)currentY, cornerSize, cornerSize);
        space++;
      }
    }
    return newBoard;
  }

  private ArrayList<PropertySpace> makeAvailProperty() {
    ArrayList<PropertySpace> properties = new ArrayList<PropertySpace>();
    for (BoardSpace space : board) {
      if (space instanceof PropertySpace) {
        properties.add((PropertySpace) space);
      }
    }
    return properties;
  }

  public void rollButtonClick() {
    dice.roll();
    diceRoll1 = dice.getDice1();
    diceRoll2 = dice.getDice2();
    rolledDouble = dice.isDouble();
    roll.setVisibility(false);
    gameState = STATE_ROLLING;
  }

  public void purchaseButtonClick(boolean purchase) {
    if (gameState == STATE_WAITING_PURCHASE_DECISION) {
      if (purchase) {
        buyProperty((PropertySpace) board[currentPlayer.getIndex()]);
      } else {
        maintainHistory(currentPlayer.getName() + " did not buy " + board[currentPlayer.getIndex()].getName());
      }
      gameState = STATE_END_TURN;
    }
  }

  public void display() {
    if (roll.isvisible()) {
      roll.displayButton();
    }
    if (purchase.isvisible()) {
      purchase.displayButton();
    }
    if (notEnoughMoney.isvisible()) {
      notEnoughMoney.displayButton();
    }
    if (eventButton.isvisible()) {
      eventButton.displayButton();
    }
    if (bankruptcy.isvisible()) {
      bankruptcy.displayButton();
    }
    drawHistoryLog();
    drawBoard();
    playerStatus();
    if (players != null) {
      for (Player p : players) {
        if (p != null) {
          p.draw();
        }
      }
    }
  }

  private void drawBoard() {
    if (board != null) {
      for (BoardSpace space : board) {
        if (space != null) {
          space.draw();
        }
      }
    }
  }

  private void playerStatus() {
    fill(230, 230, 250, 220);
    stroke(50);
    strokeWeight(1);
    rect(width-300, 20, 250, 250, 5);
    fill(0);
    textSize(25);
    textAlign(LEFT, TOP);

    fill(currentPlayer.getColor());
    String turnText = "Turn: " + currentPlayer.getName();
    text(turnText, width-290, 40);

    fill(0);
    String moneyText1 = players[0].getName() + " Money: $" + players[0].getMoney();
    text(moneyText1, width-290, 80);
    
    String moneyText2 = players[1].getName() +" Money: $" + players[1].getMoney();
    text(moneyText2, width-290, 120);

    fill(currentPlayer.getColor());
    noStroke();
    ellipseMode(CENTER); 
    ellipse(width - 175, 200, 30, 30);
    stroke(0);
  }

  private boolean handleLanding(BoardSpace space) {
    if (space instanceof PropertySpace) {
      PropertySpace prop = (PropertySpace) space;
      if (prop.getOwned()) {
        if (prop.getOwner() == currentPlayer) {
        maintainHistory(currentPlayer.getName() + " landed on their own property: " + prop.getName() + ".");
        return false;
      } else {
        prop.getOwner().changeMoney(prop.getRent());
        currentPlayer.changeMoney(-prop.getRent());
        maintainHistory(currentPlayer.getName() + " paid $" + prop.getRent() + " rent to " + prop.getOwner().getName());
        
        eventButton = new Button("rent " + currentPlayer.getName() + " " + prop.getRent() + " " + prop.getOwner().getName(), 200, 275);
        eventButton.setVisibility(true);
        waitingForEvent = true;
        return false;
      }
      }
      return true;
    } else {
      EventSpace event = (EventSpace) space;

      int choice = (int) (Math.random() * 2);
      String type = event.getType();
      String eventMessage = "";
      if (type.equals("GO")) {
          maintainHistory(currentPlayer.getName() + " passed Go and got $100");
          gameState = STATE_END_TURN;
          return false; 
      }
      else if (type.equals("JAIL")){
        currentPlayer.sentToJail(jail.getBoardIndex());
        eventMessage = "jail";
        maintainHistory(currentPlayer.getName() + "got caught for fraud and is in jail");
      }
      else if (type.equals("chance")) {
        if (choice == 0) {
          eventMessage = "go";
          currentPlayer.setPos(0);
          maintainHistory(currentPlayer.getName() + " passed Go and got $100");
        } else {
          eventMessage = "irs";
          currentPlayer.changeMoney(50);
          maintainHistory(currentPlayer.getName() + " gained $50");
        }
      } else if (type.equals("event")) {
        if (choice == 0) {
          eventMessage = "lawyer";
          currentPlayer.changeMoney(-50);
          maintainHistory(currentPlayer.getName() + " lost $50");
        } else {
          eventMessage = "inherit";
          currentPlayer.changeMoney(100);
          maintainHistory(currentPlayer.getName() + " gained $100");
        }
      } else {
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
  

  public void eventButtonClick() {
    eventButton.setVisibility(false);
    if (currentPlayer.getMoney() < 0) {
      checkBankruptcy();
    } else {
      gameState = STATE_END_TURN;
    }
    waitingForEvent = false;
  }

  private void buyProperty(PropertySpace space) {
    int price = space.getPrice();
    if (currentPlayer.canAfford(price)) {
      maintainHistory(currentPlayer.getName() + " purchased " + space.getName());
      currentPlayer.addProperty(space);
      currentPlayer.changeMoney(-price);
      space.setOwner(currentPlayer);
      availableProp.remove(space);
    } else {
      maintainHistory(currentPlayer.getName() + " cannot afford " + space.getName() + ".");
      notEnoughMoney.setVisibility(true); 
      roll.setVisibility(false);        
      purchase.setVisibility(false);    
      waitingForEvent = true;      
    }
  }

  private void checkBankruptcy() {
    if (currentPlayer.getMoney() < 0) {
      maintainHistory(currentPlayer.getName() + " has gone bankrupt");
      gameOver = true;
      gameState = STATE_GAME_OVER;
      bankruptcy.setVisibility(true); 
    }
  }

  private void maintainHistory(String entry) {
    historyLog.add(entry);
    if (historyLog.size() > 10) {
      historyLog.remove(0);
    }
  }

  private void drawHistoryLog() {
    int w = 380;
    int h = 290;
    int x = width - w - 10;
    int y = height - h - 10;
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
