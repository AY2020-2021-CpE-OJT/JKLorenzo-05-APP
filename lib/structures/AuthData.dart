class AuthData {
  String? id;
  String? token;

  AuthData({this.id, this.token});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      id: json['id'],
      token: json['token'],
    );
  }

  toJson() {
    return {
      "id": this.id,
      "token": this.token,
    };
  }
}
