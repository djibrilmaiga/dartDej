import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../models/agent.dart';
import '../models/indiponibilite.dart';
import '../models/jour.dart';
import '../models/rotation.dart';
import '../utils.dart';

class RotationService {
  static List<Agent> agents = [];
  static List<TourAgent> rotation = [];
  static List<Indisponibilite> indisponibilites = [];
  static List<JourFerier> joursFeries = [];
  static int rotationCycleNumber = 0;
  bool isFinishRotation = false;
  late int nombreAgent;

  int currentIndex = 0;
  // Paramétrable

  /// Initialiser à partir d'un fichier JSON ou en mémoire
  static Future<void> chargerDonnees() async {
    // À implémenter : lire depuis fichier JSON (agents, rotations, etc.)

    File file = File('user_data.json');
    if (await file.exists()) {
      String contents = await file.readAsString();
      Map<String, dynamic> dataJson = jsonDecode(contents);
      List<dynamic> users = dataJson["agents"];
      List<dynamic> rotationsData = dataJson["rotations"];
      List<dynamic> indisponibiliteData = dataJson["indisponibilites"];
      List<dynamic> jourFerierData = dataJson["joursFeries"];
      for (var user in users) {
        agents.add(Agent.fromJson(user));
      }

      for (var r in rotationsData) {
        rotation.add(TourAgent.fromJson(r));
      }

      for (var indisponibilite in indisponibiliteData) {
        indisponibilites.add(Indisponibilite.fromJson(indisponibilite));
      }
      for (var jourF in jourFerierData) {
        joursFeries.add(JourFerier.fromJson(jourF));
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
      print("✅ Jour Ferier  ajouté avec succès ${jourFerier.date} !");
    } else {
      print('Pas de fichier json pour sauvegarder le jour ferier ');
    }
  }

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

  Future<void> startRotation(DateTime dateRotation) async {
    // print(" 🎰 Rotation lancée !");
    File file = File('user_data.json');

    if (await file.exists()) {
      String contents = await file.readAsString();
      Map<String, dynamic> dataJson = jsonDecode(contents);
      List<dynamic> users = dataJson["agents"];
      List<dynamic> tourData = dataJson["rotations"];
      List<dynamic> indisponibiliteData = dataJson["indisponibilites"];
      List<dynamic> jourFerierData = dataJson["joursFeries"];
      for (var user in users) {
        agents.add(Agent.fromJson(user));
      }

      for (var tour in tourData) {
        rotation.add(TourAgent.fromJson(tour));
      }

      for (var indisponibilite in indisponibiliteData) {
        indisponibilites.add(Indisponibilite.fromJson(indisponibilite));
      }
      for (var jourF in jourFerierData) {
        joursFeries.add(JourFerier.fromJson(jourF));
      }

      // int prochainIndex = (rotation.isEmpty)
      //     ? 0
      //     : (rotation.last.agentIndex + 1) % agents.length;

      // Agent prochainAgent = agents[prochainIndex];

      List<TourAgent> tours = await affecterTour(dateRotation);

      dataJson['rotations'] = tours;
      await file.writeAsString(jsonEncode(dataJson), flush: true);

      rotationCycleNumber++;
      print(rotationCycleNumber);
    }
  }

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

      for (var tour in tourData) {
        rotation.add(TourAgent.fromJson(tour));
      }

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
        Agent agentActuel = agentsCopy.first;
        bool indisponible = false;

        // Vérifier l'indisponibilité
        for (var indispo in indisponibilites) {
          if (indispo.agent.email == agentActuel.email &&
              isSameDate(indispo.date, currentDate)) {
            print(
                "L'agent ${agentActuel.fullName} est indisponible le ${indispo.date}");
            indisponible = true;
            break;
          }
        }

        // Vérifier si c'est un jour férié
        bool estJourFerier = false;
        for (var jourF in joursFeries) {
          if (isSameDate(jourF.date, currentDate)) {
            estJourFerier = true;
            print("Le ${currentDate} est un jour férié (${jourF.description})");
            break;
          }
        }

        if (indisponible || estJourFerier) {
          // Reporter l'agent à la fin de la liste
          print(
              "${agentActuel.fullName} est indisponible ou jour férié le ${currentDate}, reporté en fin de liste.");
          agentsCopy.removeAt(0);
          agentsCopy.add(agentActuel);

          // Pour un jour férié, on incrémente la date pour tout le monde
          if (estJourFerier) {
            currentDate = currentDate.add(Duration(days: 7));
          }
        } else {
          // Créer le tour
          TourAgent tour = TourAgent(
            agent: agentActuel,
            date: currentDate,
            status: "En attente du tour",
            agentIndex: index,
          );
          tours.add(tour);
          await initializeDateFormatting('fr_FR', null);
          print(
              "🔥 :) Tour attribué à ${agentActuel.fullName} le ${DateFormat("dd MMMM yyyy", "fr_FR").format(currentDate)}");

          agentsCopy.removeAt(0);
          currentDate = currentDate.add(Duration(days: 7)); // prochaine semaine
          index++;
          // DateTime dateDuTour = currentDate;
          // DateTime dateRappel = dateDuTour.subtract(Duration(days: 2));
          // // Envoi d'un rappel 2 jours avant le tour

          // Future.delayed(Duration(seconds: 2), () async {
          //   await sendEmail(agentActuel.email,
          //       "Rappel : Vous avez un tour le ${DateFormat("dd MMMM yyyy", "fr_FR").format(dateDuTour)}");
          //   print(
          //       "Rappel envoyé à ${agentActuel.fullName} pour le tour du ${DateFormat("dd MMMM yyyy", "fr_FR").format(dateDuTour)}");
          // });
          // if (DateTime.now().isAfter(dateRappel) &&
          //     DateTime.now().isBefore(dateDuTour)) {

          // print(
          //     "Rappel envoyé à ${agentActuel.fullName} pour le tour du ${DateFormat("dd MMMM yyyy", "fr_FR").format(dateDuTour)}");
          // }
        }
      }

