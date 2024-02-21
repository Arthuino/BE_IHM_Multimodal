public class Localisation{
 
  int x;
  int y;

  public Localisation(int x, int y){
    this.x = x;
    this.y = y;
  }

  public Point getLoc(){
    return new Point(x, y);
  }
  
}
