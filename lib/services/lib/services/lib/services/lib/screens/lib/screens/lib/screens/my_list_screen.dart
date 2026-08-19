import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/anime.dart';
import '../services/storage_service.dart';
import 'detail_screen.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  final StorageService _storage = StorageService();
  late Future<List<Anime>> _followedFuture;

  @override
  void initState() {
    super.initState();
    _followedFuture = _storage.getFollowedAnimes();
  }

  void _refresh() {
    setState(() {
      _followedFuture = _storage.getFollowedAnimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes animes suivis')),
      body: FutureBuilder<List<Anime>>(
        future: _followedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final animes = snapshot.data ?? [];
          if (animes.isEmpty) {
            return const Center(
                child: Text('Tu ne suis encore aucun anime.'));
          }
          return ListView.builder(
            itemCount: animes.length,
            itemBuilder: (context, index) {
              final anime = animes[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: anime.imageUrl,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(anime.title),
                subtitle: Text(anime.broadcastDay != null
                    ? 'Diffusion : ${anime.broadcastDay}'
                    : anime.status),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(anime: anime),
                    ),
                  );
                  _refresh();
                },
              );
            },
          );
        },
      ),
    );
  }
}
