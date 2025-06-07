  class PropertySpace extends BoardSpace {
  private int price;
  private int baseRent;
  private Player owner;
  private String propertyType;
  private boolean isMortgaged;
  private int mortgageValue;
  
  public PropertySpace(String name, int index, String propertyType, int x, int y, float w, float h, int price, int rent, color c) {
    super(name, index, x, y, w, h, c);
    this.propertyType = propertyType;
    this.price = price;
    this.mortgageValue = price/2;
    this.baseRent = rent;
    this.owner = null;
    isMortgaged = true;
  }
  
   public PropertySpace(String name, int index, String propertyType, int x, int y, float w, float h, int price, int rent) {
    this(name, index, propertyType, x, y, w, h, price, rent, color(255));
  }
  
  public String getName(){
    return super.getName();
  }
  
  public int getPrice(){
     return this.price;
  }
  
  public int getBaseRent(){
     return this.baseRent;
  }
  
  public int getCurrentRent(GameManager gameManager) {
    if (owner == null) {
      return 0;
    }
    int currentRentValue = this.baseRent;
    if (gameManager.playerOwnsFullSet(this.owner, this.propertyType)) {
      currentRentValue = (int) (this.baseRent * 1.25f);
    }
    return currentRentValue;
  }
  
  public Player getOwner() {
    return owner;
  }
  
  public boolean getOwned(){
    return (this.owner != null);
  }
  
  public void setOwner(Player newOwner){
    this.owner = newOwner;
  }
  
  public String getType(){
    return this.propertyType;
  }
  
  public void setMortgaged(boolean status){
    isMortgaged = status;
  }
  
  public boolean getMortgagedStatus(){
    return isMortgaged;
  }
  
  public int getMortgagePrice(){
    return mortgageValue;
  }
  
  @Override
  public void draw(){
    super.draw(); 
    fill(getColor());
    noStroke();
    rect(getX() + 1, getY() + 1, getWidth() - 2, getHeight() - 2);
    stroke(0);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(11);
    text(getName(), getX() + getWidth() / 2, getY() + getHeight() * 0.35f - 15f); 
    if (!getOwned()) {
      text("$" + this.price, getX() + getWidth() / 2, getY() + getHeight() * 0.85f + 5f);
    } 
    else {
      if (owner != null) { 
        fill(owner.c);
        stroke(0);
        float indicatorSize = min(getWidth() * 0.2f, getHeight() * 0.1f);
        ellipseMode(CENTER);
        ellipse(getX() + getWidth() / 2, getY() + getHeight() * 0.65f + 20f, indicatorSize * 1.5f, indicatorSize * 1.5f);
        stroke(0);
      }
    }
  }
}  
        
