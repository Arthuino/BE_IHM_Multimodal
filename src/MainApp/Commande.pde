/*
 *  Classe représentant une commande 'un utilisateur.
 *  Contient des informations d'ACTION, de COULEUR, de FORME et de LOCALISATION
 *
 *
 *
 *
*/

public class Commande {
    Forme form;
    Action act;
    color col;
    Localisation loc;

    public Commande() {
        this.form = null;
        this.act = null;
        this.col = -1;
        this.loc = null;
    }

    //constructor for each type of input
    public Commande(Forme form) {
        this.form = form;
    }

    public Commande(Action act) {
        this.act = act;
    }

    public Commande(color col) {
        this.col = col;
    }

    public Commande(Localisation loc) {
        this.loc = loc;
    }


    public void addInput(Object input) {
        if (input instanceof Action) {
            this.act = (Action) input;
        } else if (input instanceof Forme) {
            this.form = (Forme) input;
        } else if (input instanceof Localisation) {
            this.loc = (Localisation) input;
        } else if (input instanceof Integer) {
            this.col = (Integer) input;
        }
    }


    public boolean isObjectInput(Object input){
        if (input == null || (input instanceof Action || input instanceof Forme || input instanceof Localisation || input instanceof Integer)) {
            return false;
        }
        return true;
    }

    public boolean isInputAvailable(Object input){
        return input == null ? false :
       input instanceof Action ? act == null :
       input instanceof Forme ? form == null :
       input instanceof Localisation ? loc == null :
       input instanceof Integer ? col == -1 : false;

    }

    public boolean isCompleteEnough() {
        if(act == Action.MOVE){
            return form != null && loc != null;
        } else if(act == Action.CREATE){
            return form != null && (loc != null || col != -1);
        }
        return false;
    }

    public String toString() {
        return "Commande : " + act + " " + form + " " + col + " " + loc;
    }
        

}
