import 'dart:convert';
import 'dart:io';

import '../models/admin.dart';
import '../models/agent.dart';
import 'mail_sender.dart';

/// La classe `AgentService` fournit des méthodes pour gérer les agents dans l'application.
class AgentService {
  /// La méthode `createAdmin` permet de créer un administrateur par défaut si aucun administrateur n'existe déjà.
  /// Elle vérifie si le fichier `user_data.json` existe et s'il contient déjà un administrateur.
  /// Si aucun administrateur n'est trouvé, elle crée un nouvel administrateur avec des informations par défaut,
  /// l'ajoute à la liste des administrateurs dans le fichier JSON, et retourne l'objet `Admin` créé.
  static Future<Admin?> createAdmin() async {
    final file = File('user_data.json');
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      Map<String, dynamic> fileData = jsonDecode(fileContent);
      if (fileData['admin'].isEmpty) {
        Admin admin = Admin(
            nom: "admin",
            prenom: "admin",
            email: "admin@gmail.com",
            motDePasse: "admin");
        List<dynamic> adminList = fileData['admin'] ?? [];
        adminList.add(admin.toJson());
        fileData['admin'] = adminList;
        await file.writeAsString(jsonEncode(fileData), flush: true);
        return admin;
      } else {
        print("Un admin existe déjà. Veuillez vous connecter.");
      }
    } else {
      print("pas de fichier json lors decla création admin");
    }
    return null;
  }

  /// La Méthode `setAgent` permet de créer un agent en demandant les informations nécessaires à l'utilisateur
  /// et retourne un objet Agent si les informations sont valides, sinon retourne null.
  static Agent? setAgent() {
    print("Donner le nom de l'agent :");
    String? nomAgent = stdin.readLineSync();
    print("Donner le prénom de l'agent :");
    String? prenomAgent = stdin.readLineSync();
    print("Donner l'email de l'agent :");
    String? emailAgent = stdin.readLineSync();

    if (nomAgent != null &&
        prenomAgent != null &&
        emailAgent != null &&
        nomAgent.isNotEmpty &&
        prenomAgent.isNotEmpty &&
        emailAgent.isNotEmpty) {
      return Agent(
        nom: nomAgent,
        prenom: prenomAgent,
        email: emailAgent,
      );
    } else {
      print(" Erreur : tous les champs doivent être remplis !");

      return null;
    }
  }

