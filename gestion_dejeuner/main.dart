import 'models/agent.dart';
import 'services/agent_service.dart';
import 'utils.dart';

void main() async {
  Agent? agent;

  // int userChoice = showMenu([
  //   "Déclarer une indisponibilité",
  //   "Afficher prochaines rotations",
  //   "Se Deconnecter"
  // ], "Le menu pour Agent Connecter");
  print(
      "^^^^^^^^🔥🔥🔥🔥🔥🔥 Veillez vous Connecter en tant qu'ADMIN ! MERCI 🔥🔥🔥🔥🔥🔥^^^^^^^^^^");
  // Demande de connexion
  agent = await AgentService.seConnecter();

  if (agent != null) {
    if (agent.isAdmin) {
      print("✅ Bienvenue vous êtes Admin(Mr/Mme) ${agent.nom} !");

      bool quitter = false;

      while (!quitter) {
        int choice = showMenu([
          "S'inscrire Agent",
          "Connecter Agent",
          "Afficher le liste des agents",
          "Lancer la rotation",
          "Susprendre la rotation",
          "Banir Agent",
          "Quitter la Session",
        ], "🥳🥳🥳🥳Bienvenue sur  DartDej[Menu Admin] ☃︎");

        switch (choice) {
          case 0:
            await AgentService.sincrire();
            break;
          case 5:
            print("👋 Vous avez choisi de quitter.");
            quitter = true;
            break;
          default:
            print("❗ Choix invalide.");
        }
      }
    } else {
      print("Vous n'êtes pas admin, accès refusé.");
    }
  } else {
    print(" Connexion échouée.");
  }
}

// final rotationManager = RotationManager();
//   await rotationManager.chargerDonnees();

  // while (true) {
  //   int choice = showMenu([
  //     
  //     "Ajouter un agent",
  //    
  //     "Envoyer rappel (simulation)",
  //     "Quitter",
  //   ], "Menu Principal");

  //   switch (choice) {
  //     case 0:
  //       rotationManager.afficherProchainesRotations();
  //       break;
  //     case 1:
  //       // Entrée interactive
  //       print("Nom :");
  //       String? nom = stdin.readLineSync();
  //       print("Prénom :");
  //       String? prenom = stdin.readLineSync();
  //       print("Email :");
  //       String? email = stdin.readLineSync();
  //       if (nom != null && prenom != null && email != null) {
  //         rotationManager.ajouterAgent(Agent(nom: nom, prenom: prenom, email: email));
  //       }
  //       break;
  //     case 2:
  //       // Indispo
  //       print("Email de l'agent :");
  //       String? email = stdin.readLineSync();
  //       print("Date (AAAA-MM-JJ) :");
  //       String? dateStr = stdin.readLineSync();
  //       if (email != null && dateStr != null) {
  //         rotationManager.declarerIndisponibilite(email, DateTime.parse(dateStr));
  //       }
  //       break;
  //     case 3:
  //       print("Date du rappel (AAAA-MM-JJ) :");
  //       String? dateStr = stdin.readLineSync();
  //       if (dateStr != null) {
  //         rotationManager.envoyerRappel(DateTime.parse(dateStr));
  //       }
  //       break;
  //     case 4:
  //       print("Au revoir !");
  //       return;
  //   }
  // }
