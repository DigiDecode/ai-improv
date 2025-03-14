// lib/pages/home_page.dart
import 'package:ai_improv/pages/providers/home_state_provider.dart';
import 'package:ai_improv/widgets/chat_widget.dart';
import 'package:ai_improv/widgets/select_character_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _scenarioController = TextEditingController();

  @override
  void dispose() {
    _scenarioController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final homeState = Provider.of<HomeStateProvider>(context, listen: false);
    homeState.controller.initialize(context);
  }

  // Show dialog for scenario editing
  // lib/pages/home_page.dart
  void _showScenarioEditDialog() {
    final homeState = Provider.of<HomeStateProvider>(context, listen: false);
    _scenarioController.text = homeState.scenarioText;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Scenario',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TextField(
                    controller: _scenarioController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter scenario details here...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(10, 255, 255, 255),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        homeState.setScenario(_scenarioController.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the persisted state details from the provider.
    final homeState = Provider.of<HomeStateProvider>(context);

    return Column(
      children: [
        // Top row (70% of screen)
        Expanded(
          flex: 7,
          child: Row(
            children: [
              // First column (25%) - First character selection
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'First Character',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectCharacterWidget(
                        // Pass the initially selected first character from provider.
                        initialCharacter: homeState.firstCharacter,
                        // When a character is selected, update the state via the provider.
                        onCharacterSelected: (character) {
                          Provider.of<HomeStateProvider>(
                            context,
                            listen: false,
                          ).setFirstCharacter(character);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Second column (50%) - Chat area
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            homeState.resetChat();
                          },
                          child: const Text('Reset chat'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ChatWidget(
                        controller: homeState.controller.chatController,
                      ),
                    ),
                  ],
                ),
              ),
              // Third column (25%) - Second character selection
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Second Character',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectCharacterWidget(
                        // Pass the initially selected second character from provider.
                        initialCharacter: homeState.secondCharacter,
                        onCharacterSelected: (character) {
                          Provider.of<HomeStateProvider>(
                            context,
                            listen: false,
                          ).setSecondCharacter(character);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom row (30% of screen)
        Expanded(
          flex: 3,
          child: Row(
            children: [
              // First column (75%) - Scenario Description
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Scenario Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _showScenarioEditDialog,
                            child: const Text('Change Scenario'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(10, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              homeState.scenarioText.isEmpty
                                  ? 'No scenario set. Click "Change Scenario" to add one.'
                                  : homeState.scenarioText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Second column (25%) - Start/Stop Dialogue
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    // Enable the button only if both characters are selected.
                    onPressed:
                        (homeState.firstCharacter != null &&
                                homeState.secondCharacter != null)
                            ? () {
                              homeState.toggleStartStop();
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(homeState.isStarted ? 'Stop' : 'Start'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
