class Character {
  final String id;
  final String name;
  String imagePath;
  final String type; // Fire, Water, Grass, Electric
  int xp;
  int level;
  int evolution; // 0 = egg, 1 = first form, 2 = second form, etc.
  bool hasEvolved; // Flag to track if evolution notification has been shown

  Character({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.type,
    this.xp = 0,
    this.level = 1,
    this.evolution = 0,
    this.hasEvolved = false,
  });

  // Fixed 100 XP per level
  static const int xpPerLevel = 100;

  // Check if character can level up
  bool canLevelUp() => xp >= xpPerLevel;

  // Check if character should evolve (every 5 levels)
  bool shouldEvolve() => level > 0 && level % 5 == 0 && !hasEvolved && evolution < 3;

  // Add XP to character
  List<bool> addXp(int amount) {
    xp += amount;
    List<bool> evolutionTriggered = [];
    
    while (canLevelUp()) {
      xp -= xpPerLevel;
      level++;
      
      // Check for evolution
      if (shouldEvolve()) {
        evolution++;
        hasEvolved = true;
        _updateImageForEvolution();
        evolutionTriggered.add(true);
      } else {
        hasEvolved = false;
      }
    }
    
    return evolutionTriggered;
  }

  // Update image based on evolution
  void _updateImageForEvolution() {
    // Map type to evolution image prefix
    String typePrefix = '';
    switch (type) {
      case 'Fire':
        typePrefix = 'fire_evolution_';
        break;
      case 'Water':
        typePrefix = 'water_evolution_';
        break;
      case 'Grass':
        typePrefix = 'grass_evolution_';
        break;
      case 'Electric':
        typePrefix = 'electric_evolution_';
        break;
      default:
        typePrefix = 'evolution_';
    }
    
    // Update image path with evolution number
    imagePath = 'lib/imeges/${typePrefix}${evolution}.png';
  }

  // Get evolution stage name
  String getEvolutionStage() {
    switch (evolution) {
      case 0:
        return 'Egg';
      case 1:
        return 'Form 1';
      case 2:
        return 'Form 2';
      case 3:
        return 'Form 3';
      default:
        return 'Unknown';
    }
  }

  // Get character stats as a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'xp': xp,
      'level': level,
      'evolution': evolution,
    };
  }
}
