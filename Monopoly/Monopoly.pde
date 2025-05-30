PropertySpace test;
PropertySpace test2;
Player player1;

void setup(){
  size(800, 600);
  float spaceX = 100;        
  float spaceY = 100;       
  float spaceWidth = 120;   
  float spaceHeight = 180; 
  test = new PropertySpace("Hello", 1, "Greetings", spaceX, spaceY, spaceWidth, spaceHeight, 100, 10);
  test2 = new PropertySpace("Hello", 1, "Greetings", spaceX + spaceWidth, spaceY, spaceWidth, spaceHeight, 100, 10);
  println("Test Space: " + test.getName());
  player1 = new Player("Ardian", 100, color(255, 0, 255));
  test.setOwner(player1);

}

void draw(){
  background(205, 230, 208); 

  if (test != null) {
    test.draw();
    test2.draw();
  }
  fill(0);
  textAlign(LEFT, TOP);
  textSize(12);
  text("MouseX: " + mouseX + "\nMouseY: " + mouseY, 10, 10);
}
