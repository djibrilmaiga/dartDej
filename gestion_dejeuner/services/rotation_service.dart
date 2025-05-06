import '../models/agent.dart';
import '../models/indiponibilite.dart';
import '../models/rotation.dart';

class RotationService {
  List<Agent> agents = [];
  List<Rotation> rotations = [];
  List<Indisponibilite> indisponibilites = [];
  List<DateTime> joursFeries = [];
  int currentIndex = 0;
  String jourRotation = 'Friday'; // Paramétrable

  /// Initialiser à partir d'un fichier JSON ou en mémoire
  Future<void> chargerDonnees() async {
    // À implémenter : lire depuis fichier JSON (agents, rotations, etc.)
  }

  /// Ajouter un agent dynamiquement
  void ajouterAgent(Agent agent) {
    agents.add(agent);
    print("${agent.fullName} ajouté !");
  }

  /// Affiche les 4 prochaines rotations
  void afficherProchainesRotations() {
    int count = 0;
    int index = currentIndex;

    print("Prochaines rotations :");

    while (count < 4) {
      Agent agent = agents[index % agents.length];
      DateTime prochainDate = _trouverProchainJourRotation();

      // Check indisponibilité
      bool isIndispo = indisponibilites.any((indispo) =>
          indispo.agent.email == agent.email &&
          indispo.date.isAtSameMomentAs(prochainDate));

      if (isIndispo) {
        print(
            "${agent.fullName} est indisponible le ${_formatDate(prochainDate)} ➔ Passe au suivant");
        index++;
        continue;
      }

      print("${agent.fullName} ➔ ${_formatDate(prochainDate)}");
      rotations.add(Rotation(agent: agent, date: prochainDate));
      index++;
      count++;
    }
  }

  /// Déclare une indisponibilité
  void declarerIndisponibilite(String emailAgent, DateTime date) {
    final agent = agents.firstWhere((a) => a.email == emailAgent,
        orElse: () => throw Exception("Agent non trouvé"));
    indisponibilites.add(Indisponibilite(agent: agent, date: date));
    print(
        "${agent.fullName} déclaré indisponible pour le ${_formatDate(date)}");
  }

  /// Envoi de rappels simulés
  void envoyerRappel(DateTime date) {
    final entry = rotations.firstWhere((r) => r.date.isAtSameMomentAs(date),
        orElse: () => throw Exception("Rotation non trouvée"));
    print(
        "Rappel envoyé à ${entry.agent.fullName} pour le petit-déjeuner du ${_formatDate(date)}");
  }

  /// Trouver le prochain jour ouvré
  DateTime _trouverProchainJourRotation({DateTime? startDate}) {
    DateTime date = startDate ?? DateTime.now();
    while (true) {
      date = date.add(Duration(days: 1));
      if (_estJourRotation(date) && !_estFerie(date)) {
        return date;
      }
    }
  }

  bool _estJourRotation(DateTime date) {
    return date.weekday == _weekdayFromString(jourRotation);
  }

  bool _estFerie(DateTime date) {
    return joursFeries.any((f) =>
        f.year == date.year && f.month == date.month && f.day == date.day);
  }

  int _weekdayFromString(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return DateTime.friday;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
