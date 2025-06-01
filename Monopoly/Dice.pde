class Dice{
  int die1, die2;
  
  
  Dice(){
  
  }
  
  void roll(){
    die1 = (int) (Math.random() * 6) + 1;
    die2 = (int) (Math.random() * 6) + 1;
  }
  
  boolean isDouble(){
    return die1 == die2;
  }
  
  int getDice1(){
    return die1;
  }
  
  int getDice2(){
    return die2;
  }

}
