import 'agent.dart';

class TourAgent {
  Agent agent;
  DateTime date;
  String status;
  int agentIndex;

  /// Constructeur de la classe `TourAgent`.
  /// Prend en paramètres un objet `Agent`, une date, un statut et l'index de l'agent.
  TourAgent({
    required this.agent,
    required this.date,
    required this.status,
    required this.agentIndex,
  });

  /// Convertit l'objet `TourAgent` en un format JSON.
  Map<String, dynamic> toJson() => {
        'agent': agent.toJson(),
        'date': date.toIso8601String(),
        'status': status,
        'agentIndex': agentIndex,
      };

  /// Crée un objet `TourAgent` à partir d'un format JSON.
  factory TourAgent.fromJson(Map<String, dynamic> json) {
    return TourAgent(
      agent: Agent.fromJson(json['agent']),
      date: DateTime.parse(json['date']),
      status: json['status'],
      agentIndex: json['agentIndex'],
    );
  }
}
