class RankingPost {
  String? id;
  String? title;
  String? image;
  Writer? writer;

  RankingPost({this.id, this.title, this.image, this.writer});

  RankingPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    writer = json['writer'] != null ? Writer.fromJson(json['writer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    if (writer != null) {
      data['writer'] = writer!.toJson();
    }
    return data;
  }
}

class Writer {
  String? username;

  Writer({this.username});

  Writer.fromJson(Map<String, dynamic> json) {
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    return data;
  }
}
