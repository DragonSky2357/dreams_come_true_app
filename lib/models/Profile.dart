class Profile {
  String? email;
  String? username;
  String? avatar;
  String? introduce;
  List<Post>? post;

  Profile({this.email, this.username, this.avatar, this.introduce, this.post});

  Profile.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    avatar = json['avatar'];
    introduce = json['introduce'];
    if (json['post'] != null) {
      post = <Post>[];
      json['post'].forEach((v) {
        post!.add(Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['avatar'] = avatar;
    data['introduce'] = introduce;
    if (post != null) {
      data['post'] = post!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Post {
  String? id;
  String? title;
  String? describe;
  String? image;
  String? createdAt;
  String? updatedAt;

  Post(
      {this.id,
      this.title,
      this.describe,
      this.image,
      this.createdAt,
      this.updatedAt});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    describe = json['describe'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['describe'] = describe;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
