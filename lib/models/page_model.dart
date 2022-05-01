

class RawMyPage {
  RawMyPage({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  dynamic next;
  dynamic previous;
  List<MyPage>? results;

  factory RawMyPage.fromJson(Map<String, dynamic> json) => RawMyPage(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<MyPage>.from(json["results"].map((x) => MyPage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class MyPage {
  MyPage({
    required this.id,
    required this.admins,
    required this.followers,
    required this.name,
    required this.description,
    required this.slug,
    this.coverPicture,
    required this.isAdmin,
    required this.isFollowing,
  });

  int id;
  List<Admin> admins;
  List<dynamic> followers;
  String name;
  String description;
  String slug;
  dynamic coverPicture;
  bool isFollowing;
  bool isAdmin;


  factory MyPage.fromJson(Map<String, dynamic> json) => MyPage(
      id: json["id"] ?? 0,
      admins: List<Admin>.from(json["admins"].map((x) => Admin.fromJson(x))),
      followers: json["followers"] != null ? List<dynamic>.from(json["followers"].map((x) => x)) : [],
      name: json["name"],
      description: json["description"],
      slug: json["slug"],
      coverPicture: json["cover_picture"] ?? "https://cdn.icon-icons.com/icons2/910/PNG/512/page_icon-icons.com_71133.png",
      isAdmin: json["is_admin_of_page"],
      isFollowing: json["is_followed_by_user"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "admins": List<dynamic>.from(admins.map((x) => x.toJson())),
    "followers": List<dynamic>.from(followers.map((x) => x)),
    "name": name,
    "description": description,
    "slug": slug,
    "cover_picture": coverPicture,

  };
}

class Admin {
  Admin({
    required this.username,
    this.profilePicture,
  });

  String username;
  dynamic profilePicture;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    username: json["username"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "profile_picture": profilePicture,
  };
}

