// lib/widgets/add_character_widget.dart
import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/widgets/add_kokoro_provider_widget.dart';
import 'package:ai_improv/widgets/controllers/add_character_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCharacterWidget extends StatelessWidget {
  final bool isEditing;
  final CharacterModel? initialCharacter;
  final int? index;

  const AddCharacterWidget({
    super.key,
    this.isEditing = false,
    this.initialCharacter,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => AddCharacterWidgetController(
            isEditing: isEditing,
            initialCharacter: initialCharacter,
            index: index,
          ),
      child: const _AddCharacterView(),
    );
  }
}

class _AddCharacterView extends StatelessWidget {
  const _AddCharacterView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddCharacterWidgetController>(context);
    final isPortrait = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditing ? 'Edit Character' : 'Create a Character',
        ),
        actions: [
          if (!isPortrait)
            TextButton.icon(
              onPressed:
                  controller.canSubmit && !controller.isLoading
                      ? () => _saveCharacter(context, controller)
                      : null,
              icon:
                  controller.isLoading
                      ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.save),
              label: const Text('Save'),
            ),
        ],
      ),
      body:
          controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : isPortrait
              ? _buildPortraitLayout(context, controller)
              : _buildLandscapeLayout(context, controller),
      floatingActionButton:
          isPortrait
              ? FloatingActionButton.extended(
                onPressed:
                    controller.canSubmit && !controller.isLoading
                        ? () => _saveCharacter(context, controller)
                        : null,
                icon: const Icon(Icons.save),
                label: Text(
                  controller.isEditing ? 'Update Character' : 'Save Character',
                ),
              )
              : null,
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    AddCharacterWidgetController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCharacterForm(context, controller),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          _buildVoiceProviderSection(context, controller),
          const SizedBox(height: 16),
          _buildChatProviderSection(context, controller),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    AddCharacterWidgetController controller,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildCharacterForm(context, controller),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVoiceProviderSection(context, controller),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildChatProviderSection(context, controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterForm(
    BuildContext context,
    AddCharacterWidgetController controller,
  ) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.nameController,
            decoration: const InputDecoration(
              labelText: 'Character Name *',
              border: OutlineInputBorder(),
              hintText: 'Enter a name for your character',
            ),
            maxLength: 50,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onChanged: (_) => controller.notifyListeners(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description *',
              border: OutlineInputBorder(),
              hintText: 'Describe your character',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            maxLength: 500,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            onChanged: (_) => controller.notifyListeners(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.goalController,
            decoration: const InputDecoration(
              labelText: 'Goal/Motivation *',
              border: OutlineInputBorder(),
              hintText: "What is your character's goal?",
            ),
            maxLines: 2,
            maxLength: 200,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the character's goal";
              }
              return null;
            },
            onChanged: (_) => controller.notifyListeners(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 30, Young adult, etc.',
                  ),
                  onChanged: (_) => controller.notifyListeners(),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gender (Optional)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ToggleButtons(
                    isSelected: [
                      controller.selectedGender == Gender.male,
                      controller.selectedGender == Gender.female,
                      controller.selectedGender == Gender.other,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          controller.setGender(Gender.male);
                          break;
                        case 1:
                          controller.setGender(Gender.female);
                          break;
                        case 2:
                          controller.setGender(Gender.other);
                          break;
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.male),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.female),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.person),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceProviderSection(
    BuildContext context,
    AddCharacterWidgetController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Voice Provider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddKokoroProviderWidget(),
                  ),
                ).then((_) => controller.loadVoiceProviders());
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Voice'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (controller.isLoadingVoices)
          const Center(child: CircularProgressIndicator())
        else if (controller.voiceProviders.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No voice providers available. Add one to continue.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.voiceProviders.length,
                itemBuilder: (context, index) {
                  final provider = controller.voiceProviders[index];
                  final isSelected =
                      controller.selectedVoiceProvider?.voiceId ==
                      provider.voiceId;

                  return ListTile(
                    title: Text(provider.voiceName ?? 'Unknown Voice'),
                    subtitle: Text(
                      'Provider: ${provider.providerName ?? 'Unknown'}',
                    ),
                    trailing:
                        isSelected ? const Icon(Icons.check_circle) : null,
                    selected: isSelected,
                    onTap: () => controller.setVoiceProvider(provider),
                  );
                },
              ),
            ),
          ),
        if (controller.selectedVoiceProvider != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected: ${controller.selectedVoiceProvider!.voiceName ?? 'Unknown'} (${controller.selectedVoiceProvider!.providerName ?? 'Unknown provider'})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildChatProviderSection(
    BuildContext context,
    AddCharacterWidgetController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Chat Model',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Add button for new chat provider (to be implemented later)
          ],
        ),
        const SizedBox(height: 8),
        if (controller.isLoadingChatModels)
          const Center(child: CircularProgressIndicator())
        else if (controller.chatProviders.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No chat models available.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.chatProviders.length,
                itemBuilder: (context, index) {
                  final provider = controller.chatProviders[index];
                  final isSelected =
                      controller.selectedChatProvider?.modelName ==
                      provider.modelName;

                  return ListTile(
                    title: Text(provider.modelName ?? 'Unknown Model'),
                    subtitle: Text(
                      'Provider: ${provider.providerName ?? 'Unknown'}',
                    ),
                    trailing:
                        isSelected ? const Icon(Icons.check_circle) : null,
                    selected: isSelected,
                    onTap: () => controller.setChatProvider(provider),
                  );
                },
              ),
            ),
          ),
        if (controller.selectedChatProvider != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected: ${controller.selectedChatProvider!.modelName ?? 'Unknown'} (${controller.selectedChatProvider!.providerName ?? 'Unknown provider'})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  void _saveCharacter(
    BuildContext context,
    AddCharacterWidgetController controller,
  ) async {
    if (controller.formKey.currentState?.validate() ?? false) {
      final success =
          controller.isEditing
              ? await controller.updateCharacter()
              : await controller.saveCharacter();

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                controller.isEditing
                    ? 'Character updated successfully!'
                    : 'Character created successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                controller.isEditing
                    ? 'Failed to update character. Please try again.'
                    : 'Failed to create character. Please try again.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
