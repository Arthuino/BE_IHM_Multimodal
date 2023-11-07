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

    //give array with the type of all null arguments
    public type getTypeOfNullInputs() {
        ArrayList<type> nullInputs = new ArrayList<type>();
        if (form == null) {
            nullInputs.add(type.FORME);
        }
        if (act == null) {
            nullInputs.add(type.ACTION);
        }
        if (col == null) {
            nullInputs.add(type.COULEUR);
        }
        if (loc == null) {
            nullInputs.add(type.LOCALISATION);
        }
        return nullInputs;
    }
        

}