      // Sauvegarder les modifications
      dataJson['rotations'] = tours.map((t) => t.toJson()).toList();
      await file.writeAsString(jsonEncode(dataJson), flush: true);

      rotationCycleNumber++;
      print(rotationCycleNumber);
      return tours;
    } else {
      return [];
    }
  }

// Fonction utilitaire pour comparer 2 dates sans l’heure
  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  DateTime getNextRotationDate(DateTime startDate, int targetWeekday) {
    int currentWeekday = startDate.weekday; // 1 = Lundi ... 7 = Dimanche

    int daysToAdd = (targetWeekday - currentWeekday + 7) % 7;
    if (daysToAdd == 0) {
      // Si on est déjà le bon jour, planifie pour la semaine suivante
      daysToAdd = 7;
    }

    return startDate.add(Duration(days: daysToAdd));
  }

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
    }
  }

  void afficherProchainesRotations(int nombre) {
    List<TourAgent> prochaines = rotation
        .where((r) => r.date.isAfter(DateTime.now()))
        .take(nombre)
        .toList();
    for (var r in prochaines) {
      print("${r.agent.nom} - ${r.date.toLocal()} (${r.status})");
    }
  }

  /// Envoi de rappels simulés
  void envoyerRappel(DateTime date) {
    final entry = rotation.firstWhere((r) => r.date.isAtSameMomentAs(date),
        orElse: () => throw Exception("Rotation non trouvée"));
    print(
        "Rappel envoyé à ${entry.agent.fullName} pour le petit-déjeuner du ${formatDate(date)}");
  }

  Future<void> signalerAbsence() async {
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
        DateTime dateAbsence;
        try {
          DateFormat format = DateFormat("dd/MM/yyyy");
          dateAbsence = format.parseStrict(dateString);
        } catch (e) {
          print("❌ Format de date invalide. Utilisez JJ/MM/AAAA.");
          return;
        }

        // Logique pour signaler l'absence
        print(
            "⚠️ Absence signalée pour ${agent.fullName} le ${formatDate(dateAbsence)}");
      } else {
        print("❌ La date d'absence ne peut pas être vide.");
      }
    } else {
      print("❌ L'email ne peut pas être vide.");
    }
  }

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

  void afficherJoursFeries() {
    if (joursFeries.isEmpty) {
      print("Aucun jour férié enregistré.");
    } else {
      for (var jour in joursFeries) {
        print("${jour.description} - ${formatDate(jour.date)}");
      }
    }
  }
}
