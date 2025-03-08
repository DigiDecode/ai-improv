import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/services/chat_provider_service.dart';

class DialogueService {
  bool _continue = false;
  CharacterModel _firstCharacter;
  final _firstCharacterMessages = List<ChatMessage>.empty();

  CharacterModel _secondCharacter;
  final _secondCharacterMessages = List<ChatMessage>.empty();

  CharacterModel? _nextToReply;

  DialogueService(this._firstCharacter, this._secondCharacter) {
    _nextToReply = _firstCharacter;
  }

  void start() async {
    _continue = true;
    final firstSystemPrompt =
        'You are assistant and your name is ${_firstCharacter.name}.'
        'You talking to User, and user\'s name is ${_secondCharacter.name}'
        'Your goal is below:'
        '${_firstCharacter.goal}'
        'It is important that your reply is short & not more than 2 sentences.';
    final secondSystemPrompt =
        'You are assistant and your name is ${_secondCharacter.name}.'
        'You talking to User, and user\'s name is ${_firstCharacter.name}'
        'Your goal is below:'
        '${_secondCharacter.goal}'
        'It is important that your reply is short & not more than 2 sentences.';

    while (_continue) {
      if (_nextToReply == _firstCharacter) {
        _nextToReply = _secondCharacter;
      } else {
        _nextToReply = _firstCharacter;
      }
    }
  }

  void stop() async {
    _continue = false;
  }
}
