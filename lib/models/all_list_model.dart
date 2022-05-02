// To parse this JSON data, do
//
//     final allList = allListFromJson(jsonString);

import 'dart:convert';


RawListModel allListFromJson(String str) =>
    RawListModel.fromJson(json.decode(str));

class RawListModel {
  RawListModel({
    required this.links,
    required this.count,
    required this.results,
  });

  Links links;
  int count;
  List<ListModel> results;

  factory RawListModel.fromJson(Map<String, dynamic> json) => RawListModel(
    links: Links.fromJson(json["links"]),
    count: json["count"],
    results: List<ListModel>.from(
        json["results"].map((x) => ListModel.fromJson(x))),
  );
}

class Links {
  Links({
    required this.next,
    this.previous,
  });

  dynamic next;
  dynamic previous;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    next: json["next"],
    previous: json["previous"],
  );

  Map<String, dynamic> toJson() => {
    "next": next,
    "previous": previous,
  };
}

class ListModel {
  ListModel({
    this.id,
    this.userId,
    this.user,
    this.name,
    this.description,
    this.tags,
    this.content,
    this.slug,
    this.isdefault,
    this.image,
    this.imagethumbnail,
  });

  int? id;
  int? userId;
  MyUser? user;
  String? name;
  String? description;
  List<dynamic>? tags;
  List<Content>? content;
  bool? isdefault;
  String? slug;
  String? mediatypes;
  String? image;
  String? imagethumbnail;

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
    id: json["id"],
    userId: json["user_id"],
    user: MyUser.fromJson(json["user"]),
    name: json["name"],
    description: json["description"],
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    content:
    List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
    slug: json['slug'],
    isdefault: json['is_default'],
    image: json['image'],
    imagethumbnail: json['image_thumbnail'],
  );

  String toApiRequestBody() {
    return jsonEncode(
        {"name": name, "description": description, "topics": tags});
  }
}

class Content {
  Content({
    this.id,
    this.title,
    this.notes,
    this.url,
    this.tags,
    this.resourceType,
    this.rating,
    required this.recentlyAdded
  });

  int? id;
  String? title;
  String? notes;
  String? url;
  List<String>? tags;
  String? resourceType;
  String? rating;
  bool recentlyAdded = false;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
      id: json["id"],
      title: json["title"],
      notes: json["notes"],
      url: json["url"],
      tags: List<String>.from(
        json["tags"].map((x) => x),
      ),
      resourceType: json["resource_type"] == "select" || json["resource_type"] == "" ? "other" : json["resource_type"] ?? "other" ,
      rating: json["rating"],
      recentlyAdded: false
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "notes": notes,
    "url": url,
    "tags": List<dynamic>.from(tags!.map((x) => x)),
  };
}

class MyUser {
  MyUser({
    required this.fullName,
    required this.username,
    required this.bio,
    required this.profilePicture,
  });

  String fullName;
  String username;
  String bio;
  String profilePicture;

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
      fullName: json["full_name"],
      username: json["username"],
      bio: json["bio"],
      profilePicture:
      json["profile_picture"] ?? "http://4.bp.blogspot.com/-zsbDeAUd8aY/US7F0ta5d9I/AAAAAAAAEKY/UL2AAhHj6J8/s1600/facebook-default-no-profile-pic.jpg");

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "username": username,
    "bio": bio,
    "profile_picture": profilePicture
  };
}


class RawPageListModel {
  RawPageListModel({
    required this.next,
    required this.previous,
    required this.count,
    required this.results,
  });

  String next;
  String previous;
  int count;
  List<ListModel> results;

  factory RawPageListModel.fromJson(Map<String, dynamic> json) => RawPageListModel(
   next: json["next"]  ?? "",
   previous: json["previous"] ?? "",
    count: json["count"],
    results: List<ListModel>.from(
        json["results"].map((x) => ListModel.fromJson(x))),
  );
}



