Button button;

void keyPressed(){
}

void draw(){
  background(255); // must occur before display button in order to it to disappear after clicked 
  button.displayButton();

}

void mousePressed() {
  int clicked = button.isClicked();
  if (clicked == -1) {
    return;
  } else if (clicked == 1) {
    println("User clicked Yes.");
  } else {
    println("User clicked No.");
  }
}


void setup(){
  size(500, 500);
  button = new Button("roll", 200, 250);
  
}
