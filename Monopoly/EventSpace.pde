class EventSpace extends BoardSpace {
  private String eventType;

  public EventSpace(String name, int boardIndex, String event, int xPos, int yPos, float w, float h) {
    super(name, boardIndex, xPos, yPos, w, h, color(255));
    this.eventType = event;
  }

  public String getType() {
    return this.eventType;
  }

  @Override
    public void draw() {
    super.draw();
    fill(255);
    noStroke();
    rect(getX() + 1, getY() + 1, getWidth() - 2, getHeight() - 2);
    stroke(0);
    fill(0);
    textAlign(CENTER, CENTER);
    text(getName(), getX() + getWidth() / 2, getY() + getHeight() * 0.35f - 15f);
  }
}
