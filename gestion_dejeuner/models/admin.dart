import 'agent.dart';

class Admin extends Agent {
  bool isAdmin = true;
  Admin({
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
  }) : super(
          nom: nom,
          prenom: prenom,
          email: email,
        );

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse,
      'isAdmin': isAdmin,
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      motDePasse: json['motDePasse'] as String,
    );
  }
}
