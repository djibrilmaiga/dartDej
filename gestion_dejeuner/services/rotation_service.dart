import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/date_symbol_data_local.dart'; //
import 'package:intl/intl.dart';

import '../models/absence.dart';
import '../models/agent.dart';
import '../models/indiponibilite.dart';
import '../models/jour.dart';
import '../models/rotation.dart';
import '../utils.dart';
import 'mail_sender.dart';

/// La classe `RotationService` gère les opérations liées aux rotations des agents,
/// y compris la gestion des indisponibilités, des jours fériés et l'affectation des tours.
class RotationService {
  static List<Agent> agents = [];
  static List<TourAgent> rotation = [];
  static List<Indisponibilite> indisponibilites = [];
  static List<JourFerier> joursFeries = [];
  static List<Absence> absences = [];

  static int rotationCycleNumber = 0;
  bool isFinishRotation = false;
  late int nombreAgent;
  int currentIndex = 0;

  /// Initialiser des variables `agents` `rotation`  `indisponibilites` `joursFeries` à partir d'un fichier JSON
  static Future<void> chargerDonnees() async {
    File file = File('user_data.json');
    if (await file.exists()) {
      String contents = await file.readAsString();
      Map<String, dynamic> dataJson = jsonDecode(contents);
      List<dynamic> users = dataJson["agents"];
      List<dynamic> rotationsData = dataJson["rotations"];
      List<dynamic> indisponibiliteData = dataJson["indisponibilites"];
      List<dynamic> jourFerierData = dataJson["joursFeries"];
      List<dynamic> absenceData = dataJson["absences"];
      for (var user in users) {
        agents.add(Agent.fromJson(user));
      }

      // for (var r in rotationsData) {
      //   rotation.add(TourAgent.fromJson(r));
      // }

      for (var indisponibilite in indisponibiliteData) {
        indisponibilites.add(Indisponibilite.fromJson(indisponibilite));
      }

      for (var jourF in jourFerierData) {
        joursFeries.add(JourFerier.fromJson(jourF));
      }

      for (var element in absenceData) {
        absences.add(Absence.fromJson(element));
      }
    } else {
      print("Aucun fichier trouvé.");
    }
  }

  /// Ajouter un agent dynamiquement
  void ajouterAgent(Agent agent) {
    agents.add(agent);
    print("${agent.fullName} ajouté !");
  }

  ///La méthode `declarerJourFerier` permet à l'administrateur de déclarer un jour férié
  /// en saisissant la date et une description. Elle enregistre le jour férié dans un fichier JSON
  /// et envoie un email à tous les agents pour les informer du jour férié.
  static Future<void> declarerJourFerier() async {
    late DateTime dateDuJourFerier;
    print("Renseigner le jour Ferier ci dessous (EX: 01/03/2023) :");

    String? jourFerierasString = stdin.readLineSync();

    print("Donner une description pour le jour ferier !");

    String? description = stdin.readLineSync();

    if (jourFerierasString != null) {
      try {
        // Utilisation de intl
        DateFormat format = DateFormat("dd/MM/yyyy");
        dateDuJourFerier = format.parseStrict(jourFerierasString);
      } catch (e) {
        print(
            "Erreur : Format de date invalide. Veuillez utiliser JJ/MM/AAAA.");
        return;
      }
    } else {
      print("Le jour férié ne peut pas être null.");
      return;
    }
    JourFerier jourFerier =
        JourFerier(description: description, date: dateDuJourFerier);

    File file = File("user_data.json");

    if (await file.exists()) {
      String content = await file.readAsString();

      Map<String, dynamic> jsonData = jsonDecode(content);

      List<dynamic> joursFeries = jsonData["joursFeries"] ?? [];

      joursFeries.add(jourFerier.toJson());
      jsonData["joursFeries"] = joursFeries;

      await file.writeAsString(jsonEncode(jsonData));
      agents.forEach((agent) => sendEmail(agent.email,
          "Jour férié ajouté : ${jourFerier.description} le ${DateFormat("dd MMMM yyyy", "fr_FR").format(jourFerier.date)}"));
      print("✅ Jour Ferier  ajouté avec succès ${jourFerier.date} !");
    } else {
      print('Pas de fichier json pour sauvegarder le jour ferier ');
    }
  }

