import 'agent.dart';

class TourAgent {
  Agent agent;
  DateTime date;
  String status;
  int agentIndex;

  TourAgent({
    required this.agent,
    required this.date,
    required this.status,
    required this.agentIndex,
  });

  Map<String, dynamic> toJson() => {
        'agent': agent.toJson(),
        'date': date.toIso8601String(),
        'status': status,
        'agentIndex': agentIndex,
      };

  static TourAgent fromJson(Map<String, dynamic> json) {
    return TourAgent(
      agent: Agent.fromJson(json['agent']),
      date: DateTime.parse(json['date']),
      status: json['status'],
      agentIndex: json['agentIndex'],
    );
  }
}
