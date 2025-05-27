Button button;

void keyPressed(){
}


void draw(){
  button.displayButton();

}

void setup(){
  size(500, 500);
  button = new Button("purchase", 100, 100);
  
}
