abstract class BoardSpace {
  private String spaceName;
  private int boardIndex;
  private float x;
  private float y;
  private float widthSize;
  private float heightSize;
  
  public BoardSpace(String name, int boardIndex, float xPos, float yPos, float w, float h){
    this.spaceName = name;
    this.boardIndex = boardIndex;
    this.x = xPos;
    this.y = yPos;
    this.widthSize = w;
    this.heightSize = h;
  }
  
  public String getName() {
    return this.spaceName;
  }
  
  public int getBoardIndex(){
    return this.boardIndex;
  }
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y;
  }
  
  public float getWidth(){
    return this.widthSize;
  }
  
  public float getHeight(){
    return this.heightSize;
  }
  
  //public abstract void onLand(Player player, GameManager gameManager);
  
  
}
