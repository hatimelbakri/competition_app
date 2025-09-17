import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/competition.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _api = ApiService();

  String _searchType = 'Player'; // Default search type
  List<dynamic> _results = [];
  bool loading = false;

  void _search() async {
    if (_controller.text.isEmpty) return;
    setState(() => loading = true);

    List<dynamic> data = [];
    try {
      switch (_searchType) {
        case 'Team':
          data = await _api.searchTeams(_controller.text);
          break;
        case 'Player':
          data = await _api.searchPlayers(_controller.text);
          break;
        case 'Competition':
          data = await _api.searchCompetitions(_controller.text);
          break;
      }
    } catch (e) {
      print('Search error: $e');
    } finally {
      setState(() {
        _results = data;
        loading = false;
      });
    }
  }

  /// Helper for fallback player image
  String _getPlayerImage(Player player) {
    if (player.photo != null && player.photo!.startsWith('http')) {
      return player.photo!;
    } else {
      // Try to use fallback image from a known source (Wikipedia user icon)
      return 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
    }
  }

  Widget _buildResultItem(dynamic item) {
    if (item is Team) {
      return ListTile(
        leading: Image.network(item.logo, width: 30),
        title: Text(item.name),
        subtitle: Text(item.city ?? 'N/A'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(item: item)),
        ),
      );
    } else if (item is Player) {
      final imageUrl = _getPlayerImage(item);

      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 25,
          onBackgroundImageError: (_, __) {
            // fallback handled by the default CircleAvatar behavior
          },
        ),
        title: Text(item.name),
        subtitle: Text(
          'Age: ${item.age ?? 'N/A'} | Position: ${item.position ?? 'N/A'}',
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(item: item)),
        ),
      );
    } else if (item is Competition) {
      return ListTile(
        leading: CachedNetworkImage(
          imageUrl: item.logo ?? '',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.emoji_events),
        ),
        title: Text(item.name),
        subtitle: Text(item.country ?? 'N/A'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(item: item)),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _search),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter name...',
                      labelText: 'Search',
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _searchType,
                  items: const [
                    DropdownMenuItem(value: 'Player', child: Text('Players')),
                    DropdownMenuItem(value: 'Team', child: Text('Teams')),
                    DropdownMenuItem(
                        value: 'Competition', child: Text('Competitions')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _searchType = value;
                        _results.clear();
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: _results.isEmpty && !loading
                ? const Center(child: Text('No results found'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) =>
                        _buildResultItem(_results[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
