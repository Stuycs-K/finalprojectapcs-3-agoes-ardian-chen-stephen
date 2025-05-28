Button button;

void keyPressed(){
}

void mousePressed() {
  int clicked = button.isClicked();
  if (clicked == -1) {
    return; // Do nothing
  } else if (clicked == 1) {
    println("User clicked Yes.");
  } else {
    println("User clicked No.");
  }
}


void draw(){
  button.displayButton();

}

void setup(){
  size(500, 500);
  button = new Button("roll", 100, 100);
  
}
