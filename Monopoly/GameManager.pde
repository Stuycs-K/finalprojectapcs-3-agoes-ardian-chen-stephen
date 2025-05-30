class GameManager{
  Player[] players;
  int playerIndex;
  //BoardSpace[] board;
  //BoardSpace[] availableProp;
  Button purchase;
  Button roll;
  String message;
  
  public GameManager(int numPlayers){
    players = new Player[]{new Player("BOB", 1900, color(0))};
    playerIndex = 0;
    
    //todo: figure out position of buttons
    purchase = new Button("purchase", 0, 0);
    roll = new Button("roll", 0, 0);

    message = "";
  }
  
  void update(){
    while (!checkBankruptcy()){
      Player currentPlayer = players[playerIndex];
      
      roll.setVisibility(true);
      roll.displayButton();
      int numSpaces = -1;
      while (roll.isVisible() && numSpaces != -1){
        
        numSpaces = roll.isClicked();
      }
      roll.setVisibility(false);
      System.out.println(numSpaces);
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
  
  boolean checkBankruptcy(){
    return false;
  }

}
