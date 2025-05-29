class JourFerier {
  final String? description;
  final DateTime date;

  /// Constructeur de la classe `JourFerier`.
  /// Prend en paramètres une description du jour férié et la date correspondante.
  JourFerier({required this.description, required this.date});

  /// Convertit l'objet `JourFerier` en un format JSON.
  Map<String, dynamic> toJson() {
    return {"description": description, "date": date.toIso8601String()};
  }

  /// Crée un objet `JourFerier` à partir d'un format JSON.
  /// Utilisé pour la désérialisation des données.
  /// Prend en paramètres un objet JSON contenant les informations du jour férié.
  factory JourFerier.fromJson(Map<String, dynamic> json) {
    return JourFerier(
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
