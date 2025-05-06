class Agent {
  String nom;
  String prenom;
  String email;
  String motDePasse;
  bool estActif = true;
  bool isAdmin = false;

  static List<Agent> AgentList = [];

  Agent({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
  });

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'mot_de_passe': motDePasse,
        'estActive': estActif,
        'estAdmin': isAdmin,
      };
  String get fullName => '$prenom $nom';

  factory Agent.fromJson(Map<String, dynamic> json) {
    final agent = Agent(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      motDePasse: json['mot_de_passe'] as String,
    );

    if (json['estActif'] != null) {
      agent.estActif = json['estActif'] as bool;
    }
    if (json['estAdmin'] != null) {
      agent.isAdmin = json['estAdmin'] as bool;
    }

    return agent;
  }

  declarerIndisponibilite() {}
}
