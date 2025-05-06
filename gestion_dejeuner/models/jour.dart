import 'dart:io';
import 'package:intl/intl.dart';

class JourFerier {
  final String description;
  static  List<JourFerier> calandier = [JourFerier(description: "dd", date: DateTime.now())];
  final DateTime date;
  JourFerier({required this.description, required this.date});

  static void ajouterJourFerier(JourFerier jourFerier) {
    calandier.add(jourFerier);
  }
  bool estJourFerier(JourFerier jour) {
   return calandier.contains(jour);


  }

  void trouverProchainJourOuvrer() {}

 static void ajouterCalandrier(int nombreDeJourFerier){
    int conteurDeJour = 1;
    while(nombreDeJourFerier > 0){
      print("Donner le $conteurDeJour jour ferier");
      print("Donner le date sous cette formet : 01/03/200");
      String? date = stdin.readLineSync();
      print("Donner la description du jour Ferier");
      String? description = stdin.readLineSync();
      if (date != null || description != null){
        DateFormat format = DateFormat('dd/mm/yyyy');
        DateTime dateConvertit = format.parseStrict(date!);
        JourFerier jourF = JourFerier(description: description!, date: dateConvertit);
       ajouterJourFerier(jourF);
      }

      nombreDeJourFerier --;
      conteurDeJour ++;
    }

  }
}
