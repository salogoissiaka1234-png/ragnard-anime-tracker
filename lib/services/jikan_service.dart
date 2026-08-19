import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class JikanService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  // Récupère les animes actuellement en diffusion (saison en cours)
  Future<List<Anime>> getCurrentSeasonAnimes() async {
    final response = await http.get(Uri.parse('$baseUrl/seasons/now'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['data'];
      return results.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des animes (${response.statusCode})');
    }
  }

  // Recherche d'animes par mot-clé
  Future<List<Anime>> searchAnimes(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/anime?q=$query&limit=15'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['data'];
      return results.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la recherche (${response.statusCode})');
    }
  }

  // Détails d'un anime précis (utile pour rafraîchir les infos de diffusion)
  Future<Anime> getAnimeDetails(int malId) async {
    final response = await http.get(Uri.parse('$baseUrl/anime/$malId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Anime.fromJson(data['data']);
    } else {
      throw Exception('Erreur lors du chargement des détails (${response.statusCode})');
    }
  }
}
