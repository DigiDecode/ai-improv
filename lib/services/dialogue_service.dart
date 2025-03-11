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

  CharacterModel? _nextToReply;

  CharacterModel? _firstCharacter;
  set firstCharacter(CharacterModel character) {
    _firstCharacter = character;
    _nextToReply ??= character;
    updateSystemPrompts();
  }

  CharacterModel? _secondCharacter;
  set secondCharacter(CharacterModel character) {
    _secondCharacter = character;
    updateSystemPrompts();
  }

  final _firstCharacterMessages = List<ChatMessage>.empty(growable: true);
  final _secondCharacterMessages = List<ChatMessage>.empty(growable: true);

  final ChatWidgetController _chatWidgetController;

  ChatProviderService chatProviderService = ChatProviderService();

  String firstSystemPrompt = '';
  String secondSystemPrompt = '';
  String _scenario = '';
  set scenario(String scenario) {
    _scenario = scenario;
    updateSystemPrompts();
  }

  DialogueService(this._chatWidgetController) {}

  String? canStart() {
    if (_firstCharacter == null) {
      return "Select first character";
    } else if (_secondCharacter == null) {
      return "Select second character";
    }

    return null;
  }

  void resetChat() {
    _firstCharacterMessages.clear();
    _secondCharacterMessages.clear();
    updateSystemPrompts();
  }

  void updateSystemPrompts() {
    // if (canStart() == null) {
    //   return;
    // }
    firstSystemPrompt =
        'Assistant your name is ${_firstCharacter?.name}. \n'
        'Below is a bit more about you:\n'
        'You are a ${_firstCharacter?.gender} and your age is ${_firstCharacter?.age}\n'
        '${_firstCharacter?.description} \n\n'
        'You are talking to ${_secondCharacter?.name} \n'
        'Talk like a real person would do.\n'
        'It is important that your reply is super short one sentence max.\n\n'
        'Detail about this chat:\n $_scenario\n\n'
        'Things that you want to do are below:\n\n'
        '${_firstCharacter?.goal}\n\n';

    secondSystemPrompt =
        'Assistant your name is ${_secondCharacter?.name}.\n'
        'Below is a bit more about you:\n'
        'You are a ${_secondCharacter?.gender} and your age is ${_secondCharacter?.age}\n'
        '${_secondCharacter?.description}\n\n'
        'You are talking to ${_firstCharacter?.name}\n'
        'Talk like a real person would do.\n'
        'It is important that your reply is super short one sentence max.\n\n'
        'Detail about this chat:\n $_scenario\n\n'
        'Things that you want to do are below:\n\n'
        '${_secondCharacter?.goal}\n\n';

    print(firstSystemPrompt);
    print(secondSystemPrompt);

    if (_firstCharacterMessages.isEmpty) {
      _firstCharacterMessages.add(
        ChatMessage(role: ChatRole.system, content: firstSystemPrompt),
      );
    }

    if (_secondCharacterMessages.isEmpty) {
      _secondCharacterMessages.add(
        ChatMessage(role: ChatRole.system, content: secondSystemPrompt),
      );
    }
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

  List<ChatMessage> appendSystemMessage(
    List<ChatMessage> messages,
    String systemMessage,
  ) {
    final temp = List<ChatMessage>.from(messages, growable: true);
    temp.add(ChatMessage(role: ChatRole.system, content: systemMessage));
    return temp;
  }

  void start() async {
    if (canStart() != null) {
      throw Exception("select characters");
    }

    _continue = true;

    // Generate initial reply from first character
    _nextToReply ??= _firstCharacter;

    while (_continue) {
      // Await the reply that's already being generated

      final currentCharacter = _nextToReply!;

      // Update message lists based on which character just replied
      if (currentCharacter == _firstCharacter) {
        final chatReply = await _generateReply(
          _firstCharacter!,
          _firstCharacterMessages,
        );

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
            name: currentCharacter.name,
            text: chatReply.messageContent,
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );

        // Switch to next character
        _nextToReply = _secondCharacter;

        // Start generating next reply concurrently with TTS

        // Play audio for current message
        try {
          await speakTextWithJS(
            chatReply.messageContent,
            currentCharacter.voiceProvider.voiceId,
          );
        } catch (ex) {
          print(ex);
        }
      } else {
        final chatReply = await _generateReply(
          _secondCharacter!,
          _secondCharacterMessages,
        );

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
            name: currentCharacter.name,
            text: chatReply.messageContent,
            isMe: true,
            timestamp: DateTime.now(),
          ),
        );

        // Switch to next character
        _nextToReply = _firstCharacter;

        // Start generating next reply concurrently with TTS
        // nextReplyFuture = _generateReply(
        //   _firstCharacter!,
        //   _firstCharacterMessages,
        // );

        // Play audio for current message
        try {
          await speakTextWithJS(
            chatReply.messageContent,
            currentCharacter.voiceProvider.voiceId,
          );
        } catch (ex) {
          print(ex);
        }
      }
    }
  }

  // Helper method to generate a reply from a character
  Future<ChatCompletion> _generateReply(
    CharacterModel character,
    List<ChatMessage> characterMessages,
  ) async {
    // characterMessages.where((cm) => cm.role == ChatRole.system).forEach((cm) {
    //   print("${character.name} ${cm.content}");
    //   ;
    // });

    return ChatProviderService.getChatCompletion(
      chatProvider: character.chatProvider,
      messages: characterMessages,
      model: character.chatProvider.modelId ?? '',
    );
  }

  void stop() async {
    _continue = false;
  }
}
