import 'dart:io';
import 'agent.dart';
import 'rotation.dart';
import 'tourdepassage.dart';
import 'calendrier.dart';
import 'dart:convert';
import 'jourferier.dart';

void main() {
  /*
  print('Entrez le nom  votre entreprise  :');
  String? nomDeEntreprise = stdin.readLineSync();
  print("Entrez le nombre d'agent de votre entreprise");
  //String? nbrAgentStr = stdin.readLineSync();
  //int? nbrAgent = int.tryParse(nbrAgentStr ?? '');
  //int agentCounter = 1;
  // setAgent(nbrAgent, agentCounter);*/
  List<Agent> list_agent = [];
  for (int i = 0; i < 10; i++) {
    String nom = "nom$i";
    String prenom = "prenom$i";
    String email = "email$i@gmail.com";
    String motDpasse = "motdepasse$i";
    Agent agent = Agent(
      nom: nom,
      prenom: prenom,
      email: email,
      motDePasse: motDpasse,
    );
    list_agent.add(agent);
  }
  print(list_agent);
  //creation d'une rotation
  Rotation rotation = setRotation(list_agent, 5);
  print("${rotation.tour!.length}");
  quatreTour(rotation);
}

void setAgent(nbrAgent, agentCounter) {
  print("Le premier agent inserer est <ADMIN>");
  while (nbrAgent != null && nbrAgent > 0) {
    print("Enrefistrer l'agent $agentCounter ");
    print("Donner le nom de l'agent $agentCounter");
    String? nomAgent = stdin.readLineSync();
    print("Donner le prenom de l'agent $agentCounter");
    String? prenomAgent = stdin.readLineSync();
    print("Donner le eamil de l'agent $agentCounter");
    String? emailAgent = stdin.readLineSync();
    print("Donner le mot de passe  de l'agent $agentCounter");
    String? passwordAgent = stdin.readLineSync();
    if (nomAgent != null ||
        prenomAgent != null ||
        emailAgent != null ||
        passwordAgent != null) {
      Agent agent = Agent(
        nom: nomAgent!,
        prenom: prenomAgent!,
        email: emailAgent!,
        motDePasse: passwordAgent!,
      );
      Agent.AgentList.add(agent);
    }
    nbrAgent--;
    agentCounter++;
  }
  Agent.AgentList[0].isAdmin = true;
}

void setMenu() {
  print(
    "Pour naviguer dans le Menu Taper sur ::::::::::::::::::>>>>>>>>>>>>>>",
  );
  print("1::: Ajouter un Calandrier !");
  print("2::: Ajouter un Agent !");
  print("3::: Banir une Agent !");
  print("4::: Suspendre le rotation !");
  String? optionAsString = stdin.readLineSync();

  switch (optionAsString) {
    case '1':
    // ajouter un calandier
    case '2':
    //ajouter un agent
    case '3':
    //Banir un agent
    case '4':
    //Suspendre la rotation
  }
}

Rotation setRotation(List list_agent, int jourConfigure) {
  Rotation rotation = Rotation();
  rotation.tour = [];
  //je dois recupérer le jour configurer et calculer la date prevue en fonction de ça
  DateTime toDay = DateTime.now();
  DateTime datePrevue;
  Status status = Status.Present;
  var start = 0;
  //j'initialise la datePrevue
  if (toDay.weekday < jourConfigure) {
    start = jourConfigure - toDay.weekday;
    datePrevue = toDay.add(Duration(days: start + 7));
  } else {
    datePrevue = toDay.add(Duration(days: 7));
  }
  list_agent.forEach((element) {
    TourDePassage tour = TourDePassage(
      agent: element,
      status: status,
      datePrevue: datePrevue,
    );
    //on ajoute ce tour à la liste des tours dans rotation
    if (rotation.tour != null) {
      print(tour.agent!.nom);
      print(tour.datePrevue);
      rotation.tour!.add(tour);
      print(rotation.tour!.length);
    }
    datePrevue = datePrevue.add(Duration(days: 7));
  });
  //on retourne cette rotation
  return rotation;
}

//affichage des 4 prochains tours de la rotation
void quatreTour(Rotation rotation) {
  //on recupère la date d'aujourd'hui
  DateTime day = DateTime.now();
  day = day.add(Duration(days: 10));
  print("La date d'aujourd'hui est: $day");
  //pour recuperer l'index du premier prochain tour
  int? index_tour;
  //je parcours la date pour chercher la première date > toDay
  var tour = rotation.tour!;
  for (int i = 0; i < tour.length; i++) {
    print("boucle");
    if (tour[i].datePrevue!.isAfter(day) == true) {
      index_tour = i;
      print(index_tour);
      break; //on sort de la liste
    }
  }
  //verifier que c'est different de null
  if (index_tour != null) {
    //on affiche les 4 prochains tours
    int count = 1;
    for (int i = index_tour; i < index_tour + 4 && i < tour.length; i++) {
      print("Les prochains tours");
      print("Tour $count");
      print("Agent: ${tour[i].agent!.nom} ${tour[i].agent!.prenom}");
      print("Date prevue: ${tour[i].datePrevue}");
      count++;
    }
  } else {
    print("Aucun tour prevue dans cette rotation");
  }
}

//decalage des datePrevue
void sautDate(Rotation rotation, JourFerier jourFerier, int tourcourant) {
  var tour = rotation.tour!;
  //on verifie si la date se trouve dans la liste des evènements*/
  if (tour[tourcourant].datePrevue!.isAfter(jourFerier.jourDebut!) ||
      tour[tourcourant].datePrevue!.isBefore(jourFerier.jourFin!)) {
    //on change la valeur de date prevue d'une semaine
    tour[tourcourant].datePrevue!.add(Duration(days: 7));
    //modifier la valeur des autres tourdepassage
    for (int t = tourcourant; t < tour.length; t++) {
      tour[t + 1].datePrevue!.add(Duration(days: 7));
    }
  }
}
