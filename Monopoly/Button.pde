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
  
Button(String type, float xPos, float yPos){
  this.type = type;
  this.xPos = xPos;
  this.yPos = yPos;
  visible = false;
}

public void displayButton(){
  System.out.println("hi");
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
    textAlign(LEFT, BASELINE);
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
   else if (type.equals("not_enough_money")) {
      w = 330;
      h = 100;

      fill(180);
      rect(xPos, yPos, w, h);
      fill(0);
      textSize(16);
      textAlign(LEFT, BASELINE);
      text("You don't have enough money for this property", xPos + 10, yPos + 30);

      fill(255);
      button1X = xPos + w / 2 - 40;
      buttonY = yPos + 50;
      buttonW = 80;
      buttonH = 30;
      rect(button1X, buttonY, buttonW, buttonH);
      fill(0);
      textAlign(CENTER, CENTER);
      text("Okay", button1X + buttonW / 2, buttonY + buttonH / 2);
    }
    else{
      System.out.println("hi");
      String message = "";
      String eventType = "";
      if (type.equals("go")){
        message = "Move to GO and collect $200";
        eventType = "Chance Card";
      }
      else if (type.equals("bank")){ 
        message = "The IRS gives you a refund for $50";
        eventType = "Chance Card";
      }
      else if (type.equals("lawyer")){ 
        message = "Pay $50 to your divorce lawyer. :(";
        eventType = "Community Card";
      }
      else if (type.equals("inherit")){ 
        message = "You inherit $100 from a distant relative";
        eventType = "Community Card";
      }
      else{ 
        message = "Pay $150 in income tax to the state";
        eventType = "Tax";
      }
      
      w = 330;
      h = 140;
      
      if (eventType.equals("Chance Card")){
        fill(255, 200, 100);
      }
      else if (eventType.equals("Community Card")){
        fill(173, 216, 230);
      }
      else{
        fill(100);
      }
      
      rect(xPos, yPos, w, h);
      
      fill(0);
      textSize(18);
      textAlign(CENTER, TOP);
      text(eventType, xPos + w / 2, yPos + 20);

      textSize(16);
      textAlign(CENTER, BASELINE);
      text(message, xPos + w / 2, yPos + 70);

      fill(255);
      button1X = xPos + w / 2 - 40;
      buttonY = yPos + 90;
      buttonW = 80;
      buttonH = 30;
      rect(button1X, buttonY, buttonW, buttonH);
      fill(0);
      textAlign(CENTER, CENTER);
      text("Okay", button1X + buttonW / 2, buttonY + buttonH / 2);
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
      System.out.println("clicked left");
      visible = false;
      return 1;
    } 
    else if (mouseX > button2X && mouseX < button2X + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH) {
      System.out.println("clicked right");
      visible = false;
      return 0;
    }
    return -1;
  }
  else if (type.equals("roll")) {
    if (mouseX > button1X && mouseX < button1X + buttonW &&
       mouseY > buttonY && mouseY < buttonY + buttonH) {
        visible = false;
        return 1;
      }
    return -1; 
  }
  else if (type.equals("not_enough_money")){
    if (mouseX > button1X && mouseX < button1X + buttonW &&
       mouseY > buttonY && mouseY < buttonY + buttonH) {
        visible = false;
        return 1;
      }
   }
       return -1; 
  }
}
