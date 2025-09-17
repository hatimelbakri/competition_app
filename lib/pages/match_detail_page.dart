import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MatchDetailPage extends StatefulWidget {
  final int matchId;
  const MatchDetailPage({super.key, required this.matchId});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() async {
    final api = ApiService();
    data = await api.fetchMatchDetails(widget.matchId);
    setState(() => loading = false);
  }

@override
Widget build(BuildContext context) {
  if (loading) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  final fixture = data!['fixture'];
  final teams = data!['teams'];
  final stats = data!['statistics'] ?? [];
  final lineups = data!['lineups'] ?? [];

  return Scaffold(
    appBar: AppBar(title: Text("${teams['home']['name']} vs ${teams['away']['name']}")),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Stadium: ${fixture['venue']['name']}"),
          Text("City: ${fixture['venue']['city']}"),
          const Divider(),

          if (stats.length >= 2 &&
              stats[0]['statistics'].isNotEmpty &&
              stats[1]['statistics'].isNotEmpty)
            Text(
              "Possession: ${stats[0]['statistics'][0]['value']} - ${stats[1]['statistics'][0]['value']}",
              style: const TextStyle(fontSize: 16),
            )
          else
            const Text("Possession data not available"),

          const Divider(),

          const Text("Lineup Home:"),
          if (lineups.isNotEmpty && lineups[0]['startXI'] != null)
            ...lineups[0]['startXI'].map<Widget>((p) => Text("- ${p['player']['name']}")).toList()
          else
            const Text("No lineup available"),

          const Divider(),

          const Text("Lineup Away:"),
          if (lineups.length > 1 && lineups[1]['startXI'] != null)
            ...lineups[1]['startXI'].map<Widget>((p) => Text("- ${p['player']['name']}")).toList()
          else
            const Text("No lineup available"),
        ],
      ),
    ),
  );
}
}
