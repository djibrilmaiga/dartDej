import 'dart:convert';
import 'dart:io';

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
