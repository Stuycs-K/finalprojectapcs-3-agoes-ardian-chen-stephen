class BoardSpace {
  private String propertyName;
  private String type;
  private int price;
  private int rent;
  //private Player owner;
  private boolean isOwned;
  private float x;
  private float y;
  private float widthSize;
  private float heightSize;
  
  public BoardSpace(String name, String type, int price, int rent, float xPos, float yPos, float w, float h){
    this.propertyName = name;
    this.type = type;
    this.isOwned = false;
    this.price = price;
    this.type = type;
    //this.owner = null;
    this.x = xPos;
    this.y = yPos;
    this.widthSize = w;
    this.heightSize = h;
  }
}
