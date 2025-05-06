import 'agent.dart';

enum Status { Present, Absent, Indisponible }

//un tour de passage est généré automatique en fonction du nombre d'agent
class TourDePassage {
  Agent? agent;
  DateTime? datePrevue;
  Status? status;
  //constructeur du tourdepassage
  TourDePassage({this.agent, this.status, this.datePrevue});
  //creer des tours de passages
}
