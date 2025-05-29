class EventSpace extends BoardSpace {
  private String eventType;
  
  public BoardSpace(String name, int boardIndex, float xPos, float yPos, float w, float h, String event){
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
  *.
  
}
