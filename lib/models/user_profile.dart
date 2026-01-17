class UserProfile {
  static final UserProfile _instance = UserProfile._internal();
  
  String name;
  String email;
  String? selectedSport;
  String? city;
  String? bio;
  String id; // Unique identifier for the user

  factory UserProfile() {
    return _instance;
  }

  UserProfile._internal()
      : name = '',
        email = '',
        id = 'player_me',
        selectedSport = null,
        city = 'New York',
        bio = 'Passionate athlete and sports enthusiast. Love competing and improving my skills.';

  // Initialize user profile with signup data
  void initializeProfile({
    required String name,
    required String email,
  }) {
    this.name = name;
    this.email = email;
    id = 'player_me';
  }

  // Update user profile
  void updateProfile({
    String? name,
    String? email,
    String? sport,
    String? city,
    String? bio,
  }) {
    if (name != null && name.isNotEmpty) this.name = name;
    if (email != null && email.isNotEmpty) this.email = email;
    if (sport != null) selectedSport = sport;
    if (city != null) this.city = city;
    if (bio != null) this.bio = bio;
  }

  // Check if profile is initialized
  bool get isInitialized => name.isNotEmpty && email.isNotEmpty;

  // Get profile as map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'sport': selectedSport,
      'city': city,
      'bio': bio,
      'id': id,
    };
  }
}
