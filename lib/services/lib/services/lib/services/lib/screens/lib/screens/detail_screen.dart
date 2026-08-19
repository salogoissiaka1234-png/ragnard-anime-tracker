import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/anime.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class DetailScreen extends StatefulWidget {
  final Anime anime;
  const DetailScreen({super.key, required this.anime});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final StorageService _storage = StorageService();
  final NotificationService _notifications = NotificationService();
  bool _isFollowed = false;

  static const Map<String, int> _weekdayMap = {
    'Mondays': 1,
    'Tuesdays': 2,
    'Wednesdays': 3,
    'Thursdays': 4,
    'Fridays': 5,
    'Saturdays': 6,
    'Sundays': 7,
  };

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final followed = await _storage.isFollowed(widget.anime.malId);
    setState(() => _isFollowed = followed);
  }

  Future<void> _toggleFollow() async {
    if (_isFollowed) {
      await _storage.unfollowAnime(widget.anime.malId);
      await _notifications.cancelReminder(widget.anime.malId);
    } else {
      await _storage.followAnime(widget.anime);
      final weekday = _weekdayMap[widget.anime.broadcastDay ?? ''];
      if (weekday != null) {
        await _notifications.scheduleWeeklyReminder(
          id: widget.anime.malId,
          animeTitle: widget.anime.title,
          weekday: weekday,
          hour: 20,
          minute: 0,
        );
      }
    }
    setState(() => _isFollowed = !_isFollowed);
  }

  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: anime.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anime.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(' ${anime.score}'),
                      const SizedBox(width: 16),
                      Text(anime.status),
                    ],
                  ),
                  if (anime.broadcastDay != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Diffusion : ${anime.broadcastDay} ${anime.broadcastTime ?? ''}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _toggleFollow,
                    icon: Icon(_isFollowed ? Icons.check : Icons.add),
                    label: Text(_isFollowed
                        ? 'Suivi (rappel activé)'
                        : 'Suivre + activer rappel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isFollowed ? Colors.green : Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Synopsis',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(anime.synopsis),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
