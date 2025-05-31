class Dice{
  int die1, die2;
  
  
  Dice(){
  
  }
  
  public int roll(){
    die1 = (int) (Math.random() * 6) + 1;
    die2 = (int) (Math.random() * 6) + 1;
    return die1 + die2;
  }
  
  boolean isDouble(){
    return die1 == die2;
  }

}
