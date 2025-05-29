class GameManager{
  Player[] players;
  int playerIndex;
  BoardSpace[] board;
  BoardSpace[] availableProp;
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
  
  }
  
  void displayUI(){
  
  }
  
  void drawBoard(){
  
  }
  
  boolean processLandedSpace(EventSpace space){
  
  }
  
  void buyProperty(BoardSpace space){
  
  }
  
  boolean checkBankruptcy(){
  
  }

}
