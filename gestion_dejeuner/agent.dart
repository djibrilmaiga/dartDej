class Agent{
  String nom;
  String prenom;
  String email;
  String motDePasse;
  bool estActif = true;
  bool isAdmin = false;

 static List<Agent> AgentList = [];

  Agent({required this.nom, required this.prenom, required this.email , required this.motDePasse, });

  sincrire(){}
  seConnecter(){}
  declarerIndisponibilite(){}
}