import 'agent.dart';

class Rotation {
  Agent agent;
  DateTime date;
  String status; // "Planned", "Done", "Missed", "Unavailable"

  Rotation({
    required this.agent,
    required this.date,
    this.status = 'Planned',
  });

  Map<String, dynamic> toJson() => {
        'agent': agent.toJson(),
        'date': date.toIso8601String(),
        'status': status,
      };

  static Rotation fromJson(Map<String, dynamic> json) => Rotation(
        agent: Agent.fromJson(json['agent']),
        date: DateTime.parse(json['date']),
        status: json['status'],
      );
}
