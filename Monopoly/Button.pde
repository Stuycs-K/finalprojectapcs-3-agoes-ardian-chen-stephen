class Button{
String type;
float xPos;
float yPos;

  
Button(String type, float xPos, float yPos){
  this.type = type;
  this.xPos = xPos;
  this.yPos = yPos;
}

public void displayButton(){
  int w = 0;
  int h = 0;
  
  if (type.equals("purchase")){
    w = 210; 
    h = 200;
    fill(100, 0 , 0);
    rect(xPos, yPos, w, h);
  
    fill(0);
    textSize(20);
    text("Would you like to", xPos + 5, yPos + 30);
    text("purchase this property?", xPos + 5, yPos + 50);
  }
  else {
    w = 200; 
    h = 400;
  }
  
  
}

public boolean isClicked(){
  if (type.equals("purchase")){
    return mouseX == 100 && mouseY == 100; //figure out actual spacing 
  }
  else{
    return mouseX == 100 && mouseY == 100; //figure out actual spacing 
  }
}


}
