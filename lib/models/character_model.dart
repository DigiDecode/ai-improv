// lib/models/character_model.dart
import 'dart:convert';
import 'package:ai_improv/models/tts_provider_model.dart';
import 'package:uuid/uuid.dart';

import 'chat_provider_model.dart';

class CharacterModel {
  final String id;
  final String name;
  final String description;
  final String goal;
  final TTSProviderModel voiceProvider;
  final ChatProviderModel chatProvider;
  final String? gender;
  final String? age;

  CharacterModel({
    String? id,
    required this.name,
    required this.description,
    required this.goal,
    required this.voiceProvider,
    required this.chatProvider,
    this.gender,
    this.age,
  }) : id = id ?? const Uuid().v4();

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? const Uuid().v4(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      goal: json['goal'] ?? '',
      voiceProvider: TTSProviderModel.fromJson(json['voiceProvider']),
      chatProvider: ChatProviderModel.fromJson(json['chatProvider']),
      gender: json['gender'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'goal': goal,
      'voiceProvider': voiceProvider.toJson(),
      'chatProvider': chatProvider.toJson(),
      'gender': gender,
      'age': age,
    };
  }

  CharacterModel copyWith({
    String? id,
    String? name,
    String? description,
    String? goal,
    TTSProviderModel? voiceProvider,
    ChatProviderModel? chatProvider,
    String? gender,
    String? age,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      goal: goal ?? this.goal,
      voiceProvider: voiceProvider ?? this.voiceProvider,
      chatProvider: chatProvider ?? this.chatProvider,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
