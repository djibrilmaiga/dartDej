class JourFerier {
  final String? description;
  final DateTime date;
  JourFerier({required this.description, required this.date});

  Map<String, dynamic> toJson() {
    return {"description": description, "date": date.toIso8601String()};
  }

  factory JourFerier.fromJson(Map<String, dynamic> json) {
    return JourFerier(
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
