import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/services/dialogue_service.dart';
import 'package:ai_improv/utils/web_audio_player.dart';
import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';

class HomePageController {
  final WebAudioPlayer audioPlayer;
  final ChatWidgetController chatController;
  DialogueService? dialogueService;

  HomePageController()
    : audioPlayer = WebAudioPlayer(),
      chatController = ChatWidgetController();

  Future<void> initializeVoice() async {
    dialogueService = DialogueService(chatController);
  }

  void updateFirstCharacter(CharacterModel firstCharacter) {
    dialogueService?.firstCharacter = firstCharacter;
  }

  void updateSecondCharacter(CharacterModel secondCharacter) {
    dialogueService?.secondCharacter = secondCharacter;
  }

  // Add this method to your HomePageController class
  void setScenario(String scenario) {
    if (dialogueService != null) {
      dialogueService?.scenario = scenario;
    }
  }

  void resetChat() {
    dialogueService!.resetChat();
    chatController.resetChat();
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
