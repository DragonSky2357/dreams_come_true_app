class HomeScreenPost {
  String? id;
  String? title;
  String? image;
  String? writer;

  HomeScreenPost({this.id, this.title, this.image, this.writer});

  HomeScreenPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    writer = json['writer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['writer'] = writer;
    return data;
  }
}
