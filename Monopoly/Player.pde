class Player{
  String name;
  int money;
  int currentBoardIndex;
  color c;
  ArrayList<BoardSpace> ownedProperties;
  
  Player(String name, int money, color c){
    this.name = name;
    this.money = money;
    this.c = c;
    currentBoardIndex = 0;
    ownedProperties = new ArrayList<BoardSpace>();
  }
  
  
}
