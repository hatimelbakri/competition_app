class Competition {
  final int id;
  final String name;
  final String country;
  final String? logo;

  Competition({
    required this.id,
    required this.name,
    required this.country,
    this.logo,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['league']['id'],
      name: json['league']['name'],
      country: json['country']['name'],
      logo: json['league']['logo'] as String?, // Add logo URL
    );
  }
}