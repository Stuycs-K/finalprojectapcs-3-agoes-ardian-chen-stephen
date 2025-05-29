class Dice{

  public int roll(){
    return (int) (Math.random() * 6) + (int) (Math.random() * 6) + 2;
  }

}
