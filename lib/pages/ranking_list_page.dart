import 'package:flutter/material.dart';
import 'package:hzs_aplikacija/models/leaderboard.dart';

class RankingListPage extends StatefulWidget {
  const RankingListPage({super.key});

  @override
  State<RankingListPage> createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage> {
  late Leaderboard leaderboard;

  @override
  void initState() {
    super.initState();
    leaderboard = Leaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final sortedRankings = leaderboard.getSortedEntries();

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
          'Ranking List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: sortedRankings.length,
            itemBuilder: (context, index) {
              final entry = sortedRankings[index];
              final rankTier = entry.getRankTier();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: entry.isCurrentPlayer ? Colors.amber.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: entry.isCurrentPlayer
                        ? Border.all(color: Colors.amber, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        // Rank Number
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _getRankColor(rankTier),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.rank}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              entry.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Name and Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entry.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (entry.isCurrentPlayer)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Text(
                                          'YOU',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                entry.sport,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getRankColor(rankTier)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'Tier $rankTier',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _getRankColor(rankTier),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${entry.xp} XP',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Rank Tier Box
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _getRankColor(rankTier),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              rankTier,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank) {
      case 'S':
        return const Color.fromARGB(255, 255, 59, 48);
      case 'A':
        return const Color.fromARGB(255, 255, 152, 0);
      case 'B':
        return const Color.fromARGB(255, 76, 175, 80);
      case 'C':
        return const Color.fromARGB(255, 33, 150, 243);
      case 'D':
        return const Color.fromARGB(255, 156, 39, 176);
      case 'E':
        return const Color.fromARGB(255, 158, 158, 158);
      default:
        return Colors.grey;
    }
  }
}

class RankEntry {
  final String name;
  final String rank;
  final String imagePath;
  final String sport;

  RankEntry({
    required this.name,
    required this.rank,
    required this.imagePath,
    required this.sport,
  });
}
