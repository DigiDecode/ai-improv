import 'dart:convert';
import 'package:ai_improv/models/tts_provider_model.dart';

import 'chat_provider_model.dart';

class CharacterModel {
  final String name;
  final String description;
  final String goal;
  final TTSProviderModel voiceProvider;
  final String voiceModelId;
  final String voiceId;
  final ChatProviderModel chatProvider;
  final String chatModelId;

  CharacterModel({
    required this.name,
    required this.description,
    required this.goal,
    required this.voiceProvider,
    required this.voiceModelId,
    required this.voiceId,
    required this.chatProvider,
    required this.chatModelId,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      goal: json['goal'] ?? '',
      voiceProvider: TTSProviderModel.fromJson(json['voiceProvider']),
      voiceModelId: json['voiceModelId'] ?? '',
      voiceId: json['voiceId'] ?? '',
      chatProvider: ChatProviderModel.fromJson(json['chatProvider']),
      chatModelId: json['chatModelId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'goal': goal,
      'voiceProvider': voiceProvider.toJson(),
      'voiceModelId': voiceModelId,
      'voiceId': voiceId,
      'chatProvider': chatProvider.toJson(),
      'chatModelId': chatModelId,
    };
  }

  CharacterModel copyWith({
    String? name,
    String? description,
    String? goal,
    TTSProviderModel? voiceProvider,
    String? voiceModelId,
    String? voiceId,
    ChatProviderModel? chatProvider,
    String? chatModelId,
  }) {
    return CharacterModel(
      name: name ?? this.name,
      description: description ?? this.description,
      goal: goal ?? this.goal,
      voiceProvider: voiceProvider ?? this.voiceProvider,
      voiceModelId: voiceModelId ?? this.voiceModelId,
      voiceId: voiceId ?? this.voiceId,
      chatProvider: chatProvider ?? this.chatProvider,
      chatModelId: chatModelId ?? this.chatModelId,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
