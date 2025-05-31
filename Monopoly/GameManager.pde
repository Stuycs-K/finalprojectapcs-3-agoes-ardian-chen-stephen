class GameManager{
  Player[] players;
  Player currentPlayer;
  int playerIndex;
  BoardSpace[] board;
  BoardSpace[] availableProp;
  Button purchase;
  Button roll;
  Dice dice;
  String message;
  int diceRoll;
  
  int gameState;
  
  final int STATE_WAITING_TO_ROLL = 0;
  final int STATE_ROLLING = 1;
  final int STATE_MOVING = 2;
  final int STATE_PROCESS_LANDED_SPACE = 3;
  final int STATE_WAITING_PURCHASE_DECISION = 4;
  final int STATE_END_TURN = 5;
  
  public GameManager(int numPlayers){
    players = new Player[numPlayers];
    board = makeTestBoard();

    for (int i = 0; i < numPlayers; i++) {
      players[i] = new Player("Player " + (i+1), 1500, color(255, 0, 0), board);
    }
    playerIndex = 0;
    
    //todo: figure out position of buttons
    purchase = new Button("purchase", 100, 100);
    roll = new Button("roll", 100, 100);
    dice = new Dice();
    
    message = "";
  }
  
  void update(){
    currentPlayer = players[playerIndex];
    
     if (gameState == STATE_WAITING_TO_ROLL) {
      roll.setVisibility(true);
      purchase.setVisibility(false);
    } 
    else if (gameState == STATE_ROLLING) {
      message = currentPlayer.getName() + " rolled a " + diceRoll;
      //currentPlayer.move(diceRoll);
      gameState = STATE_PROCESS_LANDED_SPACE;
    } 
    else if (gameState == STATE_PROCESS_LANDED_SPACE) {
      //BoardSpace space = board[currentPlayer.getIndex()];
      BoardSpace space = board[2];

      boolean canPurchase = spaceCanPurchase(space);
      if (canPurchase) {
        gameState = STATE_WAITING_PURCHASE_DECISION;
        purchase.setVisibility(true);
    } 
   }

  }
  
  BoardSpace[] makeTestBoard() {
    return new BoardSpace[] {
      new PropertySpace("Prop1",0, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event1", 1, "blue", 10, 10, 10, 10),
      new PropertySpace("Prop2",2, "blue", 10, 10, 10, 10, 100, 100),
      new EventSpace("Event2", 1, "blue", 10, 10, 10, 10),
      new PropertySpace("Prop3",3, "blue", 10, 10, 10, 10, 100, 100)
  };
  }
  
  void rollButtonClick() {
      diceRoll = dice.roll();
      roll.setVisibility(false);
      gameState = STATE_ROLLING;
    
  }
  
  void purchaseButtonClick(boolean purchase) {
    if (gameState == STATE_WAITING_PURCHASE_DECISION) {
      if (purchase) {
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
  }
  
  void drawBoard(){
  
  }
  
  boolean spaceCanPurchase(BoardSpace space){
    if (space instanceof PropertySpace) {
      return true;
    }
    return false;
  }
  
  void buyProperty(BoardSpace space){
  
  }
  
}
