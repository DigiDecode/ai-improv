import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/models/chat_message.dart';
import 'package:ai_improv/services/chat_provider_service.dart';
import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';

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
        'You and User are strangers\n'
        'talk like people talk over messenging app\n'
        'Your goal is below:\n'
        '${_firstCharacter.goal}\n\n'
        'It is important that your reply is super short 1 sentence max.\n';
    final secondSystemPrompt =
        'You are assistant and your name is ${_secondCharacter.name}.\n'
        'You talking to User over dating app, and user\'s name is ${_firstCharacter.name}\n'
        'You and User are strangers\n'
        'talk like people talk over messenging app\n'
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

  void start() async {
    _continue = true;

    int count = 0;

    while (_continue && count < 5) {
      count++;
      if (_nextToReply == _firstCharacter) {
        final chatReply = await ChatProviderService.getChatCompletion(
          chatProvider: _firstCharacter.chatProvider,
          messages: _firstCharacterMessages,
          model: _firstCharacter.chatModelId,
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
            text: chatReply.messageContent,
            isMe: true,
            timestamp: DateTime.now(),
          ),
        );

        _nextToReply = _secondCharacter;
      } else {
        final chatReply = await ChatProviderService.getChatCompletion(
          chatProvider: _secondCharacter.chatProvider,
          messages: _secondCharacterMessages,
          model: _secondCharacter.chatModelId,
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
            text: chatReply.messageContent,
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );

        _nextToReply = _firstCharacter;
      }

      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void stop() async {
    _continue = false;
  }
}
