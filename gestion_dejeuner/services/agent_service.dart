import 'dart:convert';
import 'dart:io';

import '../models/agent.dart';

class AgentService {
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
        }
      }
    } else {
      print("❌ L'agent n'a pas été enregistré car des champs sont invalides.");
      sincrire();
    }
  }

  static Agent? setAgent() {
    print("Donner le nom de l'agent :");
    String? nomAgent = stdin.readLineSync();
    print("Donner le prénom de l'agent :");
    String? prenomAgent = stdin.readLineSync();
    print("Donner l'email de l'agent :");
    String? emailAgent = stdin.readLineSync();
    print("Donner le mot de passe de l'agent :");
    String? passwordAgent = stdin.readLineSync();

    if (nomAgent != null &&
        prenomAgent != null &&
        emailAgent != null &&
        passwordAgent != null &&
        nomAgent.isNotEmpty &&
        prenomAgent.isNotEmpty &&
        emailAgent.isNotEmpty &&
        passwordAgent.isNotEmpty) {
      return Agent(
        nom: nomAgent,
        prenom: prenomAgent,
        email: emailAgent,
        motDePasse: passwordAgent,
      );
    } else {
      print(" Erreur : tous les champs doivent être remplis !");

      setAgent();
    }
    return null;
  }
//La methode pour se Connecter

  static Future<Agent?> seConnecter() async {
    print("Donner votre email ::>>");
    String? email = stdin.readLineSync();
    print("Donner votre mot de passse ::>>");
    String? motDePasse = stdin.readLineSync();
    final file = File('user_data.json');

    if (!await file.exists()) {
      print(" Aucun utilisateur enregistré. Veuillez d'abord vous inscrire.");
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
      // On suppose que chaque 'user' est un Map<String, dynamic>
      if (user['email'] == email && user['mot_de_passe'] == motDePasse) {
        print(" Connexion réussie. Bienvenue ${user['nom']} !");
        user['isLogin'] = true;
        trouve = true;
        return Agent.fromJson(user);
      }
    }

    if (!trouve) {
      print(" Email ou mot de passe incorrect.");
    }
    return null;
  }

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
            user['estActif'] = false;
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

  static Future<bool> agentExist(String email) async {
    final file = File('user_data.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);
      // Accéder à la liste des agents
      List<dynamic> agentsList = data['agents'] ?? [];

      // Ajouter le nouvel agent
      return agentsList.any((element) => element['email'] == email);
    } else {
      print(" File n'existe pas de lors de verification");
      return false;
    }
  }
}
