class JourFerier {
  final String description;
  static const List<JourFerier> calandier = [];
  final DateTime date;
  JourFerier({required this.description, required this.date});

  void ajouterJourFerier(JourFerier jourFerier) {
    calandier.add(jourFerier);
  }
  bool estJourFerier(JourFerier jour) {
   return calandier.contains(jour);


  }

  void trouverProchainJourOuvrer() {}
}
