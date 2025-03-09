import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/models/chat_message.dart';
import 'package:ai_improv/services/chat_provider_service.dart';
import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';
import 'dart:js_interop';

// Proper JS interop for the speakText function
@JS('window.speakText')
external JSPromise speakText(String text, [String? voice]);

class DialogueService {
  bool _continue = false;
  CharacterModel _firstCharacter;
  final _firstCharacterMessages = List<ChatMessage>.empty(growable: true);

  CharacterModel _secondCharacter;
  final _secondCharacterMessages = List<ChatMessage>.empty(growable: true);

  final ChatWidgetController _chatWidgetController;

  CharacterModel? _nextToReply;

  ChatProviderService chatProviderService = ChatProviderService();

  DialogueService(
    this._firstCharacter,
    this._secondCharacter,
    this._chatWidgetController,
  ) {
    _nextToReply = _firstCharacter;
    final situation =
        'The two of you are strangers and have never talked before, IMPORTANT\n'
        'The two of you are sitting in a cafe on the same table'
        'Any of you can change the location where you two are, just mention the new location, e.g. say "now we are at new <location>"';
    'Any of you can change the date or as well, just mention the new date or time, e.g. say "now its  <new day of the week, or new time>"';
    final firstSystemPrompt =
        'You are assistant and your name is ${_firstCharacter.name}. \n'
        'Below is a bit more about you:\n ${_firstCharacter.description} \n\n'
        'user\'s name is ${_secondCharacter.name} \n'
        'situation: ${situation}\n\n'
        'talk like people talk over messenging app, act like a real person would do.\n'
        'your primary goal is to keep the conversation going\n'
        'Your secondary goal is below:\n'
        '${_firstCharacter.goal}\n\n'
        'It is important that your reply is super short 1 sentence max.\n';
    final secondSystemPrompt =
        'You are assistant and your name is ${_secondCharacter.name}.\n'
        'Below is a bit more about you:\n${_secondCharacter.description}\n\n'
        'user\'s name is ${_firstCharacter.name}\n'
        'situation: ${situation}\n\n'
        'talk like people talk over messenging app, act like a real person would do.\n'
        'your primary goal is to keep the conversation going\n'
        'Your secondary goal is below:\n'
        '${_secondCharacter.goal}\n\n'
        'It is important that your reply is super short 1 sentence max.\n';

    print(firstSystemPrompt);
    print(secondSystemPrompt);

    _firstCharacterMessages.add(
      ChatMessage(role: ChatRole.system, content: firstSystemPrompt),
    );

    _secondCharacterMessages.add(
      ChatMessage(role: ChatRole.system, content: secondSystemPrompt),
    );

    _firstCharacterMessages.add(
      ChatMessage(role: ChatRole.user, content: '...'),
    );

    _secondCharacterMessages.add(
      ChatMessage(role: ChatRole.user, content: '...'),
    );
  }

  // Function to speak text using the JavaScript TTS function
  Future<void> speakTextWithJS(String text, [String? voice]) async {
    try {
      final promise = speakText(
        text.trim().replaceAll('\n', '').replaceAll('*', ''),
        voice ?? "af_sky",
      );
      // Convert JS Promise to Dart Future using proper interop
      await Future.any([promise.toDart]);
    } catch (e) {
      print('Error calling TTS: $e');
    }
  }

  void start() async {
    _continue = true;

    // Generate initial reply from first character
    var nextReplyFuture = _generateReply(
      _firstCharacter,
      _firstCharacterMessages,
    );

    while (_continue) {
      // Await the reply that's already being generated
      final chatReply = await nextReplyFuture;
      final currentCharacter = _nextToReply!;

      // Update message lists based on which character just replied
      if (currentCharacter == _firstCharacter) {
        _firstCharacterMessages.add(
          ChatMessage(
            role: ChatRole.assistant,
            content: chatReply.messageContent,
          ),
        );

        _secondCharacterMessages.add(
          ChatMessage(role: ChatRole.user, content: chatReply.messageContent),
        );

        _chatWidgetController.addMessage(
          ChatWidgetMessage(
            text: chatReply.messageContent,
            isMe: true,
            timestamp: DateTime.now(),
          ),
        );

        // Switch to next character
        _nextToReply = _secondCharacter;

        // Start generating next reply concurrently with TTS
        nextReplyFuture = _generateReply(
          _secondCharacter,
          _secondCharacterMessages,
        );

        // Play audio for current message
        await speakTextWithJS(chatReply.messageContent, "bm_fable");
      } else {
        _firstCharacterMessages.add(
          ChatMessage(role: ChatRole.user, content: chatReply.messageContent),
        );

        _secondCharacterMessages.add(
          ChatMessage(
            role: ChatRole.assistant,
            content: chatReply.messageContent,
          ),
        );

        _chatWidgetController.addMessage(
          ChatWidgetMessage(
            text: chatReply.messageContent,
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );

        // Switch to next character
        _nextToReply = _firstCharacter;

        // Start generating next reply concurrently with TTS
        nextReplyFuture = _generateReply(
          _firstCharacter,
          _firstCharacterMessages,
        );

        // Play audio for current message
        await speakTextWithJS(chatReply.messageContent, "af_heart");
      }
    }
  }

  // Helper method to generate a reply from a character
  Future<ChatCompletion> _generateReply(
    CharacterModel character,
    List<ChatMessage> characterMessages,
  ) async {
    return ChatProviderService.getChatCompletion(
      chatProvider: character.chatProvider,
      messages: characterMessages,
      model: character.chatModelId,
    );
  }

  void stop() async {
    _continue = false;
  }
}
