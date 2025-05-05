class Jourferie {
  // Attributs
  String? titre;
  int? jour;
  int? mois;

  // Constructeur
  Jourferie({required this.titre, required this.jour, required this.mois}); 

  /// Vérifier si la date est un jour ferié
  bool estJourFerie(DateTime date) => date.day == this.jour && date.month == this.mois;

  Map<String, dynamic> toJson() => {
        'titre': titre,
        'jour': jour,
        'mois': mois,
      };

  factory Jourferie.fromJson(Map<String, dynamic> json) {
    return Jourferie(
      titre: json['titre'] as String,
      jour: json['jour'] as int,
      mois: json['mois'] as int,
    );
  }
}