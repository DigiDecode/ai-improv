import 'package:ai_improv/services/elevenlab_service.dart';
import 'package:ai_improv/utils/constants.dart';
import 'package:ai_improv/utils/web_audio_player.dart';
import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';

class HomeController {
  final ElevenLabsService elevenLabs;
  final WebAudioPlayer audioPlayer;
  final ChatWidgetController chatController;

  HomeController()
    : elevenLabs = ElevenLabsService(apiKey: Constants.ELEVEN_LABS_API_KEY),
      audioPlayer = WebAudioPlayer(),
      chatController = ChatWidgetController();

  Future<void> initializeVoice() async {
    final voices = await elevenLabs.getVoices();
    final voice = voices["voices"][0];
    final ttsAudio = await elevenLabs.textToSpeech(
      text: 'hello world',
      voiceId: voice["voice_id"],
    );
    audioPlayer.playAudioUrl(ttsAudio);
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
