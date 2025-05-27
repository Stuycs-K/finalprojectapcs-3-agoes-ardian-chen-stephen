class Button{
String type;
float xPos;
float yPos;
float button1X;
float button2X;
float buttonY;
float buttonW;
float buttonH;
  
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
    h = 150;
    
    fill(100, 0, 0);
    rect(xPos, yPos, w, h);
    fill(0);
    textSize(20);
    text("Would you like to", xPos + 5, yPos + 30);
    text("purchase this property?", xPos + 5, yPos + 50);
    
    fill(255);
    button1X = xPos + 10;
    button2X = xPos + 150;
    buttonY = yPos + 80;
    buttonW = 50;
    buttonH = 50;
    rect(button1X, buttonY, buttonW, buttonH);
    rect(button2X, buttonY, buttonW, buttonH);
    fill(0);
    text("Yes", button1X + 5, buttonY + 20);
    text("No", button2X + 5, buttonY + 20);
  }
  else {
    
  }
  
  
}

public boolean isClicked(){
     if (mouseX > button1X && mouseX < button1X + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH){
       return true;
     }
     else if (mouseX > button2X && mouseX < button2X + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH){
       return false;
     }
     
}


}
