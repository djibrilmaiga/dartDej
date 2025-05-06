import 'agent.dart';

class Indisponibilite {
  Agent agent;
  DateTime date;
  String reason;

  Indisponibilite({
    required this.agent,
    required this.date,
    this.reason = "Non précisé",
  });

  Map<String, dynamic> toJson() => {
        'agent': agent.toJson(),
        'date': date.toIso8601String(),
        'reason': reason,
      };

  static Indisponibilite fromJson(Map<String, dynamic> json) => Indisponibilite(
        agent: Agent.fromJson(json['agent']),
        date: DateTime.parse(json['date']),
        reason: json['reason'],
      );
}
