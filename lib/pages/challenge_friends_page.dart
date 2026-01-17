import 'package:flutter/material.dart';
import 'package:hzs_aplikacija/pages/challenge_page.dart';

class ChallengeFriendsPage extends StatelessWidget {
  const ChallengeFriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FriendEntry> friends = [
      FriendEntry(
        name: 'PunPun',
        imagePath: 'lib/imeges/Punpun.jpg',
        sport: 'Football',
        rank: 'C',
      ),
      FriendEntry(
        name: 'Melody',
        imagePath: 'lib/imeges/Melody.jpg',
        sport: 'Gym',
        rank: 'D',
      ),
      FriendEntry(
        name: 'Hello Kitty',
        imagePath: 'lib/imeges/Hello kitty.jpg',
        sport: 'Basketball',
        rank: 'B',
      ),
    ];

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
          'Challenge Friends',
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
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final entry = friends[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChallengePage(
                          friendName: entry.name,
                          friendImagePath: entry.imagePath,
                          friendRank: entry.rank,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.blue[50]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
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
                          // Photo on the left
                          Container(
                            width: 80,
                            height: 80,
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

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  entry.sport,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRankColor(entry.rank),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Rank ${entry.rank}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.sports_esports,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
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

class FriendEntry {
  final String name;
  final String imagePath;
  final String sport;
  final String rank;

  FriendEntry({
    required this.name,
    required this.imagePath,
    required this.sport,
    required this.rank,
  });
}
