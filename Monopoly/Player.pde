class Player{
  String name;
  int money;
  int currentBoardIndex;
  int x, y;
  color c;
  ArrayList<BoardSpace> ownedProperties;

  Player(String name, int money, color c){
    this.name = name;
    this.money = money;
    this.c = c;
    currentBoardIndex = 0;
    ownedProperties = new ArrayList<BoardSpace>();
  }
  
  public int getMoney(){
    return this.money; 
  }
  
  public void addMoney(int amount){
    this.money += amount;
  }
  
  public boolean canAfford(int amount){
    return money > amount;
  }
  
  public void addProperty(BoardSpace property){
    ownedProperties.add(property);
  }
 
  public void move (int boardIndex, int newX, int newY){
    this.currentBoardIndex = boardIndex;
    this.x = newX;
    this.y = newY;
  }    
  
}
