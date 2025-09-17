import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../models/match.dart';
import 'match_detail_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Match> all = [];
  List<Match> upcoming = [];
  List<Match> finished = [];
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    all = await _api.fetchMatches();
    upcoming = await _api.fetchMatchesByStatus('NS');
    finished = await _api.fetchMatchesByStatus('FT');
    setState(() {});
  }

  Widget _buildMatchList(List<Match> matches) {
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final m = matches[index];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: m.homeTeamLogo,
            width: 30,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
          ),
          title: Text("${m.homeTeam} vs ${m.awayTeam}"),
          subtitle: Text(m.leagueName),
          trailing: CachedNetworkImage(
            imageUrl: m.awayTeamLogo,
            width: 30,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => MatchDetailPage(matchId: m.id),
            ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matches"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Upcoming"),
            Tab(text: "Finished"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMatchList(all),
          _buildMatchList(upcoming),
          _buildMatchList(finished),
        ],
      ),
    );
  }
}
