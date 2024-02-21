/*
 * Basé sur la Palette graphique
 * L'application est un "put that here" multimodal
 * Elle permet de créer des formes géométriques et de les déplacer
 */
 
import java.awt.Point;
import fr.dgac.ivy.*;


ArrayList<Forme> formes; // liste de formes stockées
FSM mae; // Finite Sate Machine
int indice_forme;
PImage sketch_icon;


// Variables de Fusion
ArrayList<Commande> prevCmds;

// Bus Ivy
Ivy bus;
String busName = "sra_tts_bridge";



void setup() {
  size(1000,800);
  surface.setResizable(true);
  surface.setTitle("Palette multimodale");
  surface.setLocation(20,20);
  sketch_icon = loadImage("Palette.jpg");
  surface.setIcon(sketch_icon);
  
  formes= new ArrayList(); // nous créons une liste vide
  noStroke();
  mae = FSM.INITIAL;
  indice_forme = -1;
  
   // Machine de fusion
   prevCmds = new ArrayList();
  
  // Bus Ivy
  try
  {
    bus = new Ivy(busName, " sra_tts_bridge is ready", null);
    bus.start("127.255.255.255:2010");
    
    //SPEECH - ACTION - COLOR
    bus.bindMsg("^SPEECH_INPUT type=(.*) input=(.*)", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        println("SPEECH_INPUT : type="+args[0]+" input="+args[1]);
        // if Action
        if (args[0].equals("ACTION")) {
          Action act;
          if(args[1].equals("move")) {
            act = Action.MOVE;
            newCmdInput(prevCmds, act);
          } else if (args[1].equals("create")) {
            act = Action.CREATE;
            newCmdInput(prevCmds, act);
          }

        }

        // if color
        else if (args[0].equals("COLOR")) {
          if(args[1].equals("red")) {
            newCmdInput(prevCmds, color(255,0,0));
          }
          if(args[1].equals("green")) {
            newCmdInput(prevCmds, color(0,255,0));
          }
          if(args[1].equals("blue")) {
            newCmdInput(prevCmds, color(0,0,255));
          }
          if(args[1].equals("yellow")) {
            newCmdInput(prevCmds, color(255,255,0));
          }
          if(args[1].equals("orange")) {
            newCmdInput(prevCmds, color(255,165,0));
          }
          if(args[1].equals("purple")) {
            newCmdInput(prevCmds, color(128,0,128));
          }
          if(args[1].equals("dark")) {
            newCmdInput(prevCmds, color(0,0,0));
          }
        }

      }        
    });


    // CAMERA/KEYBOARD - FORME
    bus.bindMsg("^FORME_INPUT type=(.*)", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        Forme form = null;
        println("FORME_INPUT : type="+args[0]);
        // Forme
        if (args[0].equals("cercle")) {
          form = new Cercle();
        }
        else if (args[0].equals("rectangle")) {
          form = new Rectangle();
        }
        else if (args[0].equals("triangle")) {
          form = new Triangle();
        }
        else if (args[0].equals("losange")) {
          form = new Losange();
        }
        newCmdInput(prevCmds, form);
        
      }    
    });


    // EYETRACKING/MOUSE - LOCALISATION
    bus.bindMsg("^LOC_INPUT x=(.*) y=(.*)", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        println("LOC_INPUT : x="+args[0]+" y="+args[1]);
        // Localisation
        Localisation loc = new Localisation(int(args[0]), int(args[1]));
        newCmdInput(prevCmds, loc);
       
      }        
    });
  }
  catch (IvyException ie)
  {
  }

  
  println("Fusion machine ready");
}

void draw() {
  background(0);
  // println("MAE : " + mae + " indice forme active ; " + indice_forme);
  switch (mae) {
    case INITIAL:  // Etat INITIAL
      background(255);
      fill(0);
      text("Etat initial (c(ercle)/l(osange)/r(ectangle)/t(riangle) pour créer la forme à la position courante)", 50,50);
      text("m(ove)+ click pour sélectionner un objet et click pour sa nouvelle position", 50,80);
      text("click sur un objet pour changer sa couleur de manière aléatoire", 50,110);
      break;
      
    case AFFICHER_FORMES:  // 
      affiche();
      break; 
    case DEPLACER_FORMES_SELECTION:
      affiche();
      break; 
    case DEPLACER_FORMES_DESTINATION: 
      affiche();
      break;   
      
    default:
      break;
  }  
}


