import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for image loading
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/competition.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final List<dynamic> favs = favProvider.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favs.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final dynamic item = favs[index];
                return ListTile(
                  leading: _buildLeadingIcon(item),
                  title: Text(_buildTitle(item)),
                  subtitle: Text(_buildSubtitle(item)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => favProvider.removeFavorite(item),
                  ),
                  onLongPress: () => favProvider.removeFavorite(item), // Kept for alternative removal
                );
              },
            ),
    );
  }

  Widget _buildLeadingIcon(dynamic item) {
    if (item is Team) {
      return CachedNetworkImage(
        imageUrl: item.logo ?? '',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.sports_soccer),
      );
    } else if (item is Player) {
      return CachedNetworkImage(
        imageUrl: item.photo ?? '',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.person),
      );
    } else if (item is Competition) {
      return CachedNetworkImage(
        imageUrl: item.logo ?? '',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.emoji_events),
      );
    }
    return const SizedBox.shrink();
  }

  String _buildTitle(dynamic item) {
    if (item is Team) {
      return item.name;
    } else if (item is Player) {
      return item.name;
    } else if (item is Competition) {
      return item.name;
    }
    return 'Unknown Item';
  }

  String _buildSubtitle(dynamic item) {
    if (item is Team) {
      return item.city ?? 'N/A';
    } else if (item is Player) {
      return 'Age: ${item.age ?? 'N/A'} | Position: ${item.position ?? 'N/A'}';
    } else if (item is Competition) {
      return 'Country: ${item.country ?? 'N/A'}';
    }
    return 'N/A';
  }
}