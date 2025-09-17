import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/team.dart';
import '../models/player.dart';
import '../models/competition.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For .env file

class FavoritesProvider with ChangeNotifier {
  final List<dynamic> _favorites = []; // Changed to dynamic to support multiple types

  List<dynamic> get favorites => _favorites;

  Future<void> addFavorite(dynamic item) async {
    // Check if item is one of the supported types
    if (item is! Team && item is! Player && item is! Competition) {
      return; // Ignore unsupported types
    }

    if (item is Team && (item.latitude == null || item.longitude == null) && item.city != null) {
      try {
        final apiKey = dotenv.env['OPENCAGE_API_KEY'] ?? '0996666309d4468fad3e7432f5ef410f'; // Your key
        final url = Uri.parse(
          'https://api.opencagedata.com/geocode/v1/json?q=${Uri.encodeComponent(item.city!)}&key=$apiKey&limit=1&no_annotations=1'
        );
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['results'] != null && data['results'].isNotEmpty) {
            final result = data['results'][0];
            item = Team(
              id: item.id,
              name: item.name,
              logo: item.logo,
              city: item.city,
              latitude: result['geometry']['lat'] as double,
              longitude: result['geometry']['lng'] as double,
            );
          }
        } else {
          print('Failed to geocode ${item.city}: ${response.statusCode}');
        }
      } catch (e) {
        print('Error geocoding ${item.city}: $e');
      }
    }

    // Extract id based on type
    final int? id = item is Team
        ? item.id
        : item is Player
            ? item.id
            : item is Competition
                ? item.id
                : null;

    if (id != null && !_favorites.any((fav) => _getId(fav) == id)) {
      _favorites.add(item);
      notifyListeners();
    }
  }

  void removeFavorite(dynamic item) {
    // Check if item is one of the supported types
    if (item is! Team && item is! Player && item is! Competition) {
      return; // Ignore unsupported types
    }

    final int? id = item is Team
        ? item.id
        : item is Player
            ? item.id
            : item is Competition
                ? item.id
                : null;

    if (id != null) {
      _favorites.removeWhere((fav) => _getId(fav) == id);
      notifyListeners();
    }
  }

  // Helper method to get id from any supported type
  int? _getId(dynamic item) {
    return item is Team
        ? item.id
        : item is Player
            ? item.id
            : item is Competition
                ? item.id
                : null;
  }
}