class Player{
  String name;
  int money;
  int currentBoardIndex;
  int x, y;
  color c;
  ArrayList<PropertySpace> ownedProperties;
  BoardSpace[] board;

  Player(String name, int money, color c, BoardSpace[] board){
    this.name = name;
    this.money = money;
    this.c = c;
    currentBoardIndex = 0;
    ownedProperties = new ArrayList<PropertySpace>();
    this.board = board;
    BoardSpace currentSpace = board[currentBoardIndex];
    this.x = currentSpace.getX() + (int)(currentSpace.getWidth() / 2.0f);
    this.y = currentSpace.getY() + (int)(currentSpace.getHeight() / 2.0f);
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
    
  public boolean move(int stepsToMove){
    boolean passedGo = false;
    if (currentBoardIndex + stepsToMove >= board.length){
      changeMoney(50);
      passedGo = true;
    }
    this.currentBoardIndex = (currentBoardIndex + stepsToMove) % board.length;
    BoardSpace currentSpace = board[currentBoardIndex];
    this.x = board[currentBoardIndex].getX() + (int)(currentSpace.getWidth() / 2.0f);
    this.y = board[currentBoardIndex].getY() + (int)(currentSpace.getHeight() / 2.0f);
    return passedGo;
  }   
  
  public boolean setPos (int index){
    boolean passedGo = false;
    if (currentBoardIndex > index){
       changeMoney(200);
       passedGo = true;
    }
    this.currentBoardIndex = index;
    updatePosition();
    return passedGo;
  }
  
  public void updatePosition(){
    BoardSpace currentSpace = this.board[currentBoardIndex];
    this.x = currentSpace.getX() + (int)(currentSpace.getWidth() / 2);
    this.y = currentSpace.getY() + (int)(currentSpace.getHeight() / 2);
  }
  
  public void draw(){
    fill(this.c);    
    noStroke();     
    ellipseMode(CENTER); 
    float tokenSize = 30;
    ellipse(this.x, this.y, tokenSize, tokenSize); 
     fill(0); 
     textAlign(CENTER, CENTER);
     textSize(tokenSize * 0.5f);
     if (name != null && name.length() > 0) {
       text("P" + name.substring("Player ".length()), this.x, this.y); 
     }
     stroke(0); 
  }
}
