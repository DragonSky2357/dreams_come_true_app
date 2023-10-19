class Post {
  String? id;
  String? title;
  String? describe;
  String? image;
  Writer? writer;
  int? views;
  int? likes;
  List<Tags>? tags;
  String? createdAt;
  Post(
      {this.id,
      this.title,
      this.describe,
      this.image,
      this.views,
      this.writer,
      this.tags,
      this.createdAt});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    describe = json['describe'];
    image = json['image'];
    views = json['views'] as int;
    writer = json['writer'] != null ? Writer.fromJson(json['writer']) : null;
    views = json['views'];
    likes = json['likes'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['describe'] = describe;
    data['image'] = image;
    data['views'] = views;
    data['likes'] = likes;
    if (writer != null) {
      data['writer'] = writer!.toJson();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class Writer {
  String? username;
  String? avatar;

  Writer({this.username, this.avatar});

  Writer.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['avatar'] = avatar;
    return data;
  }
}

class Tags {
  String? id;
  String? name;

  Tags({this.id, this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
