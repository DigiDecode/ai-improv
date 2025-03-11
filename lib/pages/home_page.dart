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
    // Initialize the controller with the scenario from the provider
    final homeState = Provider.of<HomeStateProvider>(context, listen: false);
    _scenarioController.text = homeState.scenarioText;
  }

  @override
  Widget build(BuildContext context) {
    // Get the persisted state details from the provider.
    final homeState = Provider.of<HomeStateProvider>(context);

    // Keep the text controller in sync with the provider
    if (_scenarioController.text != homeState.scenarioText) {
      _scenarioController.text = homeState.scenarioText;
    }

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
                      const Text(
                        'Scenario Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          controller: _scenarioController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter scenario details here...',
                            // border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromARGB(10, 255, 255, 255),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            homeState.setScenario(_scenarioController.text);
                          },
                          child: const Text('Apply Scenario'),
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
