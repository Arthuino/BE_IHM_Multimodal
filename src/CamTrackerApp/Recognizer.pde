import de.voidplus.dollar.*;

OneDollar one;

void initGestures(){
  one = new OneDollar(this); 
}


void importTemplates(){
  
  FileInputStream fis;
    // lister les .template dans le répertoire /templates 
    // charger les fichiers et les sauver comme template   
    try {
      File dir=new File(dataPath("") + "/templates");
      File[] liste=dir.listFiles();
      for (File item:liste) {
        if (item.isFile()) {
          StringTokenizer st = new StringTokenizer(item.getName(),".");
          String filename = st.nextToken();
          // println(">> Nom : " + filename);          
          fis = new FileInputStream(dataPath("") + "/templates/" + item.getName()); 
          DataInputStream dis = new DataInputStream(fis);
          Point[] points = new Point[0];
          // .dat -> 64 Points
          float x,y;
          for (int i=0;i<64;i++) {
            x = dis.readFloat();
            y = dis.readFloat();
            points = (Point[])append(points, new Point(x, y));
          }
          fis.close();
           
        }   
      } 

}
