class GameManager {
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

  final int STATE_WAITING_TO_ROLL = 0;
  final int STATE_ROLLING = 1;
  final int STATE_MOVING = 2;
  final int STATE_PROCESS_LANDED_SPACE = 3;
  final int STATE_WAITING_PURCHASE_DECISION = 4;
  final int STATE_END_TURN = 5;
  final int STATE_GAME_OVER = 99;

  int numPropEachSide = 3;
  int totalBoardSpaces = (4 * numPropEachSide) + 4;
  float cornerSize = 100.0f;
  float propertyLongSide = 100.0f;
  float propertyShortSide = 100.0f;
  float boardSideLength = (2 * cornerSize) + (numPropEachSide * propertyLongSide);
  float boardStartX = 100.0f;
  float boardStartY = 100.0f;

  public GameManager(int numPlayers) {
    players = new Player[numPlayers];
    board = makeTestBoard();
    availableProp = makeAvailProperty();

    for (int i = 0; i < numPlayers; i++) {
      color[] colors = {color(255, 0, 0), color(0, 255, 0)};
      players[i] = new Player("Player " + (i+1), 500, colors[i], board);
    }
    playerIndex = 0;

    purchase = new Button("purchase", (boardSideLength + boardStartX) / 2 - 60, (boardSideLength + boardStartY) / 2);
    roll = new Button("roll", (boardSideLength + boardStartX) / 2, (boardSideLength + boardStartY) / 2);
    notEnoughMoney = new Button("not_enough_money", width - 300, 100);
    eventButton = new Button("go", width - 300, 100);
    bankruptcy = new Button("bankruptcy", width - 300, 100);
    dice = new Dice();

    historyLog = new ArrayList<String>();
    rolledDouble = false;
    waitingForEvent = false;
  }

