class UserDetails {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? bio;
  String? profilePicture;
  String? coverPicture;
  String? about;
  bool? isVerified;
  List<String>? interests;
  String? myInviteCode;
  int? followersCount;
  int? followingCount;

  UserDetails(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.bio,
      this.profilePicture,
      this.coverPicture,
      this.about,
      this.isVerified,
      this.interests,
      this.myInviteCode,
      this.followersCount,
      this.followingCount});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    bio = json['bio'];
    profilePicture = json['profile_picture'];
    coverPicture = json['cover_picture'];
    about = json['about'];
    isVerified = json['is_verified'];
    interests = json['interests'].cast<String>();
    myInviteCode = json['my_invite_code'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['bio'] = bio;
    data['profile_picture'] = profilePicture;
    data['cover_picture'] = coverPicture;
    data['about'] = about;
    data['is_verified'] = isVerified;
    data['interests'] = interests;
    data['my_invite_code'] = myInviteCode;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    return data;
  }
}