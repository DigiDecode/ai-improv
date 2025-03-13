import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/services/dialogue_service.dart';
import 'package:ai_improv/utils/web_audio_player.dart';
import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';
import 'package:flutter/material.dart';

class HomePageController {
  final WebAudioPlayer audioPlayer;
  final ChatWidgetController chatController;
  DialogueService? dialogueService;

  HomePageController()
    : audioPlayer = WebAudioPlayer(),
      chatController = ChatWidgetController() {
    dialogueService = DialogueService(chatController);
  }

  Future<void> initialize(BuildContext context) async {
    if (dialogueService != null) {
      dialogueService!.setContext(context);
    } else {
      print("DialogueService is not initialized yet.");
    }
  }

  void updateFirstCharacter(CharacterModel firstCharacter) {
    dialogueService?.firstCharacter = firstCharacter;
  }

  void updateSecondCharacter(CharacterModel secondCharacter) {
    dialogueService?.secondCharacter = secondCharacter;
  }

  // Add this method to your HomePageController class
  void setScenario(String scenario) {
    dialogueService?.scenario = scenario;
  }

  void resetChat() {
    dialogueService?.resetChat();
    chatController.resetChat();
  }

  void dispose() {
    audioPlayer.dispose();
  }

  Future<void> startDialogue() async {
    if (dialogueService != null) {
      await dialogueService!.start();
    }
  }

  void stopDialogue() {
    dialogueService?.stop();
  }
}
