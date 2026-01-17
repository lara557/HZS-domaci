import 'package:flutter/material.dart';
import 'package:hzs_aplikacija/models/player_data.dart';
import 'package:hzs_aplikacija/models/leaderboard.dart';

class ChallengePage extends StatefulWidget {
  final String friendName;
  final String friendImagePath;
  final String friendRank;

  const ChallengePage({
    super.key,
    required this.friendName,
    required this.friendImagePath,
    required this.friendRank,
  });

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  late PlayerData playerData;
  late Leaderboard leaderboard;
  bool battleStarted = false;
  bool? playerWon;
  int xpGained = 0;

  @override
  void initState() {
    super.initState();
    playerData = PlayerData();
    leaderboard = Leaderboard();
  }

  void startBattle() {
    setState(() {
      battleStarted = true;
      // Simulate battle - 50/50 chance for now
      playerWon = DateTime.now().millisecond % 2 == 0;
      
      if (playerWon!) {
        xpGained = 50; // Base XP reward
        final evolutionTriggered = playerData.selectedCharacter?.addXp(xpGained) ?? [];
        // Update your XP in the leaderboard
        leaderboard.addXpToPlayer('player_me', xpGained);
        // Also update the friend's XP in the leaderboard
        leaderboard.addXpToPlayer(widget.friendName.toLowerCase(), 20);
        
        // Show evolution notification if triggered
        if (evolutionTriggered.isNotEmpty && evolutionTriggered[0]) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showEvolutionNotification();
          });
        }
      } else {
        xpGained = 20; // Consolation XP
        final evolutionTriggered = playerData.selectedCharacter?.addXp(xpGained) ?? [];
        // Update your XP in the leaderboard
        leaderboard.addXpToPlayer('player_me', xpGained);
        // Friend gets XP for winning
        leaderboard.addXpToPlayer(widget.friendName.toLowerCase(), 40);
        
        // Show evolution notification if triggered
        if (evolutionTriggered.isNotEmpty && evolutionTriggered[0]) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showEvolutionNotification();
          });
        }
      }
    });
  }

  void _showEvolutionNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            '🎉 Congratulations! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your ${playerData.selectedCharacter?.name ?? 'Character'} has evolved!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Stage: ${playerData.selectedCharacter?.getEvolutionStage() ?? 'Unknown'}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 40,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text(
                  'Awesome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void resetBattle() {
    setState(() {
      battleStarted = false;
      playerWon = null;
      xpGained = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCharacter = playerData.selectedCharacter;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 177, 243),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 70, 177, 243),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Challenge Battle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (!battleStarted) ...[
                const Text(
                  'Select Your Character',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Your Character
                _buildCharacterCard(
                  name: selectedCharacter?.name ?? 'Unknown',
                  imagePath: selectedCharacter?.imagePath ?? '',
                  level: selectedCharacter?.level ?? 1,
                  type: selectedCharacter?.type ?? 'Unknown',
                  isEnemy: false,
                ),
                const SizedBox(height: 30),
                const Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                // Enemy Character (Friend)
                _buildCharacterCard(
                  name: widget.friendName,
                  imagePath: widget.friendImagePath,
                  level: 10,
                  type: 'Unknown',
                  isEnemy: true,
                ),
                const SizedBox(height: 40),
                // Battle Button
                ElevatedButton.icon(
                  onPressed: startBattle,
                  icon: const Icon(Icons.flash_on),
                  label: const Text(
                    'Start Battle!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ] else ...[
                // Battle Result Screen
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: playerWon! ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              playerWon!
                                  ? Icons.emoji_events
                                  : Icons.close_rounded,
                              color: Colors.white,
                              size: 80,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              playerWon! ? 'YOU WON!' : 'YOU LOST!',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '+$xpGained XP',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${selectedCharacter?.name} gained $xpGained XP!',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Level: ${selectedCharacter?.level} | Total XP: ${selectedCharacter?.xp}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: resetBattle,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Battle Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterCard({
    required String name,
    required String imagePath,
    required int level,
    required String type,
    required bool isEnemy,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              isEnemy ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.pets,
                        size: 60,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Level $level',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