/*
  Fonction de création de commandes
  Si l'input est déjà présent dans une commande, on crée une nouvelle commande
  
  @param cmds : liste de commandes
  @param input : objet de type Action, Forme, Localisation
*/
void newCmdInput(ArrayList<Commande> cmds,Object input){
  boolean isInputSet = false;
  Commande cmd = new Commande();
  // on vérifie que l'input est bien un objet de type Action, Forme, Localisation ou Color
  if (cmd.isObjectInput(input)==false) {
    println("newCmdInput : input non reconnu");
  }
  
  // si la liste n'est pas vide
  if (cmds.size()>0) {
    // on parcourt toute les commandes en partant de la fin
    int i=cmds.size()-1;
    while (i>=0 && isInputSet==false) {
      if (cmds.get(i).isInputAvailable(input)==true) {
        cmds.get(i).addInput(input);
        isInputSet=true;
      }
      i--;
    }
  }

  if(isInputSet==false) {
    Commande c = new Commande();
    c.addInput(input);
    cmds.add(c);
  }

}

// fonction d'affichage des formes m
void affiche() {
  background(255);
  /* afficher tous les objets */
  for (int i=0;i<formes.size();i++) // on affiche les objets de la liste
    (formes.get(i)).update();
}

void mousePressed() { // sur l'événement clic
  Point p = new Point(mouseX,mouseY);
  
  switch (mae) {
    case AFFICHER_FORMES:
      for (int i=0;i<formes.size();i++) { // we're trying every object in the list
        // println((formes.get(i)).isClicked(p));
        if ((formes.get(i)).isClicked(p)) {
          (formes.get(i)).setColor(color(random(0,255),random(0,255),random(0,255)));
        }
      } 
      break;
      
   case DEPLACER_FORMES_SELECTION:
     for (int i=0;i<formes.size();i++) { // we're trying every object in the list        
        if ((formes.get(i)).isClicked(p)) {
          indice_forme = i;
          mae = FSM.DEPLACER_FORMES_DESTINATION;
        }         
     }
     if (indice_forme == -1)
       mae= FSM.AFFICHER_FORMES;
     break;
     
   case DEPLACER_FORMES_DESTINATION:
     if (indice_forme !=-1)
       (formes.get(indice_forme)).setLocation(new Point(mouseX,mouseY));
     indice_forme=-1;
     mae=FSM.AFFICHER_FORMES;
     break;
     
    default:
      break;
  }
}


void keyPressed() {
  Point p = new Point(mouseX,mouseY);
  switch(key) {
    case 'r':
      Forme f= new Rectangle(p);
      formes.add(f);
      mae=FSM.AFFICHER_FORMES;
      break;
      
    case 'c':
      Forme f2=new Cercle(p);
      formes.add(f2);
      mae=FSM.AFFICHER_FORMES;
      break;
    
    case 't':
      Forme f3=new Triangle(p);
      formes.add(f3);
       mae=FSM.AFFICHER_FORMES;
      break;  
      
    case 'l':
      Forme f4=new Losange(p);
      formes.add(f4);
      mae=FSM.AFFICHER_FORMES;
      break;    
      
    case 'm' : // move
      mae=FSM.DEPLACER_FORMES_SELECTION;
      break;
  }
}
// Create method  
void createForme(Commande cmd){
  // on met à jour la forme avec les informations de la commande
  cmd.form.setLocation(cmd.loc.getLoc());
  cmd.form.setColor(cmd.col);
  formes.add(cmd.form);
}


// Fusion method
void fusion(ArrayList<Commande> cmds) {
  // on parcourt toute les commandes existantes en partant de la fin
  Commande cmd = new Commande();
  int i=cmds.size()-1;
  while (i>=0) {
    // on vérifie si la commande contient suffisamment d'informations pour être exécutée
    if (cmds.get(i).isCompleteEnough()==true) {
      cmd = cmds.get(i);
      println("fusion : commande complète --> "+cmd.toString());
      // Si oui, on execute la commande correspondante
      if(cmd.act == Action.CREATE) {
        

        createForme(cmd);
      }
    }
    i--;
  }
}
