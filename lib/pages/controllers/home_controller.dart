import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/models/chat_provider_model.dart';
import 'package:ai_improv/models/tts_provider_model.dart';
import 'package:ai_improv/services/dialogue_service.dart';
import 'package:ai_improv/services/elevenlab_service.dart';
import 'package:ai_improv/utils/constants.dart';
import 'package:ai_improv/utils/web_audio_player.dart';
import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';

class HomeController {
  final ElevenLabsService elevenLabs;
  final WebAudioPlayer audioPlayer;
  final ChatWidgetController chatController;
  DialogueService? dialogueService;

  HomeController()
    : elevenLabs = ElevenLabsService(apiKey: Constants.elevenLabsApiKey),
      audioPlayer = WebAudioPlayer(),
      chatController = ChatWidgetController();

  Future<void> initializeVoice() async {
    // final voices = await elevenLabs.getVoices();
    // for (var voice in voices["voices"]) {
    //   print("voice: $voice\n\n");
    // }
    // final voice = voices["voices"][0];
    // final ttsAudio = await elevenLabs.textToSpeech(
    //   text: 'hello world',
    //   voiceId: voice["voice_id"],
    // );
    // audioPlayer.playAudioUrl(ttsAudio);

    final voiceProvider = TTSProviderModel(
      provider: TTSProvider.kokoroInBrowser,
      baseUrl: "",
      apiKey: "",
    );
    final chatProvider = ChatProviderModel(
      baseUrl: Constants.openRouterBaseUrl,
      apiKey: Constants.openRouterApiKey,
    );

    final firstCharacter = CharacterModel(
      name: "Roger",
      description: "Roger is a shy computer nerd",
      goal: "get the user to talk with you",
      voiceProvider: voiceProvider,
      voiceModelId: Constants.defaultElevenLabsModel,
      voiceId: "CwhRBWXzGAHq8TQ4Fs17",
      chatProvider: chatProvider,
      chatModelId: Constants.defaultOpenRouterModel,
    );

    final secondCharacter = CharacterModel(
      name: "Aria",
      description: "Aria is a introvert Uber driver",
      goal: "be yourself",
      voiceProvider: voiceProvider,
      voiceModelId: Constants.defaultElevenLabsModel,
      voiceId: "9BWtsMINqrJLrRacOk9x",
      chatProvider: chatProvider,
      chatModelId: Constants.defaultOpenRouterModel,
    );

    dialogueService = DialogueService(
      firstCharacter,
      secondCharacter,
      chatController,
    );
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
