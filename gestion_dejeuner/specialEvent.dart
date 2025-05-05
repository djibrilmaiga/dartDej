class Specialevent {
  // Attributs
  DateTime? jourDebut;
  DateTime? jourFin;
  String? motif;

  // Constructeur
  Specialevent({required this.jourDebut, required this.jourFin, required this.motif});

  // Méthodes
  /// Vérifie si la date se situe dans l'événement
  bool contains(DateTime date) => !date.isBefore(jourDebut!) && !date.isAfter(jourFin!);

  Map<String, dynamic> toJson() => {
        'jourDebut': jourDebut!.toIso8601String(),
        'jourFin': jourFin!.toIso8601String(),
        'motif': motif,
      };

  factory Specialevent.fromJson(Map<String, dynamic> json) {
    return Specialevent(
      jourDebut: DateTime.parse(json['start'] as String),
      jourFin: DateTime.parse(json['end'] as String),
      motif: json['reason'] as String,
    );
  }
}