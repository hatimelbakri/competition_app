class Team {
  final int id;
  final String name;
  final String logo;
  final String? city;
  double? latitude;
  double? longitude;

  Team({
    required this.id,
    required this.name,
    required this.logo,
    this.city,
    this.latitude,
    this.longitude,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['team']['id'] as int? ?? 0,
      name: json['team']['name'] as String? ?? 'Unknown Team',
      logo: json['team']['logo'] as String? ?? '',
      city: json['venue']?['city'] as String?,
      latitude: null, // Will be set by OpenCage API
      longitude: null, // Will be set by OpenCage API
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'logo': logo,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
  };
}