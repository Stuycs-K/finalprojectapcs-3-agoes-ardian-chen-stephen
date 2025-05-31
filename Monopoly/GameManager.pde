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
    for (int i = 0; i < numPlayers; i++) {
      players[i] = new Player("Player " + (i+1), 1500, color(255, 0, 0));
    }
    playerIndex = 0;
    
    //todo: figure out position of buttons
    purchase = new Button("purchase", 0, 0);
    roll = new Button("roll", 0, 0);
    dice = new Dice();
    
    message = "";
  }
  
  void update(){
    currentPlayer = players[playerIndex];
    
     if (gameState == STATE_WAITING_TO_ROLL) {
      roll.setVisibility(true);
      roll.displayButton();
      purchase.setVisibility(false);
    } 
    
  }
    void rollButtonClick() {
    if (gameState == STATE_WAITING_TO_ROLL) {
      diceRoll = dice.roll();
      roll.setVisibility(false);
          println("Roll clicked, hiding button");

      gameState = STATE_ROLLING;
    }
  }

  
 void display() {
  if (roll.isvisible()) {
    roll.displayButton();  
  }
  }
  
  void drawBoard(){
  
  }
  
  boolean processLandedSpace(EventSpace space){
    return true;
  }
  
  void buyProperty(BoardSpace space){
  
  }
  
}
