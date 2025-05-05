import 'dart:io';
import 'dart:convert';
import 'jourFerie.dart';
import 'specialEvent.dart';

class Calendrier {
  // Attributs
  int? jourDeRotation;
  List<Jourferie> jourFeries = [];
  List<Specialevent> specialEvents = [];

  // Constructeurs
  Calendrier({
    required this.jourDeRotation, 
    List<Jourferie>? jourFeries, 
    List<Specialevent>? specialEvent,
    }) {
        this.jourFeries = jourFeries ?? [];
        this.specialEvents = specialEvent ?? [];
    }

  /// Définir le jour de rotation
   void setJourSemaine(int jourSemaine) {
    if (jourSemaine < DateTime.monday || jourSemaine > DateTime.sunday) {
      throw ArgumentError(
          'Le jour de la semaine doit être compris entre ${DateTime.monday} and ${DateTime.sunday}');
    }
    jourDeRotation = jourSemaine;
  }

  /// Vérifie si c'est un jour de rotation
  bool isJourDeRotation(DateTime date) => date.weekday == jourDeRotation;

  /// Ajoute un jour férié
  void ajouterJourFerie(Jourferie jourFerie) {
    jourFeries.add(jourFerie);
  }

  /// Vérifie si c'est un jour férié
  bool isJourFerie(DateTime date) => jourFeries.any((h) => h.estJourFerie(date));

  /// Ajoute un événement exceptionnel
  void ajouterSpecialEvent(Specialevent event) {
    specialEvents.add(event);
  }

  /// Vérifie si c'est un jour d'événement exceptionnel
  bool isSpecialEvent(DateTime date) =>
      specialEvents.any((e) => e.contains(date));

  /// Vérifie si le jour est ouvert (ni férié ni événement)
  bool isOpen(DateTime date) => !isJourFerie(date) && !isSpecialEvent(date);

  /// Trouve la prochaine date ouverte après la datePrevue
  DateTime findNextOpenDate(DateTime datePrevue) {
    var date = datePrevue.add(Duration(days: 7));
    while (!isOpen(date)) {
      date = date.add(Duration(days: 7));
    }
    return date;
  }

  /// Calcule la prochaine date de rotation après la datePrevue
  DateTime findNextRotationDate(DateTime datePrevue) {
    var daysToAdd = (jourDeRotation! - datePrevue.weekday) % 7;
    if (daysToAdd <= 0) daysToAdd += 7;
    return datePrevue.add(Duration(days: daysToAdd));
  }

  /// Trouve la prochaine date de rotation qui est aussi un jour ouvert
  DateTime findNextRotationOpenDate(DateTime datePrevue) {
    var date = findNextRotationDate(datePrevue);
    while (!isOpen(date)) {
      date = findNextRotationDate(date.add(Duration(days: 7)));
    }
    return date;
  }

  Map<String, dynamic> toJson() => {
        'jourDeRotation': jourDeRotation,
        'jourFeries': jourFeries.map((h) => h.toJson()).toList(),
        'specialEvents': specialEvents.map((e) => e.toJson()).toList(),
      };

  factory Calendrier.fromJson(Map<String, dynamic> json) {
    return Calendrier(
      jourDeRotation: json['jourDeRotation'] as int,
      jourFeries: (json['jourFeries'] as List<dynamic>)
          .map((e) => Jourferie.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialEvent: (json['specialEvents'] as List<dynamic>)
          .map((e) => Specialevent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Sauvegarde la configuration dans un fichier JSON
  Future<void> saveToFile(String path) async {
    final file = File(path);
    final content = jsonEncode(toJson());
    await file.writeAsString(content);
  }

  /// Charge la configuration depuis un fichier JSON
  static Future<Calendrier> loadFromFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw Exception('Configuration file not found at \$path');
    }
    final content = await file.readAsString();
    final jsonMap = jsonDecode(content) as Map<String, dynamic>;
    return Calendrier.fromJson(jsonMap);
  }
}