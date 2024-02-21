/* 
 * Cette application processing permet de récupérer l'image de la webcam et récupère le "centre de gravité" de la couleur verte dans l'image.
 * L'objectif est d'utiliser un unistroke recognizer pour reconnaitre des formes géométriques simples.
 * Le résultat doit être envoyé sur un bus IVY
 */
import processing.video.*;

Capture cam;
int greenWeight;
Point [] points;
Unistroke currentStroke;


void setup(){
    // On initialise la webcam
    size(640, 480);
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
    } else {
        println("Available cameras:");
        for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
        }
        // The camera can be initialized directly using an index
        cam = new Capture(this, cameras[0]);
        cam.start();
    }
    points = new Point[0];
    currentStroke = new Unistroke(points);
}



void draw(){
  if (cam.available() == true) {
    cam.read();
  }
  pushMatrix();
  translate(width, 0);
  scale(-1, 1);
  
  PImage img = cam.copy();
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    int c = img.pixels[i];
    if (green(c)>230 ) {
      img.pixels[i] = color(0, 255, 0);
    } else {
      img.pixels[i] = color(0, 0, 0);
    }
  }
  img.updatePixels();

  // On récupère le centre de gravité de la couleur verte
  Point center = getCenterOfGravity(img, color(0, 255, 0));
  // On l'affiche
  
  image(cam, 0, 0);
  if(greenWeight>1000){
    
    points = (Point[])append(points, center);
    fill(255, 0, 0);
    ellipse(center.X, center.Y, 10, 10);
  }
  else if(points.length!=0){
    currentStroke = new Unistroke(points);
    points = new Point[0];
  }
  
  if(currentStroke.points.length>0){
    for (int i = 0; i < currentStroke.points.length; i++) {
      ellipse(currentStroke.points[i].X, currentStroke.points[i].Y,5,5);
    }
  }

  
  popMatrix();
}



Point getCenterOfGravity(PImage img, int colorToTrack){
  // On initialise les variables
  float x = 0;
  float y = 0;
  int count = 0;
  // On parcourt l'image
  for(int i = 0; i < img.width; i++){
    for(int j = 0; j < img.height; j++){
      // On récupère la couleur du pixel
      int c = img.get(i, j);
      // Si la couleur correspond à celle recherchée
      if(c == colorToTrack){
        // On incrémente le nombre de pixels
        count++;
        // On ajoute les coordonnées du pixel
        x += i;
        y += j;
      }
    }
  }
  // On retourne le centre de gravité
  greenWeight = count;
  return new Point(x/count, y/count);
}
