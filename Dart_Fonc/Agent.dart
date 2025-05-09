class Agent {
  int idAgent;
  String nom;
  String prenom;
  String email;
  String telephone;
  String motDePasse;
  bool estActif;

// les constructeurs 

Agent({
    required this.idAgent,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.motDePasse,
    this.estActif = true,
  });
   // declarer une indisponibilité
   void declarerIndisponibilité(Date date, String motif){

   //la date recuperer
   final date = DateTime.now();
   //Calculer les jours restants avant l’indisponibilité.
   final joursRestant = date.difference(now).inDays

   if(joursRestant < 2 ){
    print("Erreur : L'indisponibilité doit être signalée au moins 2 jours à l'avance.")

  }else{
    print("Indisponibilité acceptée")
  }
 // Créer un objet Indisponibilite
  final indispo = Indisponibilite(motif: motif,dateDeclaration: date,
      agent: this,
    );
      indispo.declarer();
  
}

}
// classe Indisponibilité
classe Indisponibilite{
    Agent agent;
    String motif;
    DateTime dateDeclaration;

    Indisponibilite({
        required this.agent,
        required this.motif,
        required this.,dateDeclaration,

    });
  // methode declarer
   void declarer(){
    print("Indisponibilité déclarée par ${agent.nom } pour motif : '$motif' le '$dateDeclaration'. ");
   }



}