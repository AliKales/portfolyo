class Work {
  String? id;
  String? title;
  String? description;
  List<Map>? images;
  String? thumbnail;
  String? github;
  String? playstore;
  String? appstore;
  String? youtube;

  Work(
      {this.title,
      this.description,
      this.images,
      this.thumbnail,
      this.github,
      this.playstore,
      this.appstore,
      this.youtube,
      this.id});

  Work.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    images = json['pics']?.cast<Map>();
    thumbnail = json['thumbnail'];
    github = json['github'];
    playstore = json['playstore'];
    appstore = json['appstore'];
    youtube = json['youtube'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['pics'] = images;
    data['thumbnail'] = thumbnail;
    data['github'] = github;
    data['playstore'] = playstore;
    data['appstore'] = appstore;
    data['youtube'] = youtube;
    data['id'] = id;
    return data;
  }
}
