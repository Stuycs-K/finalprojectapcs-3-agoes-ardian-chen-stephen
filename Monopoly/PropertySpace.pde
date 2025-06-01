  class PropertySpace extends BoardSpace {
  private int price;
  private int rent;
  private Player owner;
  private String propertyType;
  
  public PropertySpace(String name, int index, String propertyType, int x, int y, float w, float h, int price, int rent) {
    super(name, index, x, y, w, h);
    this.propertyType = propertyType;
    this.price = price;
    this.rent = rent;
    this.owner = null;
  }
  
  public String getName(){
    return super.getName();
  }
  
  public int getPrice(){
     return this.price;
  }
  
  public int getRent(){
     return this.rent;
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
  
  @Override
  public void draw(){
    super.draw();
    fill(255);
    noStroke();
    rect(getX() + 1, getY() + 1, getWidth() - 2, getHeight() - 2);
    stroke(0);
    fill(0);
    textAlign(CENTER, CENTER);
    text(getName(), getX() + getWidth() / 2, getY() + getHeight() * 0.35f); 
    if (!getOwned()) {
      text("$" + this.price, getX() + getWidth() / 2, getY() + getHeight() * 0.85f);
    } 
    else {
      if (owner != null) { 
        fill(owner.c);
        noStroke();
        float indicatorSize = min(getWidth() * 0.2f, getHeight() * 0.1f);
        ellipseMode(CENTER);
        ellipse(getX() + getWidth() / 2, getY() + getHeight() * 0.65f, indicatorSize * 1.5f, indicatorSize * 1.5f);
        stroke(0);
      }
    }
  }
  
  //@Override
  /*public void onLand(Player player, GameManager GM){
      GM.displayMessage(player.getName() + " landed on " + getName());
      if (!getOwned()){
        if (player.canAfford(this.price)) {
          gameManager.offerProperty(this, player);
        }
        else {
          GM.displayMessage(player.getName() + " can't afford this property..."
          GM.endPlayerTurn();
        }
      }
      else if (getOwner() != player) {
          GM.displayMessage(getName() + " is owned by " + getOwner().getName();
          GM.payRent(this, player, getOwner());
      }
      else {
        GM.displayMessage(player.getName() + " landed on their own property";
        GM.endPlayerTurn();
      }
  }*/
  }  
        
