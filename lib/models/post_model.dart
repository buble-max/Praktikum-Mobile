class PostModel {
  int id, userId;
  String title, body;

  PostModel(this.id, this.userId, this.title, this.body);

  factory PostModel.fromJson(json) =>
      PostModel(json['id'], json['userId'], json['title'], json['body']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'body': body,
  };
}
