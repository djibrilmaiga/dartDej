import 'agent.dart';

/// La classe `Absence` représente une absence d'un agent à une date donnée.
class Absence {
  Agent agent;
  DateTime dateAbsence;

  /// Constructeur de la classe `Absence`.
  /// Prend en paramètres un objet `Agent` et une date d'absence.
  Absence({required this.agent, required this.dateAbsence});

  ///Convertit l'objet `Absence` en un format JSON.
  /// Utilisé pour la sérialisation des données.
  Map<String, dynamic> toJson() {
    return {"agent": agent, "dateAbsence": dateAbsence};
  }

  ///Crée un objet `Absence` à partir d'un format JSON.
  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(agent: json["agent"], dateAbsence: json["dateAbsence"]);
  }
}
