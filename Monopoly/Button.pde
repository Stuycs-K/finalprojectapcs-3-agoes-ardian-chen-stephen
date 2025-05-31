class Button{
String type;
float xPos;
float yPos;
float button1X;
float button2X;
float buttonY;
float buttonW;
float buttonH;
boolean visible;
Dice dice;
  
Button(String type, float xPos, float yPos){
  this.type = type;
  this.xPos = xPos;
  this.yPos = yPos;
  visible = false;
  dice = new Dice();
}

public void displayButton(){
  if (!visible) return; 

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
  else if (type.equals("roll")) {
    button1X = xPos;
    buttonY = yPos;
    buttonW = 100;
    buttonH = 50;

    fill(0, 150, 255);
    rect(button1X, buttonY, buttonW, buttonH);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Roll Dice", button1X + buttonW/2, buttonY + buttonH/2);
  }
  
}

public void setVisibility(boolean status){
  visible = status;
}

public boolean isvisible(){
  return visible;
}

public int isClicked() {
  if (type.equals("purchase")){
    if (mouseX > button1X && mouseX < button1X + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH) {
      visible = false;
      return 1;
    } 
    else if (mouseX > button2X && mouseX < button2X + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH) {
      visible = false;
      return 0;
    }
    return -1;
  }
  else if (type.equals("roll")) {
      if (mouseX > button1X && mouseX < button1X + buttonW &&
          mouseY > buttonY && mouseY < buttonY + buttonH) {
        visible = false;
        return dice.roll(); 
      }
    }
    return -1; 
  }
}
