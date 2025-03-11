// lib/pages/controllers/characters_page_controller.dart
import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/model_services/character_model_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CharactersPageController {
  final CharacterModelService _characterService = CharacterModelService();
  final ValueNotifier<List<CharacterModel>> charactersNotifier =
      ValueNotifier<List<CharacterModel>>([]);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(true);

  CharactersPageController() {
    loadCharacters();
  }

  void dispose() {
    charactersNotifier.dispose();
    isLoadingNotifier.dispose();
  }

  Future<void> loadCharacters() async {
    isLoadingNotifier.value = true;

    try {
      final characters = await _characterService.getAllCharacterModels();
      charactersNotifier.value = characters;
    } catch (e) {
      debugPrint('Error loading characters: $e');
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  Future<bool> deleteCharacter(int index) async {
    final result = await _characterService.deleteCharacterModel(index);
    if (result) {
      await loadCharacters();
    }
    return result;
  }

  Future<CharacterModel?> getCharacterByIndex(int index) async {
    return _characterService.getCharacterModelByIndex(index);
  }
}
