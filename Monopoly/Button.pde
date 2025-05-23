class Button{
String type;
float xPos;
float yPos;
float w;
float h;
  
Button(String type, float xPos, float yPos, float w, float h){
  this.type = type;
  this.xPos = xPos;
  this.yPos = yPos;
  this.w = w;
  this.h = h;
}

public void displayButton(){
  String message;
  
  if (type.equals("purchase")){
    message = "Would you like to purchase this property?";
  }
  else {
    message = "Would you like to roll the dice?";
  }
  
  rect(xPos, yPos, w, h);
  fill(100);
  text(message, xPos, yPos);
}

}
