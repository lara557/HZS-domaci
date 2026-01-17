import 'user_profile.dart';

class LeaderboardEntry {
  final String id;
  String name;
  int xp;
  String imagePath;
  String sport;
  int rank; // Position in leaderboard
  bool isCurrentPlayer; // Flag to identify current player

  LeaderboardEntry({
    required this.id,
    required this.name,
    required this.xp,
    required this.imagePath,
    required this.sport,
    required this.rank,
    this.isCurrentPlayer = false,
  });

  // Calculate rank tier based on XP (10x harder)
  String getRankTier() {
    if (xp >= 5000) return 'S';
    if (xp >= 4000) return 'A';
    if (xp >= 3000) return 'B';
    if (xp >= 2000) return 'C';
    if (xp >= 1000) return 'D';
    return 'E';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'xp': xp,
      'rank': rank,
    };
  }
}

class Leaderboard {
  static final Leaderboard _instance = Leaderboard._internal();
  
  List<LeaderboardEntry> entries = [];

  factory Leaderboard() {
    return _instance;
  }

  Leaderboard._internal() {
    _initializeLeaderboard();
  }

  void _initializeLeaderboard() {
    final userProfile = UserProfile();
    
    entries = [
      // Current player at index 0 initially
      LeaderboardEntry(
        id: 'player_me',
        name: userProfile.isInitialized ? userProfile.name : 'You',
        xp: 0,
        imagePath: 'lib/imeges/Penguin_temp_img.png',
        sport: userProfile.selectedSport ?? 'General',
        rank: 1,
        isCurrentPlayer: true,
      ),
      LeaderboardEntry(
        id: 'player1',
        name: 'Kuromi',
        xp: 5100,
        imagePath: 'lib/imeges/Kuromi.jpg',
        sport: 'Tennis',
        rank: 2,
      ),
      LeaderboardEntry(
        id: 'player2',
        name: 'Cinemon Roll',
        xp: 4200,
        imagePath: 'lib/imeges/Cinemon roll.jpg',
        sport: 'Running',
        rank: 3,
      ),
      LeaderboardEntry(
        id: 'player3',
        name: 'Hello Kitty',
        xp: 3500,
        imagePath: 'lib/imeges/Hello kitty.jpg',
        sport: 'Basketball',
        rank: 4,
      ),
      LeaderboardEntry(
        id: 'player4',
        name: 'PunPun',
        xp: 2500,
        imagePath: 'lib/imeges/Punpun.jpg',
        sport: 'Football',
        rank: 5,
      ),
      LeaderboardEntry(
        id: 'player5',
        name: 'Melody',
        xp: 1500,
        imagePath: 'lib/imeges/Melody.jpg',
        sport: 'Gym',
        rank: 6,
      ),
      LeaderboardEntry(
        id: 'player6',
        name: 'Pochi',
        xp: 500,
        imagePath: 'lib/imeges/Pochi.jpg',
        sport: 'Tennis',
        rank: 7,
      ),
    ];
  }

  // Add XP to a player
  void addXpToPlayer(String playerId, int amount) {
    try {
      final player = entries.firstWhere((e) => e.id == playerId);
      player.xp += amount;
      _sortAndUpdateRanks();
    } catch (e) {
      // Player not found
    }
  }

  // Sort by XP and update ranks
  void _sortAndUpdateRanks() {
    entries.sort((a, b) => b.xp.compareTo(a.xp));
    for (int i = 0; i < entries.length; i++) {
      entries[i].rank = i + 1;
    }
  }

  // Get player by ID
  LeaderboardEntry? getPlayerById(String id) {
    try {
      return entries.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get current player
  LeaderboardEntry? getCurrentPlayer() {
    try {
      return entries.firstWhere((e) => e.isCurrentPlayer);
    } catch (e) {
      return null;
    }
  }

  // Get sorted entries
  List<LeaderboardEntry> getSortedEntries() {
    _sortAndUpdateRanks();
    return entries;
  }
}
