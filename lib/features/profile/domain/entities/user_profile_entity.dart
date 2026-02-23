class UserProfileEntity {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;
  final bool isDarkMode;

  UserProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isDarkMode,
  });

  
  UserProfileEntity copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? createdAt,
    bool? isDarkMode,
  }) {
    return UserProfileEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}