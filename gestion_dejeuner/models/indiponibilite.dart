import 'agent.dart';

class Indisponibilite {
  Agent agent;
  DateTime date;
  DateTime declarerDateTour;
  String reason;

  Indisponibilite({
    required this.agent,
    required this.date,
    required this.declarerDateTour,
    String? reason,
  }) : reason = reason ?? "Non précisé";

  Map<String, dynamic> toJson() => {
        'agent': agent.toJson(),
        'date': date.toIso8601String(),
        'declarerDateTour': declarerDateTour.toIso8601String(),
        'reason': reason,
      };

  static Indisponibilite fromJson(Map<String, dynamic> json) => Indisponibilite(
        agent: Agent.fromJson(json['agent']),
        date: DateTime.parse(json['date']),
        declarerDateTour: DateTime.parse(json['declarerDateTour']),
        reason: json['reason'],
      );
}
