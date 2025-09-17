import 'package:flutter/material.dart';
import '../models/match.dart';

class MatchProvider with ChangeNotifier {
  List<Match> _live = [];

  List<Match> get live => _live;

  void setLive(List<Match> data) {
    _live = data;
    notifyListeners();
  }
}
