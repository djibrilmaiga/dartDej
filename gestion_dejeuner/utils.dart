import 'package:interact/interact.dart';

int showMenu(List<String> choices, String message) {
  final selection = Select(
    prompt: message,
    options: choices,
  ).interact();
  return selection;
}
