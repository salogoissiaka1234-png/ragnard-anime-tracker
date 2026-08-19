class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final String synopsis;
  final String status;
  final double score;
  final String? nextEpisodeDate;
  final String? broadcastDay;
  final String? broadcastTime;
  final int? episodes;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.status,
    required this.score,
    this.nextEpisodeDate,
    this.broadcastDay,
    this.broadcastTime,
    this.episodes,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Titre inconnu',
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      synopsis: json['synopsis'] ?? 'Pas de description disponible.',
      status: json['status'] ?? 'Inconnu',
      score: (json['score'] ?? 0).toDouble(),
      broadcastDay: json['broadcast']?['day'],
      broadcastTime: json['broadcast']?['time'],
      episodes: json['episodes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'malId': malId,
      'title': title,
      'imageUrl': imageUrl,
      'synopsis': synopsis,
      'status': status,
      'score': score,
      'broadcastDay': broadcastDay,
      'broadcastTime': broadcastTime,
      'episodes': episodes,
    };
  }

  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      malId: map['malId'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      synopsis: map['synopsis'],
      status: map['status'],
      score: map['score'],
      broadcastDay: map['broadcastDay'],
      broadcastTime: map['broadcastTime'],
      episodes: map['episodes'],
    );
  }
}
