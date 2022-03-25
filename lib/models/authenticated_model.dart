class AuthenticatedUser {
  int id;
  String username;
  String accessToken;
  String refreshToken;

  AuthenticatedUser(
      {required this.id,
      required this.username,
      required this.accessToken,
      required this.refreshToken});

  factory AuthenticatedUser.fromDatabaseJson(Map<dynamic, dynamic> data) =>
      AuthenticatedUser(
        id: data['id'],
        username: data['username'],
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "username": this.username,
        "accessToken": this.accessToken,
        "refreshToken": this.refreshToken
      };

  AuthenticatedUser copyWith({
    required ApiTokenResponse tokens,
  }) =>
      AuthenticatedUser(
        id: id,
        username: username,
        accessToken: tokens.accessToken!,
        refreshToken: tokens.refreshToken!,
      );


  factory AuthenticatedUser.clearAuth() =>
      AuthenticatedUser(
        id: 0,
        username: '',
        accessToken: '',
        refreshToken: '',
      );
}
class ApiTokenResponse {
  String? username;
  String? accessToken;
  String? refreshToken;

  ApiTokenResponse({required this.accessToken, required this.refreshToken, this.username});

  factory ApiTokenResponse.fromJson(Map<String, dynamic> json) {
    return ApiTokenResponse(
        accessToken: json['access'], refreshToken: json['refresh'],
        username: json['username']);
  }

  factory ApiTokenResponse.updateAccessToken(Map<String, dynamic> json) {
    return ApiTokenResponse(
        accessToken: json['access'], refreshToken: json['refresh'],
        username: json['username']);
  }

  factory ApiTokenResponse.fromAuthUser(AuthenticatedUser authUser) {
    return ApiTokenResponse(
        accessToken: authUser.accessToken, refreshToken: authUser.refreshToken);
  }


  Map<String, dynamic> toDatabaseJson() =>
      {"accessToken": this.accessToken, "refreshToken": this.refreshToken};


}