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
  int dice1;
  int dice2;
  Player player;
      
  Button(String type, float xPos, float yPos){
    this.type = type;
    this.xPos = xPos;
    this.yPos = yPos;
    visible = false;
  }
  
  Button(Player player, float xPos, float yPos){
    this.player = player;
    this.type = "showList";
    this.xPos = xPos;
    this.yPos = yPos;
    visible = false;
  }
  
  public void setDice(int dice1, int dice2){
    this.dice1 = dice1;
    this.dice2 = dice2;
  }

  public void displayButton(){
    if (!visible) return; 
    int w = 0;
    int h = 0;
   
    if (type.equals("purchase")){
      w = 220; 
      h = 80;
      
      fill(240, 10, 0);
      rect(xPos, yPos, w, h);
      fill(0);
      textSize(20);
      text("Would you like to", xPos + 110, yPos + 30);
      text("purchase this property?", xPos + 110, yPos + 50);
      fill(255);
      button1X = xPos;
      button2X = xPos + 170;
      buttonY = yPos + 90;
      buttonW = 50;
      buttonH = 50;
      textAlign(LEFT, BASELINE);
      rect(button1X, buttonY, buttonW, buttonH);
      rect(button2X, buttonY, buttonW, buttonH);
      fill(0);
      text("Yes", button1X + 5, buttonY + 20);
      text("No", button2X + 5, buttonY + 20);
    }
    else if (type.equals("diceImage")){
      w = 220; 
      h = 210;
      
      fill(40, 60, 40);
      rect(xPos, yPos, w, h);
      fill(0);
      textSize(16);
      text("Dice Roll", xPos + 115, yPos + 30);
      text("You Rolled a " + dice1 + " and " + dice2, xPos + 110, yPos + 60);

      //rect(xPos + 35, yPos + 80, 60, 60);
      //rect(xPos + 125, yPos + 80, 60, 60);

      fill(255);
      button1X = xPos + w / 2 - 40;
      buttonY = yPos + 160;
      buttonW = 80;
      buttonH = 30;
      rect(button1X, buttonY, buttonW, buttonH);
      fill(0);
      textAlign(CENTER, CENTER);
      text("Okay", button1X + buttonW / 2, buttonY + buttonH / 2);
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
    
    else if (type.equals("end_turn")) {
      button1X = xPos;
      buttonY = yPos;
      buttonW = 100;
      buttonH = 50;

      fill(0, 200, 10);
      rect(button1X, buttonY, buttonW, buttonH);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(16);
      text("End Turn", button1X + buttonW/2, buttonY + buttonH/2);
    }
   else if (type.equals("showList")){
     int rowHeight = 50;
     int buttonW = 80;
     int buttonH = 30;
     int padding = 10;
     int index = 0;

     fill(139, 0, 0);
     //rect(xPos, yPos, 600, 50 + currentPlayer.getProperties().size() * rowHeight);
   }
   else if (type.equals("not_enough_money")) {
      w = 330;
      h = 100;

      fill(180);
      rect(xPos, yPos, w, h);
      fill(0);
      textSize(14);
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
    
    else if (type.equals("bankruptcy")){
      w = 300; 
      h = 150;
      
      fill(139, 0, 0);
      rect(xPos, yPos, w, h);
      fill(0);
      textSize(20);
      text("Game Over", xPos + 150, yPos + 30);
      text("Do you want to play again?", xPos + 150, yPos + 50);
      
      fill(255);
      button1X = xPos + 30;
      button2X = xPos + 210;
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
    else{
      String message = "";
      String eventType = "";
      if (type.equals("go")){
        message = "Move to GO and collect $100";
        eventType = "Chance Card";
      }
      else if (type.equals("irs")){ 
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
      else if (type.length() > 4 && type.substring(0,4).equals("rent")){
        String[] parts = type.split(" ");
        for(String s: parts){
          System.out.println(s);
        }
        message = parts[1] + " " + parts[2] + " payed $" + parts[3] + " to " + parts[4] + " " + parts[5];
        eventType = "Pay Rent";
      }
      else if (type.equals("gojail")){
        message = "Caught for fraud and sent in jail";
        eventType = "Jail";
      }
      else if (type.equals("tax")){ 
        message = "Pay $100 in income tax to the state";
        eventType = "Tax";
      }
      else if (type.equals("liquidate")){ 
        message = "You went bankrupt. Mortgage or sell to continue";
        eventType = "Broke";
      }
      else{
        return;
      }
      
      w = 330;
      h = 140;
      
      if (eventType.equals("Chance Card")){
        fill(255, 200, 100);
      }
      else if (eventType.equals("Community Card")){
        fill(173, 216, 230);
      }
      else if (eventType.equals("Pay Rent")){
        fill(255, 102, 102);
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
      if (type.equals("purchase") || type.equals("bankruptcy")){
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
    else {
      if (mouseX > button1X && mouseX < button1X + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH) {
          visible = false;
          return 1;
      }
        return -1; 
    }
  }
}
