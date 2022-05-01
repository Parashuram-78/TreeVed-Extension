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
        results: List<ListModel>.from(json["results"].map((x) => ListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "links": links.toJson(),
        "count": count,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Links {
  Links({
    this.next,
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
    required this.id,
    required this.userId,
    required this.user,
    required this.name,
    required this.slug,
    required this.dateCreated,
    required this.isDefault,
    required this.content,
    required this.imageThumbnail,
    required this.image,
    required this.description,
    required this.tags,
  });

  int id;
  int userId;
  UserDetail user;
  String name;
  String slug;
  DateTime dateCreated;
  bool isDefault;
  List<Content> content;
  String imageThumbnail;
  String image;
  String description;
  List<String> tags;

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        user: UserDetail.fromJson(json["user"]),
        name: json["name"] ?? "",
        slug: json["slug"] ?? "",
        dateCreated: DateTime.parse(json["date_created"]),
        isDefault: json["is_default"] ?? false,
        content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        imageThumbnail: json["image_thumbnail"] ?? "",
        image: json["image"] ?? "",
        description: json["description"] ?? "",
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user": user.toJson(),
        "name": name,
        "slug": slug,
        "date_created": dateCreated.toIso8601String(),
        "is_default": isDefault,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "image_thumbnail": imageThumbnail,
        "image": image,
        "description": description,
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class Content {
  Content({
    required this.id,
    required this.title,
    required this.notes,
    required this.url,
    required this.resourceType,
    required this.rating,
    required this.tags,
  });

  int id;
  String title;
  String notes;
  String url;
  String resourceType;
  String rating;
  List<String> tags;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        title: json["title"],
        notes: json["notes"],
        url: json["url"],
        resourceType: json["resource_type"],
        rating: json["rating"],
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "notes": notes,
        "url": url,
        "resource_type": resourceType,
        "rating": rating,
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class UserDetail {
  UserDetail({
    required this.id,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.profilePicture,
  });

  int id;
  String fullName;
  String username;
  String bio;
  String profilePicture;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        fullName: json["full_name"],
        username: json["username"],
        bio: json["bio"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "username": username,
        "bio": bio,
        "profile_picture": profilePicture,
      };
}
