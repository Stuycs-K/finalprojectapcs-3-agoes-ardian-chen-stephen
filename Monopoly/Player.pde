class Player{
  String name;
  int money;
  int currentBoardIndex;
  int x, y;
  color c;
  ArrayList<PropertySpace> ownedProperties;

  Player(String name, int money, color c){
    this.name = name;
    this.money = money;
    this.c = c;
    currentBoardIndex = 0;
    ownedProperties = new ArrayList<PropertySpace>();
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
  
  public void addProperty(PropertySpace property){
    ownedProperties.add(property);
  }
 
  public color getColor(){
    return c;
  }
  
  public String getName(){
    return name;
  }
  
  public int getIndex(){
    return currentBoardIndex;
  }
  
  public int[] getPos(){
    return new int[]{x,y};
  }
  
  public ArrayList<PropertySpace> getProperties(){
    return ownedProperties;
  }
    
  
  public void move (int boardIndex, int newX, int newY){
    this.currentBoardIndex = boardIndex;
    this.x = newX;
    this.y = newY;
  }    
  
}
