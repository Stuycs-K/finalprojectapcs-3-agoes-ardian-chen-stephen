class Player{
  String name;
  int money;
  int currentBoardIndex;
  int x, y;
  color c;
  ArrayList<BoardSpace> ownedProperties;
  BoardSpace[] board;

  Player(String name, int money, color c, BoardSpace[] board){
    this.name = name;
    this.money = money;
    this.c = c;
    currentBoardIndex = 0;
    ownedProperties = new ArrayList<BoardSpace>();
    this.board = board;
    this.x = board[currentBoardIndex].getX();
    this.y = board[currentBoardIndex].getY();
  }
  
  public int getMoney(){
    return this.money; 
  }
  
  public void changeMoney(int amount){
    this.money += amount;
  }
  
  public boolean canAfford(int amount){
    return money > amount;
  }
  
  public void addProperty(BoardSpace property){
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
  
  public ArrayList<BoardSpace> getProperties(){
    return ownedProperties;
  }
    
  
  public boolean move (int moves){
    boolean passedGo = false;
    if (currentBoardIndex + moves >= board.length){
      changeMoney(200);
      passedGo = true;
    }
    this.currentBoardIndex = (currentBoardIndex + moves) % board.length;
    this.x = board[currentBoardIndex].getX();
    this.y = board[currentBoardIndex].getY();
    return passedGo;
  }   
  
  public boolean setPos (int index){
    boolean passedGo = false;
    if (currentBoardIndex > index){
       changeMoney(200);
       passedGo = true;
    }
    this.currentBoardIndex = index;
    this.x = board[currentBoardIndex].getX();
    this.y = board[currentBoardIndex].getY();
    return passedGo;
  }
  
}
