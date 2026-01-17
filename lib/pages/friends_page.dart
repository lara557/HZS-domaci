import 'package:flutter/material.dart';
import 'package:hzs_aplikacija/pages/challenge_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late List<FriendEntry> friends;

  @override
  void initState() {
    super.initState();
    friends = [
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
  }

  void _showAddFriendDialog() {
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Enter username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text.trim();
                if (username.isNotEmpty) {
                  // Add the friend
                  setState(() {
                    // Check if friend already exists
                    if (!friends.any((f) => f.name.toLowerCase() == username.toLowerCase())) {
                      friends.add(FriendEntry(
                        name: username,
                        imagePath: 'lib/imeges/Penguin_temp_img.png',
                        sport: 'General',
                        rank: 'E',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$username added as friend!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Friend already in list!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Friends',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: _showAddFriendDialog,
              icon: const Icon(
                Icons.person_add,
                color: Colors.black,
                size: 28,
              ),
              tooltip: 'Add Friend',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: friends.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No friends yet!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tap the + button to add friends',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
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
                    color: Colors.white,
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
                            ],
                          ),
                        ),
                        // Challenge button
                        IconButton(
                          onPressed: () {
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
                          icon: Image.asset(
                            'lib/imeges/Challenge.png',
                            width: 30,
                            height: 30,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.sports_esports,
                                color: Colors.blue,
                              );
                            },
                          ),
                        ),
                        // Rank
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _getRankColor(entry.rank),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              entry.rank,
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
