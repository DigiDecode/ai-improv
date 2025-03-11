import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/widgets/controllers/select_character_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectCharacterWidget extends StatefulWidget {
  final void Function(CharacterModel)? onCharacterSelected;

  const SelectCharacterWidget({super.key, this.onCharacterSelected});

  @override
  State<SelectCharacterWidget> createState() => _SelectCharacterWidgetState();
}

class _SelectCharacterWidgetState extends State<SelectCharacterWidget> {
  late SelectCharacterWidgetController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SelectCharacterWidgetController();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<SelectCharacterWidgetController>(
        builder: (context, controller, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectButton(context, controller),
              const SizedBox(height: 16),
              if (controller.selectedCharacter != null)
                _buildCharacterDetails(controller.selectedCharacter!),
              if (controller.hasError)
                _buildErrorMessage(controller.errorMessage),
              if (controller.isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectButton(
    BuildContext context,
    SelectCharacterWidgetController controller,
  ) {
    return ElevatedButton(
      onPressed:
          controller.hasCharacters
              ? () => _showCharacterSelectionDialog(context)
              : null,
      child: const Text('Select Character'),
    );
  }

  Future<void> _showCharacterSelectionDialog(BuildContext context) async {
    final controller = Provider.of<SelectCharacterWidgetController>(
      context,
      listen: false,
    );
    final selectedIndex = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Character'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.characters.length,
              itemBuilder: (context, index) {
                final character = controller.characters[index];
                return ListTile(
                  title: Text(character.name),
                  subtitle: Text(
                    character.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.of(context).pop(index),
                  selected: controller.selectedCharacter?.id == character.id,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedIndex != null) {
      controller.selectCharacter(selectedIndex);

      if (widget.onCharacterSelected != null &&
          controller.selectedCharacter != null) {
        widget.onCharacterSelected!(controller.selectedCharacter!);
      }
    }
  }

  Widget _buildCharacterDetails(CharacterModel character) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _controller.clearSelection(),
                  tooltip: 'Clear selection',
                ),
              ],
            ),
            const Divider(),
            _buildDetailItem('Description', character.description),
            _buildDetailItem('Goal', character.goal),
            if (character.gender != null)
              _buildDetailItem('Gender', character.gender!),
            if (character.age != null) _buildDetailItem('Age', character.age!),
            _buildDetailItem(
              'Voice Provider',
              '${character.voiceProvider.provider} (${character.voiceProvider.voiceId})',
            ),
            _buildDetailItem(
              'Chat Provider',
              '${character.chatProvider.providerName} (${character.chatProvider.modelId})',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
