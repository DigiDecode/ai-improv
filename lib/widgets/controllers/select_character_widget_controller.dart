import 'package:ai_improv/model_services/character_model_service.dart';
import 'package:ai_improv/models/character_model.dart';
import 'package:flutter/material.dart';

class SelectCharacterWidgetController with ChangeNotifier {
  final CharacterModelService _characterService = CharacterModelService();

  List<CharacterModel> _characters = [];
  CharacterModel? _selectedCharacter;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<CharacterModel> get characters => _characters;
  CharacterModel? get selectedCharacter => _selectedCharacter;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasCharacters => _characters.isNotEmpty;

  // Initialize controller by loading characters
  Future<void> initialize() async {
    await loadCharacters();
  }

  // Load all characters from storage
  Future<void> loadCharacters() async {
    _setLoading(true);
    _clearError();

    try {
      _characters = await _characterService.getAllCharacterModels();

      // If there was a previously selected character, try to find it in the new list
      if (_selectedCharacter != null) {
        _selectedCharacter = _characters.firstWhere(
          (character) => character.id == _selectedCharacter!.id,
        );
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load characters: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Select a character by index
  void selectCharacter(int index) {
    if (index >= 0 && index < _characters.length) {
      _selectedCharacter = _characters[index];
      notifyListeners();
    } else {
      _setError('Invalid character index');
    }
  }

  // Select a character by id
  void selectCharacterById(String id) {
    try {
      _selectedCharacter = _characters.firstWhere(
        (character) => character.id == id,
      );
      notifyListeners();
    } catch (e) {
      _setError('Character not found');
    }
  }

  // Clear the current selection
  void clearSelection() {
    _selectedCharacter = null;
    notifyListeners();
  }

  // Helper methods for state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }
}
