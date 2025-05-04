import 'dart:io';
import 'agent.dart';

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