  void update() {
    if (gameOver || waitingForEvent) {
      return;
    }
    currentPlayer = players[playerIndex];
    if (gameState == STATE_WAITING_TO_ROLL) {
      roll.setVisibility(true);
      purchase.setVisibility(false);
    } else if (gameState == STATE_ROLLING) {
      maintainHistory(currentPlayer.getName() + " rolled a " + diceRoll1 + " and a " + diceRoll2);
      boolean passedGo = currentPlayer.move(diceRoll1 + diceRoll2);
      if (passedGo) {
        maintainHistory(currentPlayer.getName() + " passed Go and got $200");
      }
      gameState = STATE_PROCESS_LANDED_SPACE;
    } else if (gameState == STATE_PROCESS_LANDED_SPACE) {
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

  BoardSpace[] makeTestBoard() {
    BoardSpace[] newBoard = new BoardSpace[totalBoardSpaces];
    int space = 0;
    float currentX, currentY;
    currentX = 100.0f;
    currentY = 100.0f;
    newBoard[space] = new EventSpace("GO", space, "GO", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentY = boardStartY;
    for (int i = 0; i < numPropEachSide; i++) {
      currentX = boardStartX + cornerSize + i * propertyLongSide;
      newBoard[space] = new PropertySpace("PropertyT " + (i + 1), space, "Blue", (int)currentX, (int)currentY, propertyLongSide, propertyShortSide, 140 + i * 20, 10 + i * 2);
      space++;
    }
    currentX = boardStartX + cornerSize + (numPropEachSide * propertyLongSide);
    currentY = boardStartY;
    newBoard[space] = new EventSpace("CHANCE", space, "chance", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentX = boardStartX + cornerSize + (numPropEachSide * propertyLongSide) + (cornerSize - propertyShortSide);
    for (int i = 0; i < numPropEachSide; i++) {
      currentY = boardStartY + cornerSize + i * propertyLongSide;
      newBoard[space] = new PropertySpace("PropertyR " + (i + 1), space, "Orange", (int)currentX, (int)currentY, propertyShortSide, propertyLongSide, 180 + i * 20, 14 + i * 2);
      space++;
    }
    currentX = boardStartX + cornerSize + (numPropEachSide * propertyLongSide);
    currentY = boardStartY + cornerSize + (numPropEachSide * propertyLongSide);
    newBoard[space] = new EventSpace("EVENT", space, "event", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentY = boardStartY + cornerSize + (numPropEachSide * propertyLongSide) + (cornerSize - propertyShortSide);
    for (int i = 0; i < numPropEachSide; i++) {
      currentX = boardStartX + cornerSize + (numPropEachSide - 1 - i) * propertyLongSide;
      newBoard[space] = new PropertySpace("PropertyB " + (i + 1), space, "Brown", (int)currentX, (int)currentY, propertyLongSide, propertyShortSide, 60 + i * 20, 4 + i * 2);
      space++;
    }
    currentX = boardStartX;
    currentY = boardStartY + cornerSize + (numPropEachSide * propertyLongSide);
    newBoard[space] = new EventSpace("GET TAXED", space, "tax", (int)currentX, (int)currentY, cornerSize, cornerSize);
    space++;
    currentX = boardStartX;
    for (int i = 0; i < numPropEachSide; i++) {
      currentY = boardStartY + cornerSize + (numPropEachSide - 1 - i) * propertyLongSide;
      newBoard[space] = new PropertySpace("PropertyL " + (i + 1), space, "LightBlue", (int)currentX, (int)currentY, propertyShortSide, propertyLongSide, 100 + i * 20, 6 + i * 2);
      space++;
    }
    return newBoard;
  }

  ArrayList<PropertySpace> makeAvailProperty() {
    ArrayList<PropertySpace> properties = new ArrayList<PropertySpace>();
    for (BoardSpace space : board) {
      if (space instanceof PropertySpace) {
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

  void drawBoard() {
    if (board != null) {
      for (BoardSpace space : board) {
        if (space != null) {
          space.draw();
        }
      }
    }
  }

  void playerStatus() {
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
    ellipseMode(CENTER); // More common to center the swatch
    ellipse(width - 175, 200, 30, 30);
    stroke(0);
  }

  boolean handleLanding(BoardSpace space) {
    if (space instanceof PropertySpace) {
      PropertySpace prop = (PropertySpace) space;
      if (prop.getOwned()) {
        prop.getOwner().changeMoney(prop.getRent());
        currentPlayer.changeMoney(-prop.getRent());
        maintainHistory(currentPlayer.getName() + " paid $" + prop.getRent() + " rent to " + prop.getOwner().getName());
        checkBankruptcy();
        return false;
      }
      return true;
    } else {
      EventSpace event = (EventSpace) space;

      int choice = (int) (Math.random() * 2);
      String type = event.getType();
      String eventMessage = "";
      if (type.equals("GO")) {
          maintainHistory(currentPlayer.getName() + " passed Go and got $200");
      }
      else if (type.equals("chance")) {
        if (choice == 0) {
          eventMessage = "go";
          currentPlayer.setPos(0);
          maintainHistory(currentPlayer.getName() + " passed Go and got $200");
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
          maintainHistory(currentPlayer.getName() + " gained $10");
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

  void eventButtonClick() {
    eventButton.setVisibility(false);
    if (currentPlayer.getMoney() < 0) {
      maintainHistory(currentPlayer.getName() + " has gone bankrupt");
      checkBankruptcy();
    } else {
      gameState = STATE_END_TURN;
    }
    waitingForEvent = false;
  }

  void buyProperty(PropertySpace space) {
    int price = space.getPrice();
    if (currentPlayer.canAfford(price)) {
      maintainHistory(currentPlayer.getName() + " purchased " + space.getName());
      currentPlayer.addProperty(space);
      currentPlayer.changeMoney(-price);
      space.setOwner(currentPlayer);
      availableProp.remove(space);
    } else {
      notEnoughMoney.setVisibility(true);
    }
  }

  void checkBankruptcy() {
    if (currentPlayer.getMoney() < 0) {
    maintainHistory(currentPlayer.getName() + " has gone bankrupt!");
    gameOver = true;
    gameState = STATE_GAME_OVER;
    bankruptcy.setVisibility(true); 
    }
  }

  void maintainHistory(String entry) {
    historyLog.add(entry);
    if (historyLog.size() > 10) {
      historyLog.remove(0);
    }
  }

  void drawHistoryLog() {
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
