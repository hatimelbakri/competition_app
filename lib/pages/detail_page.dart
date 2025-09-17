import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for image loading
import 'package:provider/provider.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/competition.dart';
import '../providers/favorites_provider.dart';

class DetailPage extends StatelessWidget {
  final dynamic item; // Can be Team, Player, Competition, or Coach
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item is Team
              ? item.name
              : item is Player
                  ? item.name
                  : item is Competition
                      ? item.name
                      : 'Details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display appropriate image based on type
            if (item is Team)
              CachedNetworkImage(
                imageUrl: item.logo ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.sports_soccer),
              )
            else if (item is Player)
              CachedNetworkImage(
                imageUrl: item.photo ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              )
            else if (item is Competition)
              CachedNetworkImage(
                imageUrl: item.logo ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.emoji_events),
              ),
            const SizedBox(height: 16),
            // Display details based on type
            if (item is Team)
              Column(
                children: [
                  Text('City: ${item.city ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                ],
              )
            else if (item is Player)
              Column(
                children: [
                  Text('Age: ${item.age ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                  Text('Position: ${item.position ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                ],
              )
            else if (item is Competition)
              Column(
                children: [
                  Text('Country: ${item.country ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            const SizedBox(height: 16),
            // Add to Favorites button (only for supported types)
            if (item is Team || item is Player || item is Competition)
              ElevatedButton(
                onPressed: () async {
                  await favProv.addFavorite(item);
                },
                child: const Text('Add to Favorites'),
              ),
          ],
        ),
      ),
    );
  }
}