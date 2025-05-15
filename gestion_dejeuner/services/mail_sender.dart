import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String email, String msg) async {
  String username = 'aissatakone3006@gmail.com';
  String password = 'yvjf rmwj shmk fjuy'; // PAS ton mot de passe Gmail

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Dart Dej App')
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

void main() async {
  await sendEmail("djenymaiga292@gmail.com", "Salut djeny");
}
