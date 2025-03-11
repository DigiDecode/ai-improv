import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/pages/controllers/home_page_controller.dart';
import 'package:flutter/material.dart';

class HomeStateProvider extends ChangeNotifier {
  final HomePageController controller = HomePageController();
  bool isStarted = false;
  CharacterModel? firstCharacter;
  CharacterModel? secondCharacter;
  String scenarioText = '';

  HomeStateProvider() {
    controller.initializeVoice();
  }

  void setFirstCharacter(CharacterModel character) {
    firstCharacter = character;
    controller.updateFirstCharacter(character);
    notifyListeners();
  }

  void setSecondCharacter(CharacterModel character) {
    secondCharacter = character;
    controller.updateSecondCharacter(character);
    notifyListeners();
  }

  void toggleStartStop() {
    isStarted = !isStarted;
    if (isStarted) {
      controller.dialogueService?.start();
    } else {
      controller.dialogueService?.stop();
    }
    notifyListeners();
  }

  void setScenario(String scenario) {
    scenarioText = scenario;
    controller.setScenario(scenario);
    notifyListeners();
  }

  void resetChat() {
    controller.resetChat();
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
