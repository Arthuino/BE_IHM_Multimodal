public class Localisation{
 
  int x;
  int y;

  public Localisation(int x, int y){
    this.x = x;
    this.y = y;
  }

  public Point getPoint(){
    return new Point(x, y);
  }
  
}
