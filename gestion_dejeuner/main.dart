import 'dart:io';
import 'agent.dart';
import 'rotation.dart';
import 'tourdepassage.dart';

void main() {
  print('Entrez le nom  votre entreprise  :');
  String? nomDeEntreprise = stdin.readLineSync();
  print("Entrez le nombre d'agent de votre entreprise");
  String? nbrAgentStr = stdin.readLineSync();
  int? nbrAgent = int.tryParse(nbrAgentStr ?? '');
  int agentCounter = 1;
  setAgent(nbrAgent, agentCounter);
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
          motDePasse: passwordAgent!);
      Agent.AgentList.add(agent);
    }
    nbrAgent --;
    agentCounter ++;
  }
  Agent.AgentList[0].isAdmin = true;
}

void setMenu(){
  print("Pour naviguer dans le Menu Taper sur ::::::::::::::::::>>>>>>>>>>>>>>");
  print("1::: Ajouter un Calandrier !");
  print("2::: Ajouter un Agent !");
  print("3::: Banir une Agent !");
  print("4::: Suspendre le rotation !");
  String? optionAsString = stdin.readLineSync();

  switch(optionAsString){
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
Rotation setRotation(List list_agent, jourConfigure){
  Rotation rotation = Rotation();
  //on parcours la liste d'agent
  list_agent.forEach((element) {
    //on crèe un tour de passage avec cet agent
    //je dois recupérer le jour configurer et calculer la date prevue en fonction de ça
    TourDePassage tour = TourDePassage(element, false, datePrevue);
    //on ajoute ce tour à la liste des tours dans rotation
    rotation.tour.add(tour);
  });
  //on retourne cette rotation
  return rotation;
}
//affichage des 4 prochains tours de la rotation
void quatreTour(Rotation rotation){
  //on recupère la date d'aujourd'hui
  DateTime toDay = DateTime.now();
  //pour recuperer l'index du premier prochain tour
  int? index_tour;
  //je parcours la date pour chercher la première date > toDay
  var tour = rotation.tour!;
  for(int i=0;i<tour.length;i++)
  {
    if(tour[i].datePrevue!.isAfter(toDay))
    {
      index_tour = i;
      break;//on sort de la liste
    }
  }
  //verifier que c'est different de null
  if(index_tour!=null)
  {
    //on affiche les 4 prochains tours
    int count = 1;
    for(int i=index_tour;i<index_tour+4 && i<tour.length;i++)
    {
      print("Les prochains tours");
      print("Tour $count");
      print("Agent: ${tour[i].agent!.nom} ${tour[i].agent!.prenom}");
      print("Date prevue: ${tour[i].datePrevue}");
    }
  }
  else{
    print("Aucun tour prevue dans cette rotation");
  }
}


