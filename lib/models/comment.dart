class Comment {
  final String body;
  final String author;

  const Comment({required this.body, required this.author});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(body: json['content'] ?? '', author: json['author'] ?? '');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          body == other.body &&
          author == other.author;

  @override
  int get hashCode => body.hashCode ^ author.hashCode;
}
