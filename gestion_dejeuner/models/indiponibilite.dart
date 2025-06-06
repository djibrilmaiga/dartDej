import 'agent.dart';

/// ```dart
/// var user = Utilisateur('Ali', 21);
/// print(user.saluer());
/// ```
class Indisponibilite {
  Agent agent;
  DateTime date;
  DateTime declarerDateTour;
  String reason;

  /// Constructeur de la classe `Indisponibilite`.
  Indisponibilite({
    required this.agent,
    required this.date,
    required this.declarerDateTour,
    String? reason,
  }) : reason = reason ?? "Non précisé";

  /// Convertit l'objet `Indisponibilite` en un format JSON.
  Map<String, dynamic> toJson() => {
        'agent': agent.toJson(),
        'date': date.toIso8601String(),
        'declarerDateTour': declarerDateTour.toIso8601String(),
        'reason': reason,
      };

  /// Crée un objet `Indisponibilite` à partir d'un format JSON.
  factory Indisponibilite.fromJson(Map<String, dynamic> json) =>
      Indisponibilite(
        agent: Agent.fromJson(json['agent']),
        date: DateTime.parse(json['date']),
        declarerDateTour: DateTime.parse(json['declarerDateTour']),
        reason: json['reason'],
      );
}
