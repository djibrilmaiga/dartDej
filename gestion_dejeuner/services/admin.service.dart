import 'dart:convert';
import 'dart:io';

/// La méthode `connecterAdmin` permet de connecter un administrateur
/// en vérifiant son email et son mot de passe à partir d'un fichier JSON.
/// Si la connexion est réussie, elle retourne `true` et affiche un message de succès.
/// Si l'email ou le mot de passe est incorrect, elle retourne `false` et affiche un message d'erreur.
class AdminService {
  static Future<bool> connecterAdmin(String email, String password) async {
    final file = File('user_data.json');
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      Map<String, dynamic> fileData = jsonDecode(fileContent);
      List<dynamic> adminList = fileData['admin'] ?? [];
      if (adminList.isNotEmpty) {
        Map<String, dynamic> adminData = adminList[0];

        if (adminData['email'] == email &&
            adminData['motDePasse'] == password) {
          print("Connexion réussie !");
          return adminData['isAdmin'];
        } else {
          print("Email ou mot de passe incorrect.");
          return false;
        }
      }
    } else {
      print("Le fichier user_data.json n'existe pas.");
    }
    return false;
  }
}