  /// La méthode `getRotationDay` permet à l'administrateur de choisir le jour de rotation
  DateTime getRotationDay() {
    int dayIndex = showMenu([
      "🎃 :) Lundi",
      "🤖 :) Mardi",
      "👻 :) Mercredi",
      "☠️ :) Jeudi",
      "☪️ :) Vendredi",
      "🍕 :) Samedi",
      "🤑 :) Dimanche"
    ], " 😁 Veuillez choisir le jour de rotation 😁 ");

    String jourDeRotation = [
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi",
      "Dimanche"
    ][dayIndex];
    print("Le jour choisi pour la rotation est : $jourDeRotation");

    Map<String, int> jours = {
      'Lundi': 1,
      'Mardi': 2,
      'Mercredi': 3,
      'Jeudi': 4,
      'Vendredi': 5,
      'Samedi': 6,
      'Dimanche': 7,
    };

    int indexDeLaJournerCible = jours[jourDeRotation]!;

    DateTime dateRotation =
        getNextRotationDate(DateTime.now(), indexDeLaJournerCible);

    return dateRotation;
  }

  /// La méthode `getNextRotationDate` calcule la prochaine date de rotation
  /// en fonction de la date de début et du jour de la semaine cible.
  DateTime getNextRotationDate(DateTime startDate, int targetWeekday) {
    int currentWeekday = startDate.weekday; // 1 = Lundi ... 7 = Dimanche

    int daysToAdd = (targetWeekday - currentWeekday + 7) % 7;
    if (daysToAdd == 0) {
      // Si on est déjà le bon jour, planifie pour la semaine suivante
      daysToAdd = 7;
    }

    return startDate.add(Duration(days: daysToAdd));
  }

