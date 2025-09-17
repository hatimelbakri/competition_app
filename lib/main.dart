import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'pages/home_page.dart';
import 'providers/favorites_provider.dart';

void main() async {
  // Load the .env file as an asset
  await dotenv.load(fileName: '.env'); // Explicitly specify the file name
  runApp(const CompetitionApp());
}

class CompetitionApp extends StatelessWidget {
  const CompetitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Competition App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const HomePage(),
      ),
    );
  }
}