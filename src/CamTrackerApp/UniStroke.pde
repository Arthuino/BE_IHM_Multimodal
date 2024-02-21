/*
 * Processing class for unistroke
 */

 class Unistroke{
    Point[] points;
    float[] vector;

    public Unistroke(Point[] points){
        this.points = points;
    }

    public Point[] getPoints(){
        return points;
    }

    public void setPoints(Point[] points){
        this.points = points;
    }

    public int getLenght(){
        return points.length;
    }

    public float[] getVector(){
        return vector;
    }

    public void setVector(float[] vector){
        this.vector = vector;
    }
 }