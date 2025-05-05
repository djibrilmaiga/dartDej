import 'agent.dart';
enum status {Present, Absent, Indisponible}
//un tour de passage est généré automatique en fonction du nombre d'agent
class TourDePassage{
  Agent? agent;
  bool? estJourFerier;
  DateTime? datePrevue;
  //constructeur du tourdepassage
  TourDePassage(this.agent, this.estJourFerier, this.datePrevue);
  //creer des tours de passages
  void afficherProchainRotation(){

  }
}