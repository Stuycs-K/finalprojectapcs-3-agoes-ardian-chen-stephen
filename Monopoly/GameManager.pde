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
  private Button showDice;
  private Button bankruptcy;
  private Button endButton;
  private Button liquidate;
  private Button unmortgage;
  private Button unmortgageList;
  private Button showList;
  private Button manageAssets;
  private Dice dice;
  private ArrayList<String> historyLog;

  private int diceRoll1;
  private int diceRoll2;
  private int diceOverride;
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
  public final int CAN_END_TURN = 6;
  public final int STATE_SHOWING_DICE = 7;
  public final int STATE_LIQUIDATE = 8;
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
  boolean sentToJailThisTurn;
  
  BoardSpace jail;

  public GameManager(int numPlayers) {
    players = new Player[numPlayers];
    board = makeTestBoard();
    availableProp = makeAvailProperty();

    for (int i = 0; i < numPlayers; i++) {
      color[] colors = {color(255, 0, 0), color(0, 255, 0)};
      players[i] = new Player("Player " + (i+1), 1000, colors[i], board);
    }
    playerIndex = 0;

    purchase = new Button("purchase", propertySide * 3.5, propertySide * 2.5);
    roll = new Button("roll", propertySide * 4 + boardStartX, (boardSideLength + boardStartY) / 2);
    notEnoughMoney = new Button("not_enough_money", propertySide * 2.5 + boardStartX, propertySide * 2.5);
    eventButton = new Button("go",  propertySide * 3.5, propertySide * 2.5);
    bankruptcy = new Button("bankruptcy",  propertySide * 3.5, propertySide * 2.5);
    endButton = new Button ("end_turn", propertySide * 4 + boardStartX, (boardSideLength + boardStartY) / 2);
    showDice = new Button ("diceImage", propertySide * 3 + boardStartX, (boardSideLength + boardStartY) / 3);
    liquidate = new Button ("liquidate",  propertySide * 2.5 + boardStartX, (boardSideLength + boardStartY) / 3);
    showList = new Button ("showList", propertySide * 4 + boardStartX, (boardSideLength + boardStartY) / 2);
    unmortgage = new Button ("unmortgage", propertySide * 4 + boardStartX, (boardSideLength + boardStartY) / 1.5);
    unmortgageList = new Button("unmortgageList", propertySide * 4 + boardStartX, (boardSideLength + boardStartY) / 2);
    manageAssets = null;
    dice = new Dice();
    diceOverride = 0;

    historyLog = new ArrayList<String>();
    rolledDouble = false;
    waitingForEvent = false;
    
  }

  private void update() {
    if (manageAssets != null && manageAssets.isvisible()) {
        return;
    }
    if (gameOver || waitingForEvent) {
      return;
    }
    currentPlayer = players[playerIndex];
    
    if (currentPlayer.isInJail()) {
      if (gameState == STATE_WAITING_TO_ROLL) {
      if (!purchase.isvisible() &&
        !notEnoughMoney.isvisible() &&
        !eventButton.isvisible() &&
        !bankruptcy.isvisible()) {
      roll.setVisibility(true);
      } else {
      roll.setVisibility(false);
      purchase.setVisibility(false);
    }}
      if (gameState == STATE_ROLLING) {
        if (diceRoll1 == diceRoll2){
          maintainHistory(currentPlayer.getName() + " rolled a double and got out of jail.");
          currentPlayer.releaseJail();
          moveStepsRemaining = diceRoll1 + diceRoll2;
          gameState = STATE_MOVING;
        } 
        else{
          currentPlayer.changeJailTurns();
          if (currentPlayer.getJailTurns() <= 0) {
            maintainHistory(currentPlayer.getName() + " paid $50 to leave jail after 3 failed attempts.");
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
        !bankruptcy.isvisible() &&
        !endButton.isvisible()){
      roll.setVisibility(true);
      } else {
      roll.setVisibility(false);
      purchase.setVisibility(false);
    }} else if (gameState == STATE_ROLLING && !currentPlayer.isInJail()) {
      moveStepsRemaining = diceRoll1 + diceRoll2;
      gameState = STATE_MOVING;
    } 
     else if (gameState == STATE_MOVING && !currentPlayer.isInJail()){
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
        processEndOfMove();
      }
     } 
     else if (gameState == CAN_END_TURN) { 
        roll.setVisibility(false);
        purchase.setVisibility(false);
        notEnoughMoney.setVisibility(false);
        eventButton.setVisibility(false);
        unmortgage.setVisibility(false);
        endButton.setVisibility(true); 
    } 
    else if (gameState == STATE_END_TURN) {
      if (!gameOver){
        checkBankruptcy();
      }
      else {
        return;
      }
      if (rolledDouble && !currentPlayer.isInJail()) {
        rolledDouble = false;

        maintainHistory(currentPlayer.getName() + " rolled a double! Gets another turn.");
        gameState = STATE_WAITING_TO_ROLL;
      } else {
        if (currentPlayer.hasMortgaged()){
          unmortgage = new Button(currentPlayer, "unmortgage", propertySide * 3 + boardStartX, (boardSideLength + boardStartY) / 2);
          unmortgage.setVisibility(true);
        }
        else{
          gameState = CAN_END_TURN;
        }
      }
    }
  }

  private void processEndOfMove() {
    if (rolledDouble && !currentPlayer.isInJail()) {
      rolledDouble = false;
      maintainHistory(currentPlayer.getName() + " rolled a double! Gets another turn.");
      gameState = STATE_WAITING_TO_ROLL;
    } else {
      if (currentPlayer.hasMortgaged()){
        unmortgage = new Button(currentPlayer, "unmortgage", propertySide * 3 + boardStartX, (boardSideLength + boardStartY) / 2);
        unmortgage.setVisibility(true);
      } else {
        gameState = CAN_END_TURN;
      }
    }
  }
  
  public void startAssetManagement() {
    if (purchase.isvisible() || notEnoughMoney.isvisible() || eventButton.isvisible() || liquidate.isvisible() || showList.isvisible()) {
      return;
    }
    manageAssets = new Button(currentPlayer, "showList", propertySide * 1.5, propertySide * 2);
    manageAssets.setVisibility(true);
    roll.setVisibility(false);
    endButton.setVisibility(false);
  }

  public void endAssetManagement() {
    if (manageAssets != null) {
      manageAssets.setVisibility(false);
    }
    if (gameState == STATE_WAITING_TO_ROLL) {
      roll.setVisibility(true);
    } else {
      gameState = CAN_END_TURN;
    }
  }
  
  public void finalizeTurn() {
    if (gameOver) return;
    endButton.setVisibility(false); 
    checkBankruptcy(); 
    if (!gameOver) { 
      checkBankruptcy();
    }
    if (gameOver) {
      return;
    }
    int previousPlayerIndex = playerIndex;
    playerIndex = (playerIndex + 1) % players.length;
    maintainHistory(players[previousPlayerIndex].getName() + " ended their turn.");
    gameState = STATE_WAITING_TO_ROLL;
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
    newBoard[space] = new EventSpace("JAIL", space, "jail", (int)currentX, (int)currentY, cornerSize, cornerSize);
    jail = newBoard[space];
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
    newBoard[space] = new EventSpace("GO JAIL", space, "gojail", (int)currentX, (int)currentY, cornerSize, cornerSize);
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
        newBoard[space] = new EventSpace("TAXED", space, "tax", (int)currentX, (int)currentY, cornerSize, cornerSize);
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
  
  public boolean playerOwnsFullSet(Player player, String colorGroup) {
    if (player == null || colorGroup == null || colorGroup.isEmpty() || board == null) {
      return false;
    }
    int propertiesInThisGroupOwnedByPlayer = 0;
    int totalPropertiesInThisColorGroup = 0;
    for (BoardSpace space : board) {
      if (space instanceof PropertySpace) {
        PropertySpace prop = (PropertySpace) space;
        if (colorGroup.equals(prop.getType())) {
          totalPropertiesInThisColorGroup++;
          if (prop.getOwner() == player) {
            propertiesInThisGroupOwnedByPlayer++;
          }
        }
      }
    }
    if (totalPropertiesInThisColorGroup == 3 && propertiesInThisGroupOwnedByPlayer == 3) {
      return true;
    }
  return false;
  }

  public void overrideDice(int override){
    diceOverride = override;
    rollButtonClick();
  }
  
  public void overrideGoToJail() {
    maintainHistory("Override: " + currentPlayer.getName() + " was sent to jail.");
    currentPlayer.sentToJail(jail.getBoardIndex());
    gameState = STATE_END_TURN; 
    roll.setVisibility(false); 
  }
  public void overrideGiveProperty(int propertyIndex) {
    if (propertyIndex < 0 || propertyIndex >= board.length) {
      maintainHistory("Override Error: Invalid index " + propertyIndex);
      return;
    }
    if (!(board[propertyIndex] instanceof PropertySpace)) {
      maintainHistory("Override Error: Space " + propertyIndex + " is not a property.");
      return;
    }
    PropertySpace prop = (PropertySpace) board[propertyIndex];
    if (prop.getOwner() != null) {
      if (prop.getOwner() == currentPlayer) {
        maintainHistory("Override: You already own " + prop.getName());
        return;
      }
      prop.getOwner().ownedProperties.remove(prop);
    }
    prop.setOwner(currentPlayer);
    currentPlayer.addProperty(prop);
    availableProp.remove(prop);
    maintainHistory("Override: " + prop.getName() + " given to " + currentPlayer.getName());
  }
  
  public void rollButtonClick() {
    if (diceOverride > 0) {
      int totalOverrideSteps = diceOverride;
      diceOverride = 0; 
    if (totalOverrideSteps < 2 || totalOverrideSteps > 12) {
      totalOverrideSteps = 2; 
    }
    diceRoll1 = (int) ceil(totalOverrideSteps / 2.0f);
    if (diceRoll1 > 6) diceRoll1 = 6;
    diceRoll2 = totalOverrideSteps - diceRoll1;
    if (diceRoll2 > 6) { diceRoll2 = 6; diceRoll1 = totalOverrideSteps - diceRoll2; }
    if (diceRoll1 < 1) { diceRoll1 = 1; diceRoll2 = totalOverrideSteps - diceRoll1; }
    showDice.setDice(diceRoll1, diceRoll2);
    maintainHistory("Dice Override: " + totalOverrideSteps + " (as " + diceRoll1 + "," + diceRoll2 + ")");
    }
    else{
      dice.roll();
      diceRoll1 = dice.getDice1();
      diceRoll2 = dice.getDice2();
      showDice.setDice(diceRoll1, diceRoll2);
      rolledDouble = dice.isDouble();
    }
      rolledDouble = (diceRoll1 == diceRoll2);
      roll.setVisibility(false);
      showDice.setVisibility(true);
      maintainHistory(currentPlayer.getName() + " rolled a " + diceRoll1 + " and a " + diceRoll2);
      gameState = STATE_SHOWING_DICE;
  }
  
  public void diceRollClick(){
      roll.setVisibility(false);
      showDice.setVisibility(false);
      gameState = STATE_ROLLING;
  }
  
  public void drawDieFace(int num, float x, float y){
    fill(255);
    rect(x, y, 60, 60);
    fill(0);
    
    float centerX = x + 30;
    float centerY = y + 30;
    
    float[][] dots = new float[][]{
      {centerX, centerY},
      {centerX - 15, centerY - 15, centerX + 15, centerY + 15},
      {centerX - 15, centerY - 15, centerX, centerY, centerX + 15, centerY + 15},
      {centerX - 15, centerY - 15, centerX + 15, centerY - 15, centerX - 15, centerY + 15, centerX + 15, centerY + 15},
      {centerX - 15, centerY - 15, centerX + 15, centerY - 15, centerX, centerY, centerX - 15, centerY + 15, centerX + 15, centerY + 15},
      {centerX - 15, centerY - 15, centerX + 15, centerY - 15, centerX - 15, centerY, centerX + 15, centerY, centerX - 15, centerY + 15, centerX + 15, centerY + 15}
    };
    
    for (int i = 0; i < dots[num - 1].length; i +=2){
        ellipse(dots[num - 1][i], dots[num - 1][i + 1], 5, 5);
    }
  }

  public void purchaseButtonClick(boolean purchase) {
    if (gameState == STATE_WAITING_PURCHASE_DECISION) {
      if (purchase) {
        buyProperty((PropertySpace) board[currentPlayer.getIndex()]);
      } else {
        maintainHistory(currentPlayer.getName() + " did not buy " + board[currentPlayer.getIndex()].getName());
      }
      if (!waitingForEvent) { 
        processEndOfMove();
      }    
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
    if (endButton.isvisible()) {       
      endButton.displayButton();
    }
    if (showDice.isvisible()) {     
      showDice.displayButton();
    }
    if (liquidate.isvisible()){
      liquidate.displayButton();
    }
    if (showList.isvisible()) {     
      showList.displayButton();
    }
    if (unmortgage.isvisible()){
      unmortgage.displayButton();
    }
    if (unmortgageList.isvisible()) {     
      unmortgageList.displayButton();
    }
    if (manageAssets != null && manageAssets.isvisible()) {
        manageAssets.displayButton();
    }
    if (manager.showDice.isvisible()) {
      drawDieFace(diceRoll1, propertySide * 3 + boardStartX + 35, (boardSideLength + boardStartY) / 3 + 80);
      drawDieFace(diceRoll2, propertySide * 3 + boardStartX + 125, (boardSideLength + boardStartY) / 3 + 80);
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
    float boxW = 280; 
    float startH = 110; 
    float propertyLineHeight = 20; 
    int maxPropertiesToShow = 24; 
    
    ArrayList<PropertySpace> props = currentPlayer.getProperties();
    int numPropsToDisplay = min(props.size(), maxPropertiesToShow); 
    float propertiesListHeight = numPropsToDisplay * propertyLineHeight;
    if (props.size() > maxPropertiesToShow) {
      propertiesListHeight += propertyLineHeight; 
    }
    float boxH = startH + propertiesListHeight;
    if (props.isEmpty()){ 
        boxH = startH - 20; 
    }
    float screenMargin = 20;
    float padding = 15;
    int statusTextSize = 18; 
    int propertyTextSize = 14; 
    float generalLineHeight = statusTextSize + 8; 
  
    float boxX = width - boxW - screenMargin;
    float boxY = screenMargin;
  
    fill(230, 230, 250, 220); 
    stroke(50);
    strokeWeight(1);
    rect(boxX, boxY, boxW, boxH, 5); 
  
    fill(0);
    textAlign(LEFT, TOP);
  
    float currentTextY = boxY + padding;
    textSize(statusTextSize);
    String turnText = "Turn: " + currentPlayer.getName();
    text(turnText, boxX + padding, currentTextY);
    currentTextY += generalLineHeight;
  
    String moneyText = "Money: $" + currentPlayer.getMoney();
    text(moneyText, boxX + padding, currentTextY);
    currentTextY += generalLineHeight;
  
    if (!props.isEmpty()) {
      textSize(statusTextSize - 2); 
      text("Properties:", boxX + padding, currentTextY);
      currentTextY += propertyLineHeight; 
      textSize(propertyTextSize);
      for (int i = 0; i < numPropsToDisplay; i++) {
        PropertySpace prop = props.get(i);
        if (prop != null && prop.getMortgagedStatus()){
          text("- " + prop.getName() + " (Mortgaged)", boxX + padding + 10, currentTextY); 
          currentTextY += propertyLineHeight;
        }
        else if (prop != null) {
          text("- " + prop.getName(), boxX + padding + 10, currentTextY); 
          currentTextY += propertyLineHeight;
        }
      }
    } 
    else {
      textSize(propertyTextSize); 
      text("(No properties owned)", boxX + padding, currentTextY);
    }
    fill(currentPlayer.getColor());
    noStroke();
    ellipseMode(CENTER);
    float playerSize = statusTextSize * 2; 
    ellipse(boxX + boxW - 50, boxY + padding * 2, playerSize, playerSize);
    stroke(0);
  }

  private boolean handleLanding(BoardSpace space) {
    if (space instanceof PropertySpace) {
      PropertySpace prop = (PropertySpace) space;
      if (prop.getOwned()) {
        if (prop.getOwner() == currentPlayer) {
        maintainHistory(currentPlayer.getName() + " landed on their own property: " + prop.getName() + ".");
        return false;
        } 
        else {
          if (prop.getMortgagedStatus()){
            maintainHistory("This property has been mortgaged. " +  prop.getOwner().getName() + " gets no rent");
            return false;
          }
          else{
            prop.getOwner().changeMoney(prop.getCurrentRent(this));
            currentPlayer.changeMoney(prop.getCurrentRent(this));
            maintainHistory(currentPlayer.getName() + " paid $" + prop.getCurrentRent(this) + " rent to " + prop.getOwner().getName());
            gameState = STATE_END_TURN;
            checkBankruptcy();
            eventButton = new Button("rent " + currentPlayer.getName() + " " + prop.getCurrentRent(this) + " " + prop.getOwner().getName(), 200, 275);
            eventButton.setVisibility(true);
            waitingForEvent = true;
            return false;
          }
        }
      }
      return true;
    } else {
      EventSpace event = (EventSpace) space;
      int choice = (int) (Math.random() * 2);
      String type = event.getType();
      String eventMessage = "";
      if (type.equals("GO")) {
          return false; 
      }
      else if (type.equals("gojail")){
        currentPlayer.sentToJail(jail.getBoardIndex());
        sentToJailThisTurn = true;
        eventMessage = "gojail";
        diceRoll1 = 0;
        diceRoll2 = 0;
        gameState = STATE_END_TURN;
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
      } else if (type.equals("tax")){
        eventMessage = "tax";
        currentPlayer.changeMoney(-300);
        maintainHistory(currentPlayer.getName() + " lost $100");
      }
      else{
        return false;
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
    } 
    else {
       if (!gameOver) { 
        processEndOfMove();
      }
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
      if (currentPlayer.canLiquidate(currentPlayer.getMoney())){
        liquidate.setVisibility(true);
        gameState = STATE_LIQUIDATE;
      }
      else{
      maintainHistory(currentPlayer.getName() + " has gone bankrupt");
      gameOver = true;
      gameState = STATE_GAME_OVER;
      bankruptcy.setVisibility(true);
      }
    }
  }
  
  public void liquidateButtonClick(){
    liquidate.setVisibility(false);
    showList = new Button(currentPlayer, "showList", propertySide * 1.5, propertySide * 2);
    showList.setVisibility(true);
  }
  
  public void showListClick(){
    if (currentPlayer.getMoney() >= 0){
      showList.setVisibility(false);
      gameState = STATE_END_TURN;
    }
  }
  
  public void unmortgageClick(boolean status){
      gameState = CAN_END_TURN;
      endButton.setVisibility(false);

     if (status){
      unmortgageList = new Button(currentPlayer, "unmortgageList", propertySide * 1.5, propertySide * 2);
      unmortgageList.setVisibility(true);
    }
  }
  
  public void unmortgageListClick(){
    unmortgageList.setVisibility(false);
    endButton.setVisibility(true);
    gameState = CAN_END_TURN;
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