// La methode pour S'inscire
  static Future<void> sincrire() async {
    final file = File('user_data.json');

    Agent? agent = setAgent();

    if (agent != null) {
      if (agent.nom.isNotEmpty &&
          agent.prenom.isNotEmpty &&
          agent.email.isNotEmpty &&
          agent.motDePasse.isNotEmpty) {
        // Lire le contenu existant
        if (await file.exists()) {
          final content = await file.readAsString();
          final Map<String, dynamic> data = jsonDecode(content);
          // Accéder à la liste des agents
          List<dynamic> agentsList = data['agents'] ?? [];

          // Ajouter le nouvel agent
          if (await agentExist(agent.email)) {
            print("Un Agent existe avec cet Email ! Merci de :");
            print("Vouloir Verifier votre Email");
            return;
          }

          agentsList.add(agent.toJson());

          // Mettre à jour la map principale
          data['agents'] = agentsList;

          // Sauvegarder
          await file.writeAsString(jsonEncode(data), flush: true);

          print("✅ Agent ajouté avec succès !");
          print(
              "Veillez patienter vous receverez un  mail avec vous identifiants . Merci !");
          await sendEmail(
              agent.email,
              "votre compte a été créé avec succès !\n"
              "Voici vos identifiants :\n"
              "Nom: ${agent.nom}\n"
              "Prénom: ${agent.prenom}\n"
              "Email: ${agent.email}\n"
              "Mot de passe: ${agent.motDePasse}");
        }
        print("Email envoyer avec succes :) ");
      }
    } else {
      return;
    }
  }

  /// La Méthode `seConnecter` permet a un agant de se connecter ssi  l'agent en question est bien active dans notre  fichier json
  static Future<Agent?> seConnecter() async {
    print("Donner votre email ::>>");
    String? email = stdin.readLineSync();
    print("Donner votre mot de passse ::>>");
    String? motDePasse = stdin.readLineSync();
    final file = File('user_data.json');

    if (!await file.exists()) {
      print(
          " Aucun utilisateur enregistré. Car pas de fihier Json pour le sauvegarde des données.");
      return null;
    }

    String contents = await file.readAsString();
    if (contents.isEmpty) {
      print("Aucun utilisateur enregistré. Veuillez d'abord vous inscrire.");
      return null;
    }

    Map<String, dynamic> dataJson = jsonDecode(contents);
    List<dynamic> users = dataJson["agents"];

    bool trouve = false;

    for (var user in users) {
      if (user['estActive'] == true) {
        if (user['email'] == email && user['motDePasse'] == motDePasse) {
          print(" Connexion réussie. Bienvenue ${user['nom']} !");
          user['isLogin'] = true;
          trouve = true;
          return Agent.fromJson(user);
        }
        if (!trouve) {
          print(" Email ou mot de passe incorrect.");
        }
      } else {
        print(
            "Vous êtes désactiver par l/'admin ! Veillez lui contacter afi qu/il vous active de nouveau .");

        return null;
      }
    }
    return null;
  }

  /// Méthode `afficherListeAgents` prermet d'afficher la liste des agents de notre fichier json
  static Future<void> afficherListeAgents() async {
    final file = File('user_data.json');

    if (await file.exists()) {
      String contents = await file.readAsString();
      Map<String, dynamic> dataJson = jsonDecode(contents);
      List<dynamic> users = dataJson["agents"];

      if (users.isNotEmpty) {
        print(" 🚀 :) Liste des agents :");
        for (var user in users) {
          print(
              " ✅ Nom: ${user['nom']}, Prénom: ${user['prenom']}, Email: ${user['email']}");
        }
      } else {
        print("Aucun agent enregistré.");
      }
    } else {
      print("Aucun fichier trouvé.");
    }
  }

  ///Cette methode permet de banir une utilisateur c'est à dire désactiver son compte
  ///une fois le  compte désactiver utilisateur ne pourra plus se connecter a son compte
  /// une fois son compte a été bien désactiver il récevera un email lui indiquant que son compte a bien été désactiver
  static Future<void> banirAgent() async {
    final file = File('user_data.json');

    if (await file.exists()) {
      String contents = await file.readAsString();
      Map<String, dynamic> dataJson = jsonDecode(contents);
      List<dynamic> users = dataJson["agents"];

      if (users.isNotEmpty) {
        print(" 🚀 Liste des agents :");
        for (var user in users) {
          print(
              " ✅ Nom: ${user['nom']}, Prénom: ${user['prenom']}, Email: ${user['email']}");
        }

        print(" 🚨 Entrez l'email de l'agent à bannir :");
        String? emailABannir = stdin.readLineSync();

        bool agentTrouve = false;

        for (var user in users) {
          if (user['email'] == emailABannir) {
            user['estActive'] = false;
            await sendEmail(
                user['email'],
                "Vous venez juste d'être Bani de Daraka Douman Mr/Mme ${user['nom']} ${user['prenom']}!\n"
                "Merci de vous renseignez avec l/'admin afin d/activer votre compte .");

            print(" 🟢 Email envoyé avec succès !");

            agentTrouve = true;
            print(" 🚩 Agent banni avec succès !");
            break;
          }
        }

        if (!agentTrouve) {
          print("Aucun agent trouvé avec cet email.");
        }

        // Mettre à jour le fichier
        await file.writeAsString(jsonEncode(dataJson), flush: true);
      } else {
        print("Aucun agent enregistré.");
      }
    } else {
      print("Aucun fichier trouvé.");
    }
  }

  /// Cette méthode prend en argument **Eamil de Agent** [email] et permet de vérifier si une agent a déjà été créer avec le même émail dans *Daraka Douman*
  static Future<bool> agentExist(String email) async {
    final file = File('user_data.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);

      // Accéder à la liste des agents
      List<dynamic> agentsList = data['agents'] ?? [];

      // Chercher si un agent  existe avec ce email si oui return true sinon return false
      return agentsList.any((element) => element['email'] == email);
    } else {
      print(" File n'existe pas de lors de verification");
      return false;
    }
  }

  /// Méthode `updatePassword`prend en paramètre [email] et [motDePasse] et changele mot de passe de agent dont l'émail a été spécifier
  ///  une fois le mot de passe a été bien modifier l'agent récevera un email lien indiquant que son mot de passe a été bien modifier
  static Future<void> updatePassword(String email, String motDePasse) async {
    final file = File('user_data.json');

    if (await file.exists()) {
      String contents = await file.readAsString();
      Map<String, dynamic> dataJson = jsonDecode(contents);
      List<dynamic> users = dataJson["agents"];

      if (users.isNotEmpty) {
        for (var user in users) {
          if (user['email'] == email) {
            user['motDePasse'] = motDePasse;
            // Mettre à jour le fichier
            await file.writeAsString(jsonEncode(dataJson), flush: true);
            print(" ✅ Mot de passe mis à jour avec succès !");
            print(
                "Patienter vous allez recevoir un mail avec votre nouveau mot de passe .");
            await sendEmail(
                email,
                "Votre mot de passe a été mis à jour avec succès !\n"
                "Nouveau mot de passe: $motDePasse");
            print(" 🟢 Email envoyé avec succès !");

            break;
          }
        }
      } else {
        print("Aucun agent trouvé avec cet email.");
      }
    } else {
      print("Aucun fichier trouvé.");
    }
  }
}
