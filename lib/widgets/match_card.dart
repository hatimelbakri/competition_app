import 'package:flutter/material.dart';
import '../models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;
  const MatchCard({super.key, required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(match.homeTeamLogo, width: 30),
        title: Text("${match.homeTeam} vs ${match.awayTeam}"),
        subtitle: Text(match.leagueName),
        trailing: Image.network(match.awayTeamLogo, width: 30),
        onTap: onTap,
      ),
    );
  }
}
