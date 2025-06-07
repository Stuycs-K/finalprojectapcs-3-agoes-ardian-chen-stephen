class Player{
  String name;
  int money;
  int currentBoardIndex;
  int x, y;
  color c;
  ArrayList<PropertySpace> ownedProperties;
  BoardSpace[] board;
  
  boolean inJail;
  int jailTurns;

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
    
    inJail = false;
    jailTurns = 0;
  }
  
  public boolean isInJail(){
    return inJail;
  }
  
  public void sentToJail(int jailIndex){
    System.out.println("sending to jail");
    inJail = true;
    jailTurns = 4;
    setPos(jailIndex);
  }
  
  public void changeJailTurns(){
    jailTurns--;
  }
  
  public void releaseJail(){
    inJail = false;
    jailTurns = 0;
  }
  
  public int getJailTurns(){
    return jailTurns;
  }
  
  public int getMoney(){
    return this.money; 
  }
  
  public void changeMoney(int amount){
    this.money += amount;
  }
  
  public boolean canAfford(int amount){
    return money >= amount;
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
    
  public boolean canLiquidate(int debt){
    int sum = 0;
    for (PropertySpace p : ownedProperties){
      if (!p.getMortgagedStatus()){
        sum += p.getPrice();
      }
    }
    
    return sum > debt;
  }
  
  public void mortgageProperty(PropertySpace p) {
  if (ownedProperties.contains(p) && !p.getMortgagedStatus()) {
    p.setMortgaged(true);
    changeMoney(p.getMortgagePrice());
    }
  }
  
  public boolean unmortgageProperty(PropertySpace p) {
  int unmortgageCost = (int)(p.getMortgagePrice() * 1.1); 
  if (ownedProperties.contains(p) && p.getMortgagedStatus() && canAfford(unmortgageCost)) {
    p.setMortgaged(false);
    changeMoney(-unmortgageCost);
    return true;
  }
  return false;
}
  
  public boolean move(int stepsToMove){
    boolean passedGo = false;
    if (currentBoardIndex + stepsToMove >= board.length){
      changeMoney(100);
      passedGo = true;
    }
    this.currentBoardIndex = (currentBoardIndex + stepsToMove) % board.length;
    updatePosition();
    return passedGo;
  }   
  
   public boolean moveOneStep(){
    boolean passedGo = false;
    if (currentBoardIndex + 1 >= board.length){
      changeMoney(100);
      passedGo = true;
    }
    this.currentBoardIndex = (currentBoardIndex + 1) % board.length;
    updatePosition();
    return passedGo;
   }   
  
  public boolean setPos (int index){
    boolean passedGo = false;
    if (currentBoardIndex > index){
       changeMoney(100);
       passedGo = true;
    }
    this.currentBoardIndex = index;
    updatePosition();
    return passedGo;
  }
  
  private void updatePosition(){
    BoardSpace currentSpace = this.board[currentBoardIndex];
    this.x = currentSpace.getX() + (int)(currentSpace.getWidth() / 2);
    this.y = currentSpace.getY() + (int)(currentSpace.getHeight() / 2);
  }
  
  public void draw(){
     fill(this.c);    
     noStroke();     
     ellipseMode(CENTER); 
     float tokenSize = 30;
     stroke(0);
     ellipse(this.x, this.y, tokenSize, tokenSize); 
     noStroke();
     fill(0); 
     textAlign(CENTER, CENTER);
     textSize(tokenSize * 0.5f);
     if (name != null && name.length() > 0) {
       text("P" + name.substring("Player ".length()), this.x, this.y); 
     }
     stroke(0); 
  }
}
