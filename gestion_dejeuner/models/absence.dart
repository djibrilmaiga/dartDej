import 'agent.dart';

class Absence {
  Agent agent;
  DateTime dateAbsence;

  Absence({required this.agent, required this.dateAbsence});

  Map<String, dynamic> toJson() {
    return {"agent": agent, "dateAbsence": dateAbsence};
  }

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(agent: json["agent"], dateAbsence: json["dateAbsence"]);
  }
}