  /// La méthode `affecterTour` affecte les tours aux agents en fonction de leur disponibilité
  /// et des jours fériés. Elle prend en paramètre la date de rotation et retourne une liste de `TourAgent`.
  /// Elle lit les données des agents, des indisponibilités et des jours fériés à partir d'un fichier JSON,
  /// puis attribue les tours en respectant les indisponibilités et les jours fériés.
  /// Elle envoie également des rappels par email aux agents deux jours avant leur tour.
  /// Elle retourne une liste de `TourAgent` représentant les tours attribués.
  /// Elle utilise la méthode `sendEmail` pour envoyer des emails de rappel.
  Future<List<TourAgent>> affecterTour(DateTime dateRotation) async {
    File file = File('user_data.json');

    if (await file.exists()) {
      String contents = await file.readAsString();
      Map<String, dynamic> dataJson = jsonDecode(contents);
      List<dynamic> users = dataJson["agents"];
      List<dynamic> tourData = dataJson["rotations"];
      List<dynamic> indisponibiliteData = dataJson["indisponibilites"];
      List<dynamic> jourFerierData = dataJson["joursFeries"];

      // Clear existing lists
      agents.clear();
      rotation.clear();
      indisponibilites.clear();
      joursFeries.clear();

      for (var user in users) {
        agents.add(Agent.fromJson(user));
      }

      // for (var tour in tourData) {
      //   rotation.add(TourAgent.fromJson(tour));
      // }

      for (var indisponibilite in indisponibiliteData) {
        indisponibilites.add(Indisponibilite.fromJson(indisponibilite));
      }

      for (var jourF in jourFerierData) {
        joursFeries.add(JourFerier.fromJson(jourF));
      }

      List<TourAgent> tours = [];
      int index = 0;
      List<Agent> agentsCopy =
          List.from(agents); // Copie de la liste des agents
      DateTime currentDate = dateRotation;

      while (agentsCopy.isNotEmpty) {
        // ✅ Pour éviter boucle infinie : essayer chaque agent au maximum une fois par date
        int essais = 0;
        int maxEssais = agentsCopy.length;

        bool tourAttribue = false;

        while (!tourAttribue && essais < maxEssais) {
          Agent agentActuel = agentsCopy.first;

          // Vérifier indisponibilité
          bool indisponible = indisponibilites.any((indispo) =>
              indispo.agent.email == agentActuel.email &&
              isSameDate(indispo.date, currentDate));

          if (indisponible) {
            print(
                "⛔️ ${agentActuel.fullName} est indisponible le $currentDate, reporté à la fin de la liste.");
            agentsCopy.removeAt(0);
            agentsCopy.add(agentActuel);
            essais++;
            continue;
          }

          // Si disponible => affecter
          tours.add(TourAgent(
            agent: agentActuel,
            date: currentDate,
            status: "En attente du tour",
            agentIndex: index,
          ));

          await initializeDateFormatting('fr_FR', null);
          print(
              "🔥 :) Tour attribué à ${agentActuel.fullName} le ${DateFormat("dd MMMM yyyy", "fr_FR").format(currentDate)}");

          agentsCopy.removeAt(0);
          index++;
          tourAttribue = true;

          // Rappel email
          DateTime dateRappel = currentDate.subtract(Duration(days: 2));
          if (DateTime.now().isAfter(dateRappel) &&
              DateTime.now().isBefore(currentDate)) {
            await sendEmail(agentActuel.email,
                "Rappel : Vous avez un tour le ${DateFormat("dd MMMM yyyy", "fr_FR").format(currentDate)}");

            print(
                "Rappel envoyé à ${agentActuel.fullName} pour le tour du ${DateFormat("dd MMMM yyyy", "fr_FR").format(currentDate)}");
          }
        }

        if (!tourAttribue) {
          print("⚠️ Aucun agent disponible le ${currentDate}, date ignorée.");
        }

        // Vérifier si c’est un jour férié (à la fin pour ne pas bloquer au début)
        bool estJourFerier =
            joursFeries.any((jourF) => isSameDate(jourF.date, currentDate));
        if (estJourFerier) {
          print("🎉 Jour férié le ${currentDate}, on saute cette semaine.");
        }

        // 🔄 Avancer à la semaine suivante quoi qu’il arrive (même si personne n’a été affecté)
        currentDate = currentDate.add(Duration(days: 7));
      }

      rotationCycleNumber++;
      // Sauvegarder les modifications
      dataJson['rotations'].add({
        'rotation': tours.map((t) => {"tour": t.toJson()}).toList(),
        "rotationCycleNumber": rotationCycleNumber
      });
      await file.writeAsString(jsonEncode(dataJson), flush: true);

      print(rotationCycleNumber);
      return tours;
    } else {
      return [];
    }
  }

