class Match {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final String leagueName;
  final String homeTeamLogo;
  final String awayTeamLogo;

  Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.leagueName,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['fixture']['id'],
      homeTeam: json['teams']['home']['name'],
      awayTeam: json['teams']['away']['name'],
      leagueName: json['league']['name'],
      homeTeamLogo: json['teams']['home']['logo'],
      awayTeamLogo: json['teams']['away']['logo'],
    );
  }
}
