class PropertySpace extends BoardSpace {
  private int price;
  private int rent;
  //private Player owner;
  private boolean isOwned;
  private String propertyType;
  
  public Property(String name, int index, String propertyType, float x, float y, float w, float h, int price, int rent) {
    super(name, index, x, y, w, h);
    this.propertyType = propertyType;
    this.price = price;
    this.rent = rent;
    this.isOwned = false;
    //this.Player = null;
  }
  
  public int getPrice(){
     return price;
  }
  
  public int getRent(){
     return rent;
  }
  
  /*public Player getOwner() {
    return owner;
  }*/
  
  public boolean getOwned(){
    return isOwned;
  }
  
  /*public void setOwner(Player owner){
    this.owner = owner;
    this.isOwned = true;
  }*/
  
  public String getType(){
    return propertyType;
  }
  
  /*public void onLand(Player player, GameManager GM){
      GM.displayMessage(player.getName() + " landed on " + getName());
      if (!isOwned){
        
      }
  }*/
  
}
