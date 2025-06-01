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
  String message;
  int diceRoll;
  
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
  
  public GameManager(int numPlayers){
    players = new Player[numPlayers];
    board = makeTestBoard();
    availableProp = makeAvailProperty();
    
    for (int i = 0; i < numPlayers; i++) {
      players[i] = new Player("Player " + (i+1), 50, color(255, 0, 0), board);
    }
    playerIndex = 0;
    
    //todo: figure out position of buttons
    purchase = new Button("purchase", 100, 100);
    roll = new Button("roll", 100, 100);
    notEnoughMoney = new Button("not_enough_money", 100, 100);
    eventButton = new Button("go", 100, 100);
    bankruptcy = new Button("bankruptcy", 100, 100);
    dice = new Dice();
    
    message = "";
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
      message = currentPlayer.getName() + " rolled a " + diceRoll;
      currentPlayer.move(diceRoll);
      gameState = STATE_PROCESS_LANDED_SPACE;
    } 
    else if (gameState == STATE_PROCESS_LANDED_SPACE) {
      BoardSpace space = board[currentPlayer.getIndex()];
      System.out.println(currentPlayer.getName() + " " + currentPlayer.getIndex() + " $" + currentPlayer.getMoney());
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
        System.out.println("Double");
        rolledDouble = false;
        gameState = STATE_WAITING_TO_ROLL;
      }
      else{
        message = currentPlayer.getName() + "'s turn ended";
        playerIndex = (playerIndex + 1) % players.length;
        System.out.println("end");
        diceRoll = -1;
        gameState = STATE_WAITING_TO_ROLL;
      }
    }

  }
  
  BoardSpace[] makeTestBoard() {
    return new BoardSpace[] {
      new PropertySpace("Prop1",0, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event1", 1, "go", 10, 10, 10, 10),
      new PropertySpace("Prop2",2, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event2", 3, "lawyer", 10, 10, 10, 10),
      new PropertySpace("Prop3",4, "blue", 10, 10, 10, 10, 100, 100),
      new PropertySpace("Prop4",5, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event3", 6, "inherit", 10, 10, 10, 10),
      new PropertySpace("Prop5",7, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event4", 8, "tax", 10, 10, 10, 10),
      new PropertySpace("Prop6",9, "blue", 10, 10, 10, 10, 100, 100),
      new PropertySpace("Prop7",10, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event5", 11, "irs", 10, 10, 10, 10),
      new PropertySpace("Prop8",12, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event6", 13, "go", 10, 10, 10, 10),
      new PropertySpace("Prop9",14, "blue", 10, 10, 10, 10, 100, 100),
      new PropertySpace("Prop10",15, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event7", 16, "irs", 10, 10, 10, 10),
      new PropertySpace("Prop11",17, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event8", 18, "lawyer", 10, 10, 10, 10),
      new PropertySpace("Prop12",19, "blue", 10, 10, 10, 10, 100, 100),
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
      diceRoll = dice.roll();
      rolledDouble = dice.isDouble();
      roll.setVisibility(false);
      gameState = STATE_ROLLING; 
  }
  
  void purchaseButtonClick(boolean purchase) {
    if (gameState == STATE_WAITING_PURCHASE_DECISION) {
      if (purchase) {
        buyProperty((PropertySpace) board[currentPlayer.getIndex()]);
        System.out.println("purchased");
      } else {
        System.out.println("not purchased");
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
  }
  
  void drawBoard(){
  
  }
  
  boolean handleLanding(BoardSpace space){
    if (space instanceof PropertySpace) {
      PropertySpace prop = (PropertySpace) space;
      if (prop.getOwned()){
         prop.getOwner().changeMoney(prop.getRent());
         currentPlayer.changeMoney(-prop.getRent());
         checkBankruptcy();
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
        }
        else {
          eventMessage = "irs";
          currentPlayer.changeMoney(50);
        }
      }
      else if (type.equals("event")){
        if (choice == 0){
          eventMessage = "lawyer";
          currentPlayer.changeMoney(-50);
        }
        else {
          eventMessage = "inherit";
          currentPlayer.changeMoney(100);
        }
      }
      else {
        eventMessage = "tax";
        currentPlayer.changeMoney(-100);
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
    if (currentPlayer.getMoney() < 0){
      if (!eventButton.isvisible()){
        bankruptcy.setVisibility(true);
      }
      gameOver = true;
      gameState = STATE_GAME_OVER;
    }
  }
  
}
