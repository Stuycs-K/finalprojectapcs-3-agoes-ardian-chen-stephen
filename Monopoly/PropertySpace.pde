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
        
        
