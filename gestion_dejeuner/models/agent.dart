/// **Nom :** Le nom complet de l'utilisateur.
///
/// - *Requis:* Oui
/// - *Type:* String
class Agent {
  String nom;
  String prenom;
  String email;
  String motDePasse = "darakadouman";
  bool estActif = true;

  Agent({
    required this.nom,
    required this.prenom,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': motDePasse,
        'estActive': estActif,
      };
  String get fullName => '$prenom $nom';

  factory Agent.fromJson(Map<String, dynamic> json) {
    final agent = Agent(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
    );

    if (json['estActif'] != null) {
      agent.estActif = json['estActif'] as bool;
    }
    if (json['motDePasse'] != null) {
      agent.motDePasse = json['motDePasse'] as String;
    }

    return agent;
  }
}
