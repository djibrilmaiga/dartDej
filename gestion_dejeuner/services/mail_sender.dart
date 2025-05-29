import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// La méthode `sendEmail` permet d'envoyer un email à l'aide du package `mailer`.
/// Elle prend en paramètres l'adresse email du destinataire et le message à envoyer.
Future<void> sendEmail(String email, String msg) async {
  String username = 'aissatakone3006@gmail.com';
  String password = 'yvjf rmwj shmk fjuy'; // PAS ton mot de passe Gmail

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Daraka Douman App 🍔🍟🍕')
    ..recipients.add(email)
    ..subject = 'Votre App de gestion de Dejeuner '
    ..text = msg;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email envoyé avec succès : ${sendReport.toString()}');
  } catch (e) {
    print('Erreur lors de l\'envoi : $e');
  }
}
