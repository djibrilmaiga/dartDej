import 'agent.dart';

class Admin extends Agent {
  bool isAdmin = true;

  ///Constructeur de la classe `Admin`.
  /// Prend en paramètres le nom, le prénom, l'email et le mot de passe de l'admin.
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

  /// Convertit l'objet `Admin` en un format JSON.
  /// Utilisé pour la sérialisation des données.
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse,
      'isAdmin': isAdmin,
    };
  }

  /// Crée un objet `Admin` à partir d'un format JSON.
  /// Utilisé pour la désérialisation des données.
  /// Prend en paramètres un objet JSON contenant les informations de l'admin.
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      motDePasse: json['motDePasse'] as String,
    );
  }
}
