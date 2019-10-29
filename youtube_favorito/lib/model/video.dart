class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video({this.id, this.channel, this.title, this.thumb});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'],
      channel: json['snippet']['channelTitle'],
      title: json['snippet']['title'],
      thumb: json['snippet']['thumbnails']['high']['url'],
    );
  }
  factory Video.fromLocalJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      channel: json['channel'],
      title: json['title'],
      thumb: json['thumb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "channel": channel,
      "title": title,
      "thumb": thumb,
    };
  }

  @override
  String toString() {
    return id + " " + title + "   " + thumb;
  }
}
