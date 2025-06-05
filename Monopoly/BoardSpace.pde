abstract class BoardSpace {
  private String spaceName;
  private int boardIndex;
  private int x;
  private int y;
  private float widthSize;
  private float heightSize;
  private color c;
  
  public BoardSpace(String name, int boardIndex, int xPos, int yPos, float w, float h, color c){
    this.spaceName = name;
    this.boardIndex = boardIndex;
    this.x = xPos;
    this.y = yPos;
    this.widthSize = w;
    this.heightSize = h;
    this.c = c;
  }
  
  public String getName() {
    return this.spaceName;
  }
  
  public color getColor() {
    return c;
  }
  
  public int getBoardIndex(){
    return this.boardIndex;
  }
  
  public int getX(){
    return this.x;
  }
  
  public int getY(){
    return this.y;
  }
  
  public float getWidth(){
    return this.widthSize;
  }
  
  public float getHeight(){
    return this.heightSize;
  }
    
  public void draw(){
    stroke(0);
    fill(getColor());
    rect(this.x, this.y, this.widthSize, this.heightSize);
  }
}