  /// Fonction utilitaire pour comparer 2 dates sans l’heure
  /// Il prend en paramètre deux dates et les compare il sont égaux il retourne true
  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  ///La Méthode `declarerIndisponibilite` sert a déclarer une indisponibilité en passant votre [email] en argument
  /// Ensuite il en enregistre les iformations dans le fichier json
  static Future<void> declarerIndisponibilite(String emailAgent) async {
    await chargerDonnees();
    final agent = agents.firstWhere(
      (a) => a.email == emailAgent,
      orElse: () => throw Exception("Agent non trouvé"),
    );

    File file = File("user_data.json");
    if (await file.exists()) {
      final content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);
      List<dynamic> indisponibiliteList = data['indisponibilites'] ?? [];

      print(
          "📌 Renseigner la date pour laquelle vous serez indisponible (Ex:07/05/2025):");
      String? dateIndisponibiliteAsString = stdin.readLineSync();

      late DateTime dateIndisponibilite;
      if (dateIndisponibiliteAsString != null) {
        try {
          DateFormat dateFormat = DateFormat("dd/MM/yyyy"); // CORRECT
          dateIndisponibilite =
              dateFormat.parseStrict(dateIndisponibiliteAsString);
        } catch (e) {
          print("❌ Format de date invalide. Utilisez JJ/MM/AAAA.");
          return;
        }
      } else {
        print('❌ La date ne peut pas être vide.');
        return;
      }

      print("📌 Donner la raison de l'indisponibilité :");
      String? raison = stdin.readLineSync();

      // Ajout correct de l'indisponibilité
      indisponibiliteList.add(Indisponibilite(
        agent: agent,
        date: dateIndisponibilite,
        reason: raison,
        declarerDateTour: DateTime.now(),
      ).toJson());

      data['indisponibilites'] = indisponibiliteList;

      await file.writeAsString(jsonEncode(data), flush: true);
      print(
          "✅ Indisponibilité ajoutée avec succès pour ${agent.fullName} le ${formatDate(dateIndisponibilite)}");
    } else {
      print(
          "❌ Pas de fichier json pour enregistrer l'indisponibilité d'un Agent");
    }
  }

  /// Méthode pour signaler l'absnece d'un Agent du système Daraka Douman
  Future<void> signalerAbsence() async {
    DateTime dateAbsence;
    print("Veuillez entrer l'email de l'agent :");
    String? email = stdin.readLineSync();

    if (email != null && email.isNotEmpty) {
      final agent = agents.firstWhere(
        (a) => a.email == email,
        orElse: () => throw Exception("Agent non trouvé"),
      );

      print("Veuillez entrer la date d'absence (JJ/MM/AAAA) :");
      String? dateString = stdin.readLineSync();

      if (dateString != null && dateString.isNotEmpty) {
        try {
          DateFormat format = DateFormat("dd/MM/yyyy");
          dateAbsence = format.parseStrict(dateString);
        } catch (e) {
          print("❌ Format de date invalide. Utilisez JJ/MM/AAAA.");
          return;
        }

        // Logique pour signaler l'absence

        File file = File("user_data.json");

        if (await file.exists()) {
          Map<String, dynamic> fileContent =
              jsonDecode(await file.readAsString());

          List<dynamic> absenceList = fileContent["absences"] ?? [];
          // absenceList.add(absence.toJson());

          fileContent["absences"] = absenceList;

          await file.writeAsString(jsonEncode(fileContent), flush: true);
        } else {
          print("Pas de fichier json pour enregistrer l'absence d'un Agent");
        }
        print(
            "⚠️ Absence signalée pour ${agent.fullName} le ${formatDate(dateAbsence)}");
      } else {
        print("❌ La date d'absence ne peut pas être vide.");
      }
    } else {
      print("❌ L'email ne peut pas être vide.");
    }
  }

  /// Méthode pour afficher les  indisponiblités
  void afficherIndisponibilites() {
    if (indisponibilites.isEmpty) {
      print("Aucune indisponibilité enregistrée.");
    } else {
      for (var indispo in indisponibilites) {
        print(
            "${indispo.agent.fullName} - ${formatDate(indispo.date)} (${indispo.reason})");
      }
    }
  }

  /// Méthode ppour afficher les jours férier du système Daraka Douman
  void afficherJoursFeries() {
    if (joursFeries.isEmpty) {
      print("Aucun jour férié enregistré.");
    } else {
      for (var jour in joursFeries) {
        print("${jour.description} - ${formatDate(jour.date)}");
      }
    }
  }

  /// Méthode pour afficher les liste des agnets asbents de Daraka Douman
  /// ILl parcourt la liste des absences dans le fichier Json et affiche les informations
  void afficherAbsence() {
    if (absences.isEmpty) {
      print("Aucune absence enregistrée.");
    } else {
      for (var absence in absences) {
        print(
            "${absence.agent.fullName} absent le ${formatDate(absence.dateAbsence)}");
      }
    }
  }
}
