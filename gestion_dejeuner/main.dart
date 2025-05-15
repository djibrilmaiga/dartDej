import 'models/agent.dart';
import 'services/agent_service.dart';
import 'services/rotation_service.dart';
import 'utils.dart';

void main() async {
  Agent? agent;

  DateTime? jourDeRotation;

  bool quitterDartDel = false;

  while (!quitterDartDel) {
    print("Bienvenue sur Dart Dej");

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
        // Demande de connexion
        agent = await AgentService.seConnecter();

        if (agent != null) {
          if (agent.isAdmin) {
            print("✅ Bienvenue vous êtes Admin(Mr/Mme) ${agent.nom} !");

            bool quitter = false;
//Menu pour l'admin
            while (!quitter) {
              int choice = showMenu([
                "S'inscrire Agent",
                "Voir la liste des Tours ",
                "Afficher le liste des agents",
                "Choisir le journée de rotation",
                "Renseigner jour Ferier",
                "Desactiviter Agent",
                "Marquer une Absence",
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
                  RotationService().afficherJoursFeries();
                  break;
                case 8:
                  await RotationService.chargerDonnees();
                  RotationService().afficherIndisponibilites();
                  break;
                case 9:
                  print("👋 Vous êtes deconnecter");
                  quitter = true;

                  break;
                default:
                  print("❗ Choix invalide.");
              }
            }
            break;
          } else {
            print("Vous n'êtes pas admin, accès refusé.");
          }
        } else {
          print(" Connexion échouée.");
        }
        break;
      case 1:
        Agent? agent = await AgentService.seConnecter();
//Menu pour l'agent
        bool quitter = false;
        while (!quitter) {
          int userChoice = showMenu([
            "Declarer indisponibite",
            "Voir les prochaines tour",
            "Se deconnecter"
          ], "🤓 Bienvenue sur le menu de l'agent [💁 Que souhaitez-vous faire ?]");
          switch (userChoice) {
            case 0:
              print("vous avez choisi de declarer indisponibilite");

              if (agent != null) {
                await RotationService.declarerIndisponibilite(agent.email);
                if (jourDeRotation != null) {
                  final tours =
                      await RotationService().affecterTour(jourDeRotation);
                  print("\n--- NOUVELLE PLANIFICATION ---");
                  tours.forEach((t) =>
                      print("${t.agent.fullName} -> ${formatDate(t.date)}"));
                }
                break;
              } else {
                print("Vous etes pas Connecter !");
                break;
              }

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
