import 'character.dart';

class PlayerData {
  static final PlayerData _instance = PlayerData._internal();
  
  List<Character> characters = [];
  Character? selectedCharacter;

  factory PlayerData() {
    return _instance;
  }

  PlayerData._internal() {
    _initializeCharacters();
  }

  void _initializeCharacters() {
    characters = [
      Character(
        id: '1',
        name: 'Flameclaw',
        imagePath: 'lib/imeges/fire egg.png',
        type: 'Fire',
        xp: 0,
        level: 1,
      ),
      Character(
        id: '2',
        name: 'Aquastream',
        imagePath: 'lib/imeges/egg_3.png',
        type: 'Water',
        xp: 0,
        level: 1,
      ),
      Character(
        id: '3',
        name: 'Verdantus',
        imagePath: 'lib/imeges/egg_2.png',
        type: 'Grass',
        xp: 0,
        level: 1,
      ),
      Character(
        id: '4',
        name: 'Sparky',
        imagePath: 'lib/imeges/egg_electro_1.png',
        type: 'Electric',
        xp: 0,
        level: 1,
      ),
    ];
    selectedCharacter = characters[0];
  }

  Character? getCharacterById(String id) {
    try {
      return characters.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  void selectCharacter(String id) {
    final char = getCharacterById(id);
    if (char != null) {
      selectedCharacter = char;
    }
  }
}
