import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/competition.dart';

class ApiService {
  final String baseUrl = 'https://v3.football.api-sports.io';
  final String apiKey = 'apikey'; // Ensure this is valid

  Map<String, String> get headers => {
        'x-rapidapi-key': apiKey, // Corrected header name
        'x-rapidapi-host': 'v3.football.api-sports.io', // Required host header
      };
  Future<List<Match>> fetchMatches() async {
    final now = DateTime.now();
    final date = now.toIso8601String().split('T')[0];
    final response = await http.get(
      Uri.parse('$baseUrl/fixtures?date=$date'),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    return (data['response'] as List).map((e) => Match.fromJson(e)).toList();
  }

  Future<List<Match>> fetchMatchesByStatus(String status) async {
    final now = DateTime.now();
    final date = now.toIso8601String().split('T')[0];
    final response = await http.get(
      Uri.parse('$baseUrl/fixtures?date=$date&status=$status'),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    return (data['response'] as List).map((e) => Match.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> fetchMatchDetails(int matchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/fixtures?id=$matchId'),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    return data['response'][0];
  }

  Future<List<Team>> searchTeams(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/teams?search=$query'),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    return (data['response'] as List).map((e) => Team.fromJson(e)).toList();
  }

  Future<List<Player>> searchPlayers(String query) async {
    List<Player> allPlayers = [];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/players/profiles?search=$query&page=$page'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('API Response for page $page: $data');
          if (data is Map && data['response'] != null && data['response'] is List) {
            final List<dynamic> responseList = data['response'] as List;
            if (responseList.isNotEmpty) {
              for (var item in responseList) {
                if (item is Map && item['player'] != null) {
                  final playerData = item['player'] as Map<String, dynamic>;
                  allPlayers.add(Player.fromJson(playerData));
                } else {
                  print('Invalid player data in response: $item');
                }
              }
              page++;
            } else {
              hasMore = false;
            }
          } else {
            print('Invalid response structure or empty response: $data');
            hasMore = false;
          }
        } else {
          print('Failed to load players: ${response.statusCode}, Body: ${response.body}');
          hasMore = false;
        }
      } catch (e) {
        print('Error fetching players: $e');
        hasMore = false;
      }
    }

    return allPlayers.isEmpty
        ? throw Exception('No players found for query: $query')
        : allPlayers;
  }

  Future<List<Competition>> searchCompetitions(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/leagues?search=$query'),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    return (data['response'] as List).map((e) => Competition.fromJson(e)).toList();
  }
}