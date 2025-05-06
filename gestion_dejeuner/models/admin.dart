import 'agent.dart';

class Admin extends Agent {
  List<Agent> listeDesAgents = [];

  Admin(
      {required String nom,
      required String prenom,
      required String email,
      required String motDePasse,
      required String telephone})
      : super(
          nom: nom,
          prenom: prenom,
          email: email,
          motDePasse: motDePasse,
        );

  ajouterAgent() {}
  banirAgent() {}
  mettreAJourCalandier() {}
}
