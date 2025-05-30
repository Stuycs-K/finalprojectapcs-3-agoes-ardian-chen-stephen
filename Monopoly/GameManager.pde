class GameManager{
  Player[] players;
  int playerIndex;
  //BoardSpace[] board;
  //BoardSpace[] availableProp;
  Button purchase;
  Button roll;
  String message;
  
  public GameManager(int numPlayers){
    players = new Player[numPlayers];
    playerIndex = 0;
    
    //todo: figure out position of buttons
    purchase = new Button("purchase", 0, 0);
    roll = new Button("roll", 0, 0);

    message = "";
  }
  
  void update(){
    while (!checkBankruptcy(players[playerIndex])){
      roll.visibilityTrue();
      int action = -1;
      while (roll.isVisible() && roll.isClicked() != -1){
        action = roll.isClicked();
      }
      
      
    }
  }
  
  void displayUI(){
   
    //message box
    rect(400, 400, 400, 400);
    
  }
  
  void drawBoard(){
  
  }
  
  boolean processLandedSpace(EventSpace space){
    return true;
  }
  
  void buyProperty(BoardSpace space){
  
  }
  
  boolean checkBankruptcy(Player player){
    return true;
  }

}
