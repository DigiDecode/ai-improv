// lib/pages/characters_page.dart
import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/pages/controllers/characters_page_controller.dart';
import 'package:ai_improv/widgets/add_character_widget.dart';
import 'package:flutter/material.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final CharactersPageController _controller = CharactersPageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: _controller.isLoadingNotifier,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<CharacterModel>>(
            valueListenable: _controller.charactersNotifier,
            builder: (context, characters, _) {
              if (characters.isEmpty) {
                return const Center(
                  child: Text(
                    'No characters created yet',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return CharacterCard(
                    character: character,
                    onDelete:
                        () => _showDeleteConfirmationDialog(context, index),
                    onEdit:
                        () =>
                            _navigateToEditCharacter(context, index, character),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddCharacter(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Character'),
          content: const Text(
            'Are you sure you want to delete this character?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final result = await _controller.deleteCharacter(index);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result
                            ? 'Character deleted successfully'
                            : 'Failed to delete character',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddCharacter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCharacterWidget()),
    ).then((_) {
      // Refresh the list when returning from the add page
      _controller.loadCharacters();
    });
  }

  void _navigateToEditCharacter(
    BuildContext context,
    int index,
    CharacterModel character,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddCharacterWidget(
              isEditing: true,
              initialCharacter: character,
              index: index,
            ),
      ),
    ).then((_) {
      // Refresh the list when returning from the edit page
      _controller.loadCharacters();
    });
  }
}

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Description', character.description),
            _buildInfoRow('Goal', character.goal),
            if (character.gender != null && character.gender!.isNotEmpty)
              _buildInfoRow('Gender', character.gender!),
            if (character.age != null && character.age!.isNotEmpty)
              _buildInfoRow('Age', character.age!),
            const Divider(),
            _buildInfoRow(
              'Voice',
              '${character.voiceProvider.voiceName ?? 'Unknown'} (${character.voiceProvider.providerName ?? 'Unknown provider'})',
            ),
            _buildInfoRow(
              'Chat Model',
              character.chatProvider.modelName ?? 'Unknown',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
