import 'package:ai_improv/widgets/controllers/add_kokoro_provider_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddKokoroProviderWidget extends StatelessWidget {
  const AddKokoroProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddKokoroProviderWidgetController(),
      child: const _AddKokoroProviderView(),
    );
  }
}

class _AddKokoroProviderView extends StatelessWidget {
  const _AddKokoroProviderView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddKokoroProviderWidgetController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Kokoro Voice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: _buildLanguageDropdown(context, controller)),
                const SizedBox(width: 8),
                Expanded(child: _buildGenderDropdown(context, controller)),
              ],
            ),
          ),

          // List of voices
          Expanded(child: _buildVoicesList(context, controller)),

          // Selected voice info
          if (controller.selectedVoice != null)
            _buildSelectedVoiceInfo(context, controller),

          // Add button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    controller.isVoiceSelected
                        ? () async {
                          final success = await controller.addSelectedVoice();
                          if (success) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Voice added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to add voice'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                        : null,
                child: const Text('Add Selected Voice'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
    BuildContext context,
    AddKokoroProviderWidgetController controller,
  ) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Language',
        border: OutlineInputBorder(),
      ),
      value: controller.language,
      items:
          controller.availableLanguages
              .map(
                (lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(lang == 'all' ? 'All Languages' : lang),
                ),
              )
              .toList(),
      onChanged: (value) {
        if (value != null) {
          controller.setLanguage(value);
        }
      },
    );
  }

  Widget _buildGenderDropdown(
    BuildContext context,
    AddKokoroProviderWidgetController controller,
  ) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      value: controller.gender,
      items:
          controller.availableGenders
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender == 'all' ? 'All Genders' : gender),
                ),
              )
              .toList(),
      onChanged: (value) {
        if (value != null) {
          controller.setGender(value);
        }
      },
    );
  }

  Widget _buildVoicesList(
    BuildContext context,
    AddKokoroProviderWidgetController controller,
  ) {
    final filteredVoices = controller.filteredVoices;

    if (filteredVoices.isEmpty) {
      return const Center(child: Text('No voices match the selected filters'));
    }

    return ListView.builder(
      itemCount: filteredVoices.length,
      itemBuilder: (context, index) {
        final voice = filteredVoices[index];
        final isSelected = controller.selectedVoice?.voiceId == voice.voiceId;

        return ListTile(
          title: Text(voice.name),
          subtitle: Text(
            '${voice.language} | ${voice.gender} | Grade: ${voice.overallGrade}',
          ),
          trailing:
              voice.traits != null
                  ? Text(voice.traits!, style: const TextStyle(fontSize: 20))
                  : null,
          selected: isSelected,
          selectedTileColor: Colors.blue.withOpacity(0.1),
          onTap: () => controller.selectVoice(voice),
        );
      },
    );
  }

  Widget _buildSelectedVoiceInfo(
    BuildContext context,
    AddKokoroProviderWidgetController controller,
  ) {
    final voice = controller.selectedVoice!;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Voice: ${voice.name}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text('Language: ${voice.language}'),
          Text('Gender: ${voice.gender}'),
          Text('Voice ID: ${voice.voiceId}'),
          Text('Quality Grade: ${voice.overallGrade}'),
          if (voice.traits != null) Text('Traits: ${voice.traits}'),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Kokoro Voices'),
            content: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kokoro is an in-browser text-to-speech system that requires no API key.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Voice Grade Information:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• A grade: High quality, natural sounding'),
                  Text('• B grade: Good quality with minor issues'),
                  Text('• C grade: Acceptable but noticeable artificiality'),
                  Text('• D grade: Poor quality with significant issues'),
                  SizedBox(height: 8),
                  Text(
                    'Special voices with emoji indicators (❤️, 🔥, etc.) are recommended for best results.',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
