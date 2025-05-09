enum Statut {
    present, 
    absent,
    indiponible; 
}

class TourDePassage{
   int idTour
   Agent agentDesigne;
   Date datePrevue;
   bool estJourFerie = false;
   Statut statut ;

//Constructeur

   TourDePassage({
    required this.id,
    required this.agentDesigne,
    required this.datePrevue,
    this.statut= Statut.present,

   });

// methode estJourFerier
    bool estJourFerier(DateTime date, List<JourFerie> joursFeries){

        
    }

}
