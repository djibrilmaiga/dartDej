import "dart:io";

import 'models/agent.dart';
import 'services/admin.service.dart';
import 'services/agent_service.dart';
import 'services/rotation_service.dart';
import 'utils.dart';

void main() async {
  await AgentService.createAdmin();

  DateTime? jourDeRotation;

  bool quitterDartDel = false;
  print(
      "Bienvenue sur Daraka Douman Votre application de gestion de déjeuner !");

  while (!quitterDartDel) {
    // Affichage du menu pour choisir le type d'utilisateur

    int userTypeChoice = showMenu([
      "Connexion Admin",
      "Connexion Agent",
      "Avoir de l'info sur Dart Dej ?",
      "Quitter Dart dej !"
    ], "Veillez vous connectez en tant que ::");

    switch (userTypeChoice) {
      case 0:
        print(
            "^^^^^^^^🔥🔥🔥🔥🔥🔥 Veillez vous Connecter en tant qu'ADMIN ! MERCI 🔥🔥🔥🔥🔥🔥^^^^^^^^^^");
        print("Saisiser votre email :");
        String? userName = stdin.readLineSync();
        print("Saisiser votre mot de passe :");
        String? password = stdin.readLineSync();
        if (password != null && userName != null) {
          bool isAdmin = await AdminService.connecterAdmin(userName, password);
          if (!isAdmin) {
            print("❌ Vous n'êtes pas un administrateur.");
            continue;
          }
          // Demande de connexion

          bool quitter = false;
//Menu pour l'admin
          while (!quitter) {
            int choice = showMenu([
              "Inscrire Agent",
              "Voir la liste des Tours ",
              "Afficher le liste des agents",
              "Choisir le journée de rotation",
              "Renseigner jour Ferier",
              "Desactiviter Agent",
              "Marquer une Absence",
              //ajouter la liste des absences
              "Afficher les absences",
              "Afficher les jours Ferier",
              "Afficher les indisponibilites",
              "Deconnexion",
            ], "🥳🥳🥳🥳Bienvenue sur  DartDej[Menu Admin] ☃︎");

            switch (choice) {
              case 0:
                await AgentService.sincrire();
                break;
              case 1:
                jourDeRotation != null
                    ? await RotationService().affecterTour(jourDeRotation)
                    : print(
                        "Aucune information sur les tours car vous n'avez pas de choisi de date de déburt de tour !");

                break;
              case 2:
                await AgentService.afficherListeAgents();
                break;
              case 3:
                jourDeRotation = await RotationService().getRotationDay();
                break;
              case 4:
                await RotationService.declarerJourFerier();
                break;
              case 5:
                await AgentService.banirAgent();
                break;
              case 6:
                await RotationService().signalerAbsence();
                break;
              case 7:
                await RotationService.chargerDonnees();
                RotationService().afficherAbsence();
              case 8:
                await RotationService.chargerDonnees();
                RotationService().afficherJoursFeries();
                break;
              case 9:
                await RotationService.chargerDonnees();
                RotationService().afficherIndisponibilites();
                break;
              case 10:
                print("👋 Vous êtes deconnecter");
                quitter = true;

                break;
              default:
                print("❗ Choix invalide.");
            }
          }
          break;
        } else {
          print(
              "Les champs de peuvent pas être vide (Saisissez votre email et mot de passe) !");
          break;
        }

      case 1:
        Agent? agent = await AgentService.seConnecter();
        if (agent == null) {
          print("❌ Vous n'êtes pas un agent ou vous n'avez pas été inscrit.");
          break;
        }

        while (agent.motDePasse == "darakadouman") {
          print(
              "Veuillez changer votre mot de passe par defaut avant de continuez . Merci ! :");
          String? motDePasse = stdin.readLineSync();
          if (motDePasse != null && motDePasse.isNotEmpty) {
            await AgentService.updatePassword(agent.email, motDePasse);
            print("Votre mot de passe a été changé avec succès !");
            break;
          } else {
            print("Le mot de passe ne peut pas être vide. Veuillez réessayer.");
            continue;
          }
        }
        // print("Connectez vous avec votre nouveau mot de passe !");
        // // Reconnexion de l'agent avec le nouveau mot de passe
        // agent = await AgentService.seConnecter();
//Menu pour l'agent
        bool quitter = false;
        while (!quitter && agent.motDePasse != "darakadouman") {
          print("\n--- Menu de l'agent ---");
          print("Agent connecté : ${agent.fullName}");
          int userChoice = showMenu([
            "Declarer indisponibite",
            "Voir les prochaines tour",
            "Se deconnecter"
          ], "🤓 Bienvenue sur le menu de l'agent [💁 Que souhaitez-vous faire ?]");
          switch (userChoice) {
            case 0:
              print("vous avez choisi de declarer indisponibilite");

              await RotationService.declarerIndisponibilite(agent.email);
              if (jourDeRotation != null) {
                final tours =
                    await RotationService().affecterTour(jourDeRotation);
                print("\n--- NOUVELLE PLANIFICATION ---");
                tours.forEach((t) =>
                    print("${t.agent.fullName} -> ${formatDate(t.date)}"));
              }
              break;

            case 1:
              jourDeRotation != null
                  ? await RotationService().affecterTour(jourDeRotation)
                  : print(
                      "Aucune information sur les tours car L'admin n'a pas de choisi de date !");

              break;
            case 2:
              quitter = true;
              break;
            default:
              print("❗ Choix invalide.");
          }
        }
        break;
      case 2:
        print("""" voir de information sur dart dej ! """);
        break;
      case 3:
        quitterDartDel = true;
        true;
      default:
        print("Merci de d'être sur Dart Dej");
    }
  }
}
