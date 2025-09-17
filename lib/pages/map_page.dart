import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import cached_network_image
import '../providers/favorites_provider.dart';
import '../models/team.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  double _currentZoom = 2;

  @override
  void initState() {
    super.initState();
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        final zoom = _mapController.camera.zoom;
        if (zoom != _currentZoom) {
          setState(() {
            _currentZoom = zoom;
          });
        }
      }
    });
  }

  List<Marker> _individualMarkers(List<Team> teams) {
    return teams.where((team) => team.latitude != null && team.longitude != null).map<Marker>((team) {
      return Marker(
        width: 50,
        height: 50,
        point: LatLng(team.latitude!, team.longitude!),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(team.name),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Removed City: ${team.city}
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
          child: CachedNetworkImage(
            imageUrl: team.logo,
            width: 50,
            height: 50,
            fit: BoxFit.contain, // Ensures the logo fits within the marker bounds
            placeholder: (context, url) => const CircularProgressIndicator(), // Loading indicator
            errorWidget: (context, url, error) => Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error, color: Colors.white),
            ), // Fallback on error
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final List<Team> favs = favProvider.favorites.whereType<Team>().toList();

    List<Marker> markers = _individualMarkers(favs);

    return Scaffold(
      appBar: AppBar(title: const Text('Teams Map')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: markers.isNotEmpty
              ? markers.first.point
              : const LatLng(20, 0),
          initialZoom: 2,
          minZoom: 2,
          maxZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.footballapp',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}