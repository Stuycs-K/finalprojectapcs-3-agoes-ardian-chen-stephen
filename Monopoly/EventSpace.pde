class EventSpace extends BoardSpace {
  private String eventType;
  
  public EventSpace(String name, int boardIndex,String event,  int xPos, int yPos, float w, float h){
    super(name, boardIndex, xPos, yPos, w, h);
    this.eventType = event;
  }
  
  public String getType(){
    return this.eventType;
  }
  
  //@Override
  /*
  public onLand(Player player, GameManager GM) {
    if (this.eventType.equals("GO")){
      GM.displayMessage(player.getName() + " passed GO! Collect $200!");
      GM.endPlayerTurn;
    }
  }
  */
  
}
