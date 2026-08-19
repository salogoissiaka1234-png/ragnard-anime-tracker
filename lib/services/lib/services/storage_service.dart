import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/anime.dart';

class StorageService {
  static const String _key = 'followed_animes';

  Future<List<Anime>> getFollowedAnimes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => Anime.fromMap(e)).toList();
  }

  Future<void> followAnime(Anime anime) async {
    final animes = await getFollowedAnimes();
    if (animes.any((a) => a.malId == anime.malId)) return;

    animes.add(anime);
    await _save(animes);
  }

  Future<void> unfollowAnime(int malId) async {
    final animes = await getFollowedAnimes();
    animes.removeWhere((a) => a.malId == malId);
    await _save(animes);
  }

  Future<bool> isFollowed(int malId) async {
    final animes = await getFollowedAnimes();
    return animes.any((a) => a.malId == malId);
  }

  Future<void> _save(List<Anime> animes) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(animes.map((a) => a.toMap()).toList());
    await prefs.setString(_key, data);
  }
}
