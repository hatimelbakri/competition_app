class Player {
  final int id;
  final String name;
  final int? age;
  final String? position;
  final String? photo;

  Player({
    required this.id,
    required this.name,
    this.age,
    this.position,
    this.photo,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown Player',
      age: json['age'] as int?,
      position: json['position'] as String?,
      photo: json['photo'] as String?, // Add photo URL
    );
  }
}