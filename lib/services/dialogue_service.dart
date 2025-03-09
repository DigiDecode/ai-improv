import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/models/chat_message.dart';
import 'package:ai_improv/services/chat_provider_service.dart';
import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';
import 'dart:js_interop'; // Import the modern JS interop package

// Define JS interop for the speakText function
@JS('window.speakText')
external JSPromise _speakText(String text, [String? voice]);

// Extension method to convert JSPromise to Dart Future
extension JSPromiseExtension on JSPromise {
  Future<bool> toDart() {
    return Future.value(this).then((value) => value as bool);
  }
}

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
    final firstSystemPrompt =
        'You are assistant and your name is ${_firstCharacter.name}.\n'
        'You talking to User over dating app, and user\'s name is ${_secondCharacter.name}\n'
        'The two of you are strangers and have never talked before, IMPORTANT\n'
        'talk like people talk over messenging app, act like a real person would do.\n'
        'Your goal is below:\n'
        '${_firstCharacter.goal}\n\n'
        'It is important that your reply is super short 1 sentence max.\n';
    final secondSystemPrompt =
        'You are assistant and your name is ${_secondCharacter.name}.\n'
        'You talking to User over dating app, and user\'s name is ${_firstCharacter.name}\n'
        'The two of you are strangers and have never talked before, IMPORTANT\n'
        'talk like people talk over messenging app, act like a real person would do.\n'
        'you are not easy\n'
        'Your goal is below:\n'
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
  }

  // Function to speak text using the JavaScript TTS function
  Future<bool> speakText(String text, [String? voice]) async {
    try {
      return await _speakText(text, voice ?? "af_sky").toDart();
    } catch (e) {
      print('Error calling TTS: $e');
      return false;
    }
  }

  void start() async {
    _continue = true;

    // Generate initial reply from first character
    var nextReplyFuture = _generateReply(
      _firstCharacter,
      _firstCharacterMessages,
      _secondCharacterMessages,
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
          _firstCharacterMessages,
        );

        // Play audio for current message
        await speakText(chatReply.messageContent, "am_adam");
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
          _secondCharacterMessages,
        );

        // Play audio for current message
        await speakText(chatReply.messageContent, "af_sky");
      }
    }
  }

  // Helper method to generate a reply from a character
  Future<ChatCompletion> _generateReply(
    CharacterModel character,
    List<ChatMessage> characterMessages,
    List<ChatMessage> otherCharacterMessages,
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
